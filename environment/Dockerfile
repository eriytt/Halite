FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y sudo
RUN apt-get install -y curl

RUN apt-get install -y libstdc++6 gcc g++ make python3 python3-pip python3-dev python3-numpy
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh
RUN apt-get install -y python-software-properties software-properties-common openjdk-8-jdk scala

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update
RUN apt-get install -y mono-devel ruby
RUN gem install bundler 

RUN apt-get install -y golang php build-essential
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs ocaml

RUN sh -c 'echo "$(curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein)" > /usr/bin/lein'
RUN chmod a+x /usr/bin/lein
RUN lein

RUN apt-get install -y git

RUN pip3 install numpy scipy scikit-learn pillow h5py
RUN pip3 install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.0rc0-cp35-cp35m-linux_x86_64.whl 
RUN pip3 install keras

RUN apt-get install -y julia

COPY core core
COPY networking networking
COPY tclap tclap
COPY Makefile main.cpp ./

RUN make clean && make
