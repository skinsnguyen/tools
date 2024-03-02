#!/bin/bash
# Nam-Nguyen
# 02-03-2024
# Kiểm tra
PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-12}; echo;`
echo "! !"
read -p "Step 1 : Điền User thiết lại ssh Key...:  " USER_SSH
while [[ $(grep -o "${USER_SSH}" /etc/passwd) ]]
do
echo ">> User ${USER_SSH} đã tồn tại."
read -p "Step 1 : Điền User thiết lại ssh Key...: " USER_SSH
done
useradd -m ${USER_SSH} -p ${PASSWORD} && echo ">> Tạo Thành Công ${USER_SSH}" || echo ">> Tạo ${USER_SSH} Không Thành Công"


echo
echo "Cấu hình SSH..."
echo "" >> /etc/ssh/sshd_config
echo "Match Group ${USER_SSH}" >> /etc/ssh/sshd_config
echo "   AuthorizedKeysFile /home/${USER_SSH}/.ssh/authorized_keys" >> /etc/ssh/sshd_config

