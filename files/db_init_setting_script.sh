#!/bin/bash

echo "== 시작: db_init_setting_script.sh =="

sleep 5
# 1. system 계정으로 chacha 사용자 생성 및 권한 부여
echo "▶️ 사용자 chacha 생성 및 권한 부여"
sqlplus -s system/oracle <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE
CREATE USER chacha@localhost IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO chacha;
EXIT
EOF

# 2. chacha 계정으로 테이블 생성 SQL 실행
echo "▶️ chacha 계정으로 테이블 생성 시작"
sqlplus -s chacha/1234 @/docker-entrypoint-initdb.d/db_table_create.sql

echo "✅ 완료: db_init_setting_script.sh"
