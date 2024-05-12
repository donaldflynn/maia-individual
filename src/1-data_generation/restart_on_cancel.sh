#!/bin/bash

# Define the command you want to execute if "conda" process is not running

while true; do
    # Check if the process with "conda" in the title is running
    if pgrep -f "conda" > /dev/null; then
        echo "Process with 'conda' in the title is running."
    else
        echo "Process with 'conda' in the title is not running. Executing command..."
        # Execute the command since "conda" process is not running
        /opt/anaconda/bin/conda run -n transfer_chess --no-capture-output python train_transfer.py final_config.yaml
    fi

    # Wait for a few seconds before checking again
    sleep 5
done
