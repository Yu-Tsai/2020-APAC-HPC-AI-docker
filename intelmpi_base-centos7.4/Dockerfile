FROM centos:7.4.1708
MAINTAINER denny

# arguments
#ARG HOME=/home/t2
ARG MPIDIR=/opt
ARG APPDIR=/root
ARG INTEL_SN=../intel_sn
ARG HOST_MPI_TAR_FILE=../parallel_studio_xe_2020_cluster_edition.tgz
ARG HOST_MODULEFILES_DIR=../modulefiles
ENV DEBIAN_FRONTEND=noninteractive

# use bash as shell
SHELL ["/bin/bash", "-c"]

# yum
RUN yum update -y && yum install -y mlocate git \
               python3 curl \
               bc tree svn gcc gcc-c++ \
               vim net-tools wget make \
               pciutils gtk2 atk cairo \
               gcc-gfortran tcsh lsof \
               nfs-utils automake autoconf \
               tcl tcl-devel tk cmake \
               kernel-devel-3.10.0-1062.9.1.el7.x86_64 \
               kernel-devel-3.10.0-1062.el7.x86_64 \
               yum-utils \
               device-mapper-persistent-data \
               lvm2 \
               libuuid-devel \
               libseccomp-devel \
               squashfs-tools \
               alsa-lib \
               gettext-devel \
               environment-modules


# intel
COPY ${INTEL_SN} ${MPIDIR}
COPY ${HOST_MPI_TAR_FILE} ${MPIDIR}
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

# module file and root ssh permition
COPY ${HOST_MODULEFILES_DIR} ${APPDIR}/modulefiles
RUN source /etc/profile.d/modules.sh && \
        module use ${APPDIR}/modulefiles && \
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
