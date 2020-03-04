FROM centos:centos7
MAINTAINER Luis Alexandre Deschamps Brandão <techmago@ymail.com>

ADD 90-devops.sh /etc/profile.d/90-devops.sh

RUN ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime && \
    echo "clean_requirements_on_remove=1" >> /etc/yum.conf && \
    echo "ip_resolve=4" >> /etc/yum.conf && \
    yum-config-manager --add-repo=https://techmago.sytes.net/rpm/techmago-centos.repo && \
    yum-config-manager --disable base updates extras centosplus && \
    yum -y install --nogpgcheck yum-utils && \
    yum -y update && \
    yum -y --nogpgcheck install openssh-server openssh-clients passwd vim iputils wget byobu net-tools rsync pigz pxz sudo bind-utils file tshark python && \
    yum clean all && rm -rf /var/cache/yum

WORKDIR /app
ADD ftpython /app/

expose 8000
ENTRYPOINT /app/ftpython
