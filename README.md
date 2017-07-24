docker-oracle-xe-11g
============================

Oracle Express Edition 11g Release 2 on Ubuntu 14.04.1 LTS

### Installation

    docker pull nfqsolutions/ora-xe

Run with 8080 and 1521 ports opened:

    docker run -d -p 8080:8080 -p 1521:1521 nfqsolutions/ora-xe

Run with data on host and reuse it:

    docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle nfqsolutions/ora-xe

Run with customization of processes, sessions, transactions
This customization is needed on the database initialization stage. If you are using mounted folder with DB files this is not used:

    ##Consider this formula before customizing:
    #processes=x
    #sessions=x*1.1+5
    #transactions=sessions*1.1
    docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle\
    -e processes=1000 \
    -e sessions=1105 \
    -e transactions=1215 \
    nfqsolutions/ora-xe

Connect database with following setting:

    hostname: localhost
    port: 1521
    sid: xe
    username: system
    password: oracle

Password for SYS & SYSTEM:

    oracle


Auto import of sh sql and dmp files

    docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -v /my/oracle/init/sh_sql_dmp_files:/docker-entrypoint-initdb.d nfqsolutions/ora-xe

**In case of using DMP imports dump file should be named like ${IMPORT_SCHEME_NAME}.dmp**
**User credentials for imports are  ${IMPORT_SCHEME_NAME}/${IMPORT_SCHEME_NAME}**


**DOCKER-COMPOSE**

	bbdd:
     image: nfqsolutions/ora-xe
 	restart: always
	 ports:
      - "1522:22"
	  - "1521:1521"
	 volumes:
	  - ./volumenes/bbdd:/u01/app/oracle




**IMPORT BACKUP**

	docker exec \
    -it bbdd_container \
    impdp SYSTEM/oracle@localhost:1521/XE directory=DATA_PUMP_DIR dumpfile=back.dmp NOLOGFILE=Y



**EXPORT BACKUP**


    docker exec \
    -it bbdd_container \
    expdp SYSTEM/oracle@localhost:1521/XE directory=DATA_PUMP_DIR dumpfile=back.dmp NOLOGFILE=Y
