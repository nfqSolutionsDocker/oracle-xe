# Oracle-XE

This container has the following characteristics:
- Container nfqsolutions/centos:7.
- The oracle directory is "/u01".
- Installations script of oracle in centos. This script copy oracle directory to volumen. This script is executing in the next containers or in the docker compose.
- You must unzip "oracle-xe-11.2.0-1.0.x86_64.rpm.zip" to your volumen "mydirectory". The path "mydirectory/Disk1/*.rpm" must exit.
- You must modify file "mydirectory/Disk1/response/xe.rsp". The password to users SYS and SYSTEM is environment variable, you must define in docker-compose.yml.

For example, docker-compose.yml:
```
app:
 image: nfqsolutions/oracle-xe-11g
 privileged: true
 restart: always
 container_name: oracle-xe-11g
 ports:
  - "1521:1521"
 environment:
  - PACKAGES=
 volumes:
  - <mydirectory>:/u01
 
```