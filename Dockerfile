FROM centos:centos7.9.2009

RUN ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
RUN echo "clean_requirements_on_remove=1" >> /etc/yum.conf && \
    echo "ip_resolve=4" >> /etc/yum.conf
RUN yum -y install epel-release && \
    yum -y install openssh-clients vim wget byobu net-tools rsync pigz pxz  \
                   bind-utils htop file telnet redis ansible git bash-completion-extras \
                   mariadb python36-pip postgresql && \
    yum clean all && rm -rf /var/cache/yum
RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

COPY 90-devops.sh /etc/profile.d/90-devops.sh

WORKDIR /app
COPY ftpython.py /app/

EXPOSE 8000
CMD ["/app/ftpython.py", "8000"]
