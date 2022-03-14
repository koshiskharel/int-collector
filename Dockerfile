FROM docker/for-desktop-kernel:5.10.76-505289bcc85427a04d8d797e06cbca92eee291f4-amd64 AS ksrc

FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /
RUN apt-get update
RUN apt-get -y install python3 python3-distutils python3-pip
RUN apt-get -y install sudo bison build-essential cmake flex git libedit-dev \
   libllvm11 llvm-11-dev libclang-11-dev python zlib1g-dev libelf-dev libfl-dev\
    net-tools tcpdump iproute2


COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update
# Install BCC
RUN git clone https://github.com/iovisor/bcc.git
RUN mkdir bcc/build

WORKDIR bcc/build
RUN cmake ..
RUN make && make install

RUN cmake -DPYTHON_CMD=python3 ..
WORKDIR src/python
RUN make && make install

#Install requirements
WORKDIR /
COPY ./requirements.txt /
RUN pip3 install -r requirements.txt

COPY ./collector /INTcollector
WORKDIR /INTcollector

#ENV CLEAR n
COPY ./benchmark /INTcollector/benchmark

WORKDIR /root
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash

WORKDIR /INTcollector
#ENTRYPOINT python3 InDBClient.py $IFACE -H $INFLUX_ADDRESS -INFP $INFLUX_PORT -i $INT_PORT -D $DATABASE_NAME -p $PERIOD -P $EVENT_PERIOD \
#-T $THRESHOLDS_SIZE -l $LOG_LEVEL -l_rap $LOG_RAPORTS_LEVEL --clear $CLEAR

# python3 InDBClient.py veth_1 -H 0.0.0.0 -INFP $INFLUX_PORT -i $INT_PORT -D $DATABASE_NAME -p $PERIOD -P $EVENT_PERIOD


