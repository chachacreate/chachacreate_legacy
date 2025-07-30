#!/bin/bash

echo "== 시작: db_init_setting_script.sh =="

sleep 30
# 1. system 계정으로 chacha 사용자 생성 및 권한 부여
echo "▶️ 사용자 chacha 생성 및 권한 부여"
sqlplus -s sys/oracle@localhost:1521/XE as sysdba @/temp/db_user_create.sql

# 2. chacha 계정으로 테이블 생성 SQL 실행
echo "▶️ chacha 계정으로 테이블 생성 시작"
sqlplus -s chacha/1234@//localhost:1521/XE @/temp/db_table_create.sql

echo "✅ 완료: db_init_setting_script.sh"
