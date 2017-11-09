@echo off

if exist run.sh (
    rem empty
) else (
    echo You should be in a bot catalog when running this script
    echo For example:
    echo ^> cd C++
    echo ^> ..\runGame.bat
    exit /b
)

set PWD=%cd:\=/%
set PWD=/%PWD::=%
set PWD=%PWD:C=c%
set PWD=%PWD:D=d%

del *.hlt
docker run --rm -t -v %PWD%:/bot -w /bot "learningwell/halite_dev" /bin/bash -c "ln -s /halite . ; /bot/runGame.sh"

for /r . %%i in (*.hlt) do ( 
    ..\..\..\Halite-Visualizer-win32-x64\Halite-Visualizer-win32-x64\Halite-Visualizer.exe open %%i
)