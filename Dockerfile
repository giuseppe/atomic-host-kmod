FROM centos:7
MAINTAINER "Giuseppe Scrivano" <gscrivan@redhat.com>
ENV container docker

RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs
RUN yum install -y "kmod-$(uname -r)" "kernel-devel-$(uname -r)" make "kernel-headers-$(uname -r)" "kernel-modules-$(uname -r)" gcc "kernel-$(uname -r)"

RUN yum -y update; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;

COPY Makefile hellomod.c install.sh uninstall.sh /

RUN make -C /

RUN yum remove -y kernel-devel make kernel-headers kernel-modules gcc && yum clean all

CMD ["/install.sh"]

