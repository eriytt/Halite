FROM learningwell/halite_sandbox:latest

COPY core core
COPY networking networking
COPY tclap tclap
COPY Makefile main.cpp ./
COPY id_rsa /id_rsa
COPY publish.sh /publish.sh
COPY known_hosts /root/.ssh/known_hosts

RUN chmod 400 /id_rsa && make clean && make
