FROM ubuntu:16.04
MAINTAINER perambluate

# arguments
#ARG HOME=/home/t2
ARG MPIDIR=/opt
ARG APPDIR=/root
ARG HOST_MPI_DIR=mpi
ARG HOST_APP_DIR=benchmark
ARG INTEL_SN=intel_sn
ARG HOST_MODULEFILES_DIR=modulefiles
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

# intel
COPY ${INTEL_SN} ${MPIDIR}
COPY parallel_studio_xe_2020_cluster_edition.tgz ${MPIDIR}
RUN cd ${MPIDIR} && \
        tar zxvf parallel_studio_xe_2020_cluster_edition.tgz && \
        rm parallel_studio_xe_2020_cluster_edition.tgz && \
        cd parallel_studio_xe_2020_cluster_edition && \
        sed -ine 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg && \
        sed -ine 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/' silent.cfg && \
        sed -inre "s/\#ACTIVATION_SERIAL_NUMBER=snpat/ACTIVATION_SERIAL_NUMBER=$(cat ${MPIDIR}/${INTEL_SN})/" silent.cfg && \
        sed -ine 's/ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=serial_number/' silent.cfg && \
        ./install.sh --silent silent.cfg && \
        rm ${MPIDIR}/${INTEL_SN}

COPY ${HOST_MODULEFILES_DIR} ${APPDIR}/modulefiles
RUN source /etc/profile.d/modules.sh && \
        module use ${APPDIR}/modulefiles && \
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config