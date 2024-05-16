#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <arguments>"
    exit 1
fi

# Run trainingdata-tool.exe with the provided arguments
wine /tools/trainingdata-tool.exe "$@"
