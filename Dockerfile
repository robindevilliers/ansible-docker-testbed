FROM centos:7
MAINTAINER robindevilliers@me.com 
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
RUN yum -y install rsyslog
RUN echo "root:root" | chpasswd
RUN useradd deploy
RUN echo "deploy:deploy" | chpasswd
RUN useradd postgres
RUN echo "postgres:postgres" | chpasswd
RUN useradd webapp
RUN echo "webapp:webapp" | chpasswd
#RUN echo -e "[Artifactory]\nname=Artifactory\nbaseurl=http://admin:letmein@172.17.0.9:8081/artifactory/rpm-local/\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/artifactory.repo
RUN yum -y install net-tools
RUN yum -y install sudo
RUN yum -y install wget 
RUN yum -y install cronie
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssh-server openssh-clients
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo -e "%deploy	ALL=(ALL)	NOPASSWD: ALL\n" >> /etc/sudoers
RUN systemctl enable sshd.service
RUN mkdir /home/deploy/.ssh
RUN chown -R deploy /home/deploy/.ssh; chgrp -R deploy /home/deploy/.ssh
CMD ["/usr/sbin/init"]
