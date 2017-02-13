#!/bin/bash

set -e
source /oracle_installation/colorecho.sh
/solutions/install_packages.sh

echo_title "Execute oracle.sh file ..."

if [ ! -f ${ORACLE_HOME}/config/scripts/oracle-xe ]; then
	if [ ! -f /u01/Disk1/*.rpm ]; then
		echo_red "Fichero de instalacion rpm no encontrado, coloque el fichero de la forma oracle-xe-11.2.0-1.0.x86_64.rpm en el volumen definido del contenedor"
	else
		echo_command "Fichero de instalacion rpm encontrado"
		echo_command "Instalando oracle ..."
		sha1sum /u01/Disk1/*.rpm | grep -q "49e850d18d33d25b9146daa5e8050c71c30390b7"
		mv /usr/bin/free /usr/bin/free.bak
		printf "#!/bin/sh\necho Swap - - 2048" > /usr/bin/free
		chmod +x /usr/bin/free
		mv /sbin/sysctl /sbin/sysctl.bak
		printf "#!/bin/sh" > /sbin/sysctl
		chmod +x /sbin/sysctl
		yum localinstall -y /u01/Disk1/*.rpm | while read line; do echo_command "install: $line"; done
		rm /usr/bin/bc
		rm /usr/bin/free
		mv /usr/bin/free.bak /usr/bin/free
		rm /sbin/sysctl
		mv /sbin/sysctl.bak /sbin/sysctl
		sed -i -e 's/^\(memory_target=.*\)/#\1/' ${ORACLE_HOME}/config/scripts/initXETemp.ora
		sed -i -e 's/^\(memory_target=.*\)/#\1/' ${ORACLE_HOME}/config/scripts/init.ora
		echo_command "Configurando oracle ..."
		sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" ${ORACLE_HOME}/network/admin/listener.ora
		${ORACLE_HOME}/config/scripts/oracle-xe configure responseFile=/u01/Disk1/response/xe.rsp | while read line; do echo_command "configure: $line"; done
		${ORACLE_HOME}/config/scripts/oracle-xe start | while read line; do echo_command "start: $line"; done
		lsnrctl status | while read line; do echo_command "lsnrctl: $line"; done
	fi
else
	echo_command "Configurando oracle ..."
	sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" ${ORACLE_HOME}/network/admin/listener.ora
	source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh
	lsnrctl start | while read line; do echo_command "lsnrctl: $line"; done
	sqlplus / as sysdba <<-EOF |
		shutdown;
		startup;
		exit 0
	EOF
	while read line; do echo_command "sqlplus: $line"; done
	sleep 10
	lsnrctl status | while read line; do echo_command "lsnrctl: $line"; done
fi

/bin/bash