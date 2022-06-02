FROM centos:centos7.9.2009
MAINTAINER Luis Alexandre Deschamps Brandão <techmago@ymail.com>

RUN ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
RUN echo "clean_requirements_on_remove=1" >> /etc/yum.conf && \
    echo "ip_resolve=4" >> /etc/yum.conf
RUN yum -y install epel-release && \
    yum -y install openssh-clients vim wget byobu net-tools rsync pigz pxz  \
                   bind-utils htop file telnet redis ansible git bash-completion-extras \
                   mariadb python36-pip postgresql && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

ADD 90-devops.sh /etc/profile.d/90-devops.sh

WORKDIR /app
ADD ftpython /app/

EXPOSE 8000
CMD /app/ftpython
