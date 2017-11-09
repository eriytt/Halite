docker build -t 'learningwell/halite_sandbox:latest' - < Dockerfile
docker save 'learningwell/halite_sandbox:latest' | gzip -c > halite_sandbox.latest.tar.gz
