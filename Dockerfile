FROM nfqsolutions/centos:7

MAINTAINER solutions@nfq.com

# Ficheros que se utilizaran en la instalacion y en el funcionamiento normal
COPY oracle_installation /oracle_installation
RUN chmod -R 777 /oracle_installation && \
	chmod a+x /oracle_installation/oracle.sh && \
	chmod a+x /oracle_installation/colorecho.sh && \
	sed -i -e 's/\r$//' /oracle_installation/oracle.sh && \
	sed -i -e 's/\r$//' /oracle_installation/colorecho.sh

# Instalacion previa
RUN yum install -y libaio bc flex net-tools && \
	yum clean all && \
	rm -rf /var/lib/{cache,log} /var/log/lastlog
	
# Configurando usuarios
RUN groupadd -g 200 oinstall && usermod -a -G oinstall root && \
	groupadd -g 201 dba && usermod -a -G dba root && \
	sed -i "s/pam_namespace.so/pam_namespace.so\nsession    required     pam_limits.so/g" /etc/pam.d/login
	
# Variables de entorno
ENV ORACLE_VERSION=11.2.0 \
	ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe \
	ORACLE_SID=XE \
	NLS_LANG=AMERICAN.AL32UTF8 \
	PATH=$PATH:/u01/app/oracle/product/11.2.0/xe/bin

# Configurando sysctl
RUN echo "net.ipv4.ip_local_port_range = 9000 65500" > /etc/sysctl.conf && \
	echo "fs.file-max = 6815744" >> /etc/sysctl.conf && \
	echo "kernel.shmall = 10523004" >> /etc/sysctl.conf && \
	echo "kernel.shmmax = 6465333657" >> /etc/sysctl.conf && \
	echo "kernel.shmmni = 4096" >> /etc/sysctl.conf && \
	echo "kernel.sem = 250 32000 100 128" >> /etc/sysctl.conf && \
	echo "net.core.rmem_default=262144" >> /etc/sysctl.conf && \
	echo "net.core.wmem_default=262144" >> /etc/sysctl.conf && \
	echo "net.core.rmem_max=4194304" >> /etc/sysctl.conf && \
	echo "net.core.wmem_max=1048576" >> /etc/sysctl.conf && \
	echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
	
# Configurando limits files
RUN echo "root   soft   nproc   2047" >> /etc/security/limits.conf && \
	echo "root   hard   nproc   16384" >> /etc/security/limits.conf && \
	echo "root   soft   nofile   1024" >> /etc/security/limits.conf && \
	echo "root   hard   nofile   65536" >> /etc/security/limits.conf
	
# Volumenes para el docker
VOLUME /u01

# Puerto de salida del docker
EXPOSE 1521
EXPOSE 8080

# Configuracion supervisor
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]