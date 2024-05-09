echo.
echo Building and pushing image
echo.

REM Switch current working directory to parent directory of this folder
cd %~dp0..\


docker buildx build  -t "donaldflynn/maia-individual:latest" --load .