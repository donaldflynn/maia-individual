#!/bin/bash

# Install module
/opt/anaconda/bin/conda run -n transfer_chess python setup.py install

cd 1-data_generation || exit
# Replace double lines in input file with single https://github.com/CSSLab/maia-individual/issues/1
cat /app/input/input.pgn | sed '/^$/N;/^\n$/D' > /tmp/input_fixed.pgn
# Start data processing script
./9-pgn_to_training_data.sh /tmp/input_fixed.pgn /app/processed "${PLAYER_NAME}"

while pgrep trainingdata > /dev/null; do
  sleep 10
done
echo "Input games processed, beginning training...."

cd ../2-training || exit
cp -r /app/models /opt/anaconda/envs/transfer_chess/lib/python3.7/site-packages/backend-1.0.0-py3.7.egg/models
/opt/anaconda/bin/conda run -n transfer_chess --no-capture-output python train_transfer.py final_config.yaml