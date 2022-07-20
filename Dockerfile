FROM ubuntu:18.04

COPY ./flocoin.conf /root/.flocoin/flocoin.conf

COPY . /flocoin
WORKDIR /flocoin

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

#upnp
RUN apt-get install -y libminiupnpc-dev

#ZMQ
RUN apt-get install -y libzmq3-dev

#GUI

RUN apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

RUN apt-get -y install libqrencode-dev

#build flocoin source
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

#open service port
EXPOSE 9888 9889

CMD ["flocoind", "--printtoconsole"]
