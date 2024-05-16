setlocal ENABLEDELAYEDEXPANSION

@REM Check username provided
if "%~1"=="" (
    echo No username provided. usage 'scripts/docker_run.bat <username>'
    exit /b 1
)

set name=%1

REM Change into the parent directory of this folder
cd %~dp0..\
REM Get the current working directory, which is now the parent directory of this folder
set FOLDER=%cd%

REM change into the directory containing this script
cd %~dp0

REM mounts code in the docker container, and starts
docker run --rm -it -v "%FOLDER%/models":/app/2-training/models -v "%FOLDER%/input":/app/input --gpus=all -e PLAYER_NAME=%name% maia-individual:latest