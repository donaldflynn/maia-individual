setlocal ENABLEDELAYEDEXPANSION
REM Change into the parent directory of this folder
cd %~dp0..\
REM Get the current working directory, which is now the parent directory of this folder
set FOLDER=%cd%

REM change into the directory containing this script
cd %~dp0

REM mounts code in the docker container, and starts
docker run --rm -it -v "%FOLDER%/final_models":/app/final_models -v "%FOLDER%/input":/app/input --gpus=all -e PLAYER_NAME="Red5551" --entrypoint /bin/bash maia-individual:latest