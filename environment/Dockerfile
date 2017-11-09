FROM mntruell/halite_sandbox:latest

COPY core core
COPY networking networking
COPY tclap tclap
COPY Makefile main.cpp ./
COPY id_rsa /id_rsa

RUN make clean && make
