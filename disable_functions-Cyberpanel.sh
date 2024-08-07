#!/bin/bash
# Nam-Nguyen
# 07/08/2024
# Tăng các thống ở configurations all tất php

lsws_path="/usr/local/lsws"
timess=$(date +"%Hh-%Mp-%F")
if [ -d "${lsws_path}" ]; then
    configurations="disable_functions =exec,passthru,shell_exec,system,symlink,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source
allow_url_fopen=Off
allow_url_include=Off
"
for i in $(ls "${lsws_path}" | grep 'lsphp*'); do
        php_d_path="${lsws_path}/${i}/etc/php.d"
        nam_ini_file="${php_d_path}/namnh-security-cyberpanel.ini"

        echo "Adding configurations to ${nam_ini_file}"

        echo "${configurations}" >> "${nam_ini_file}"

        echo "Configurations added to ${nam_ini_file}"
    done
else
    echo "Thư mục ${lsws_path} không tồn tại."
fi
