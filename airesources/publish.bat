rem Team Number (Change this)
set TEAM_NUMBER=1
set SSH_SERVER=well.learningwell.se

..\compileInDocker.bat

docker run --rm -it -v "%PWD%":/bot -w / "learningwell/halite_dev" /publish.sh %TEAM_NUMBER% %SSH_SERVER%