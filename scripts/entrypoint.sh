#!/bin/bash

cd 1-data_generation || exit
./9-pgn_to_training_data.sh /app/input/input.pgn /app/processed "${PLAYER_NAME}"
cd ../2-training || exit
conda run -n transfer_chess python train_transfer.py final_config.yaml "${PLAYER_NAME}"