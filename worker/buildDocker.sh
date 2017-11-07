docker build -t 'mntruell/halite_sandbox:latest' - < Dockerfile
docker save 'mntruell/halite_sandbox:latest' | gzip -c > halite_sandbox:latest.tar.gz
