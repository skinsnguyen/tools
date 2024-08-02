#!/bin/bash
# Nam-Nguyen
# 02/08/2024
#Tăng các thống ở configurations all tất php
directory="/usr/local"
timess=$(date +"%Hh-%Mp-%F")
# Kiểm tra xem thư mục có tồn tại hay không
if [ -d "${directory}" ]; then
    configurations="disable_functions =exec,passthru,shell_exec,system,symlink,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source
allow_url_fopen=Off
allow_url_include=Off"

    for i in $(ls "${directory}" | grep 'php*'); do
        php_d_path="${directory}/${i}/lib/php.conf.d"
        nam_ini_file="${php_d_path}/namnh-${timess}.ini"

        echo "Adding configurations to ${nam_ini_file}"
        
        # Thêm cấu hình mà không kiểm tra xem file có tồn tại hay không
        echo "${configurations}" > "${nam_ini_file}"
        echo "Configurations added to ${nam_ini_file}"
    done
else
    echo "Thư mục ${directory} không tồn tại."
fi
