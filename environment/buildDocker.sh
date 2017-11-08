docker build -t 'learningwell/halite_dev:latest' .
docker save 'learningwell/halite_dev:latest' | gzip -c > halite_dev.latest.tar.gz
