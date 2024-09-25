FROM docker.io/library/rockylinux:9.3

RUN ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
RUN echo "clean_requirements_on_remove=1" >> /etc/yum.conf && \
    echo "ip_resolve=4" >> /etc/yum.conf

    RUN dnf -y install epel-release && \
    dnf -y install openssh-clients vim wget byobu net-tools rsync pigz pxz  \
                   bind-utils htop file telnet redis ansible git bash-completion \
                   mariadb python3.11-pip postgresql && \
    dnf clean all && rm -rf /var/cache/yum

    RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

COPY 90-devops.sh /etc/profile.d/90-devops.sh

WORKDIR /app
COPY ftpython.py /app/

EXPOSE 8000
CMD ["/app/ftpython.py", "8000"]
