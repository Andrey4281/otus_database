#!/bin/bash
docker exec -it hw9_otusdb mysql -uroot -p12345 -e "DROP DATABASE test"
docker exec -it hw9_otusdb mysql -uroot -p12345 -e "CREATE DATABASE test"
docker exec -it hw9_sysbench sh -c "sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-host=otusdb --mysql-port=3306 --mysql-user='root' --mysql-password='12345' --mysql-db=test --db-driver=mysql --tables=1 --table-size=10000000  --threads=80 prepare"
docker exec -it hw9_sysbench sh -c "sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-host=otusdb --mysql-port=3306 --mysql-user='root' --mysql-password='12345' --mysql-db=test --db-driver=mysql --tables=1 --table-size=10000000  --threads=80 run"
