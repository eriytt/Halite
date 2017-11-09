@echo off

rem Team Number (Change this)
set TEAM_NUMBER=19
set SSH_SERVER=well.learningwell.se

call ..\compileInDocker.bat

:: Check if using docker toolbox
docker ps >nul 2>&1 && (
    rem empty
) || (
    :: Make it possible to use docker commands
    FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
)

docker run --rm -it -v "%PWD%":/bot -w / "learningwell/halite_dev" /publish.sh %TEAM_NUMBER% %SSH_SERVER%