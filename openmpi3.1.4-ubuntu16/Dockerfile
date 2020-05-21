FROM ubuntu:16.04
MAINTAINER perambluate

# arguments
ARG MPIDIR=/opt
ARG APPDIR=/root
ENV DEBIAN_FRONTEND=noninteractive

# use bash as shell
SHELL ["/bin/bash", "-c"]

# apt
RUN apt update -y && \
        apt install -y --reinstall systemd iptables && \
        apt install -y \
        gcc g++ gfortran make cmake wget git ssh tcl python3 vim locate bash-completion\
        net-tools iputils-ping iproute2 curl \
        environment-modules \
        libnss3 libgtk2.*common libpango-1* libasound2* xserver-xorg cpio \
        libgtk-3-dev libssl-dev linux-headers-4.11.0-14-generic \
        autoconf automake \
        libibverbs-dev libatlas3-base \
        numactl libnuma-dev \
        tcl-dev tk-dev mesa-common-dev libjpeg-dev libtogl-dev

# openmpi
RUN cd ${MPIDIR} && \
    wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.gz && \
    tar xvf openmpi-3.1.4.tar.gz && cd openmpi-3.1.4 && \
    ./configure --prefix=${MPIDIR}/openmpi && \
    make -j$(nproc) && \
    make install -j$(nproc) && \
    echo 'export PATH=$PATH:/opt/openmpi/bin' >> /root/.bashrc && \
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/openmpi/lib' >> /root/.bashrc && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
