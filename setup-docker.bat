@echo off

:: Check if using docker toolbox
docker ps >nul 2>&1 && (
    rem empty
) || (
    :: Make it possible to use docker commands
    FOR /f "tokens=*" %%i IN ('docker-machine env default') DO %%i
)

echo Importing docker container, this might take a while!

docker load -i halite_dev.latest.tar

echo Done! Press enter!

pause

