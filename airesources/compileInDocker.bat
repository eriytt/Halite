@echo off

if exist run.sh (
    rem empty
) else (
    echo You should be in a bot catalog when running this script
    echo For example:
    echo ^> cd C++
    echo ^> ..\compileInDocker.bat
    exit /b
)

if exist compile.sh (
    rem empty
) else (
    echo This is not a compileable bot
    exit /b
)

:: Check if using docker toolbox
docker-machine >nul 2>&1 && (
    :: Make it possible to use docker commands
    FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
) || (
    echo fail
)

set PWD=%cd:\=/%
set PWD=/%PWD::=%
set PWD=%PWD:C=c%
set PWD=%PWD:D=d%

docker run --rm -it -v %PWD%:/bot -w / "learningwell/halite_dev" /bot/compile.sh