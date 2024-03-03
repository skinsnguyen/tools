#!/bin/bash
# Nam-Nguyen
# 02-03-2024
# Kiểm tra



echo
echo "Cấu hình SSH..."
echo "" >> /etc/ssh/sshd_config
echo "Match Group ${USER_SSH}" >> /etc/ssh/sshd_config
echo "   AuthorizedKeysFile /home/${USER_SSH}/.ssh/authorized_keys" >> /etc/ssh/sshd_config

#Tạo user passwd và kiểm tra user.
function create_user_ssh(){
PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-12}; echo;`
echo "! !"
read -p "Step 1 : Điền User thiết lại ssh Key...:  " USER_SSH
while [[ $(grep -o "${USER_SSH}" /etc/passwd) ]]
do
echo ">> User ${USER_SSH} đã tồn tại."
read -p "Step 1 : Điền User thiết lại ssh Key...: " USER_SSH
done
useradd -m ${USER_SSH} -p ${PASSWORD} && echo ">> Tạo Thành Công ${USER_SSH}" || echo ">> Tạo ${USER_SSH} Không Thành Công"
mkdir -p /home/${USER_SSH}/.ssh && chown ${USER_SSH}:${USER_SSH} /home/${USER_SSH}/.ssh && chmod 400 /home/${USER_SSH}/.ssh && echo ">> Sucess create /home/${USER_SSH}/.ssh drectory" || echo ">> Fail create /home/${USER_SSH}/.ssh directory"
}

function create_ssh_key() {
    # Thực hiện các lệnh để tạo SSH Key
    echo "Bắt đầu quá trình tạo SSH Key..."
    
    # Gọi các lệnh tạo SSH Key tại đây
}

function enter_existing_key() {
    # Thực hiện các lệnh để nhập key
    echo "Bắt đầu quá trình nhập key..."
    
    # Gọi các lệnh nhập key tại đây
}

function show_menu() {
    echo "----- Menu Lựa Chọn -----"
    echo "1. Tạo SSH Key"
    echo "2. Nhập key"
    echo "3. Thoát"
    echo "-------------------------"
}

function get_user_choice() {
    read -p "Nhập lựa chọn của bạn (1-3): " choice
    case $choice in
        1) create_ssh_key ;;
        2) enter_existing_key ;;
        3) echo "Thoát"; exit ;;
        *) echo "Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3." ;;
    esac
}

function get_user_confirmation() {
local max_attempts=5
local attempts=0
    while [ "$attempts" -lt "$max_attempts" ]; do
        show_menu
        get_user_choice

        # Tăng số lần thử nếu lựa chọn không hợp lệ
        [ $? -ne 0 ] && attempts=$((attempts + 1))
    done

    if [ "$attempts" -eq "$max_attempts" ]; then
        echo "Số lần thử quá giới hạn. Kết thúc quá trình."
    fi
}

# Gọi hàm
get_user_confirmation
