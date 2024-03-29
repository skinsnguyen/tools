#!/bin/bash
# Nam-Nguyen
# 02-03-2024
# Kiểm tra

#!/bin/bash

# Function to check if a user already exists
user_exists() {
    local username=$1
    [[ $(grep -o "${username}" /etc/passwd) ]]
}

# Function to generate a random password
generate_password() {
    local length=${1:-12}
    < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"${length}"; echo
}
# Kiểm tra User có trong sshd_config
user_exists_sshd_config() {
    local allowed_user="$1"
    local config_file="/etc/ssh/sshd_config"

    if grep -qE "^AllowUsers.*\b$allowed_user\b" "$config_file"; then
        return 0  # User exists in AllowUsers
    else
        return 1  # User does not exist in AllowUsers
    fi
}
# Function to create a new user
create_new_user() {
    local USER_SSH PASSWORD
    PASSWORD=$(generate_password)
    
    read -p "Step 1: Nhập tên người dùng để thiết lập SSH Key: " USER_SSH

    while user_exists "${USER_SSH}"; do
        echo ">> Người dùng ${USER_SSH} đã tồn tại."
        read -p "Chọn tên người dùng khác: " USER_SSH
    done

    useradd -m -d /home/${USER_SSH} -p ${PASSWORD} && echo ">> Tạo Thành Công ${USER_SSH}" || { echo ">> Tạo ${USER_SSH} Không Thành Công"; return 1; }
mkdir -p /home/${USER_SSH}/.ssh
ssh-keygen -f "/home/${USER_SSH}/.ssh/id_rsa" -t ed25519 -C "${USER_SSH}@namnh.com"
cp -rf /home/${USER_SSH}/.ssh/id_rsa.pub /home/${USER_SSH}/.ssh/authorized_keys
chmod 600 /home/${USER_SSH}/.ssh/authorized_keys
chmod 700 /home/${USER_SSH}/.ssh/
chmod go-w /home/${USER_SSH}/.ssh/
chmod go-w /home/${USER_SSH}/
chown -R ${USER_SSH}:${USER_SSH} /home/${USER_SSH}
chattr +i /home/${USER_SSH}/.ssh/authorized_keys

cat /home/${USER_SSH}/.ssh/authorized_keys
    
}

# Function to input key for an existing user
input_key_for_existing_user() {
    local USER_SSH
    read -p "Step 1: Nhập tên người dùng để thiết lập SSH Key: " USER_SSH

    if user_exists "${USER_SSH}"; then
        # Add logic to input key for existing user
        echo ">> Nhập key cho người dùng ${USER_SSH}"
    else
        echo ">> Người dùng ${USER_SSH} không tồn tại. Thoát."
        return 1
    fi
}

#Cấu hình ssh cho user
config_ssh(){
# Cấu hình SSH
echo "Cấu hình SSH..."
config_file="/etc/ssh/sshd_config"

# Kiểm tra xem file cấu hình tồn tại hay không
if [ ! -e "$config_file" ]; then
    echo "Lỗi: File cấu hình '$config_file' không tồn tại."
    exit 1
fi

# Thêm cấu hình vào file
echo "" >> "$config_file"
echo "Match Group ${USER_SSH}" >> "$config_file"
echo "   AuthorizedKeysFile /home/${USER_SSH}/.ssh/authorized_keys" >> "$config_file"
#Tắt xác thực bằng passwd và tắt ssh root
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-$(date +"%Hh-%Mp-%Ss-%F")
grep -E -i 'ChallengeResponseAuthentication|PasswordAuthentication|UsePAM|PermitRootLogin' /etc/ssh/sshd_config | sed -E 's/^\s*#*\s*([a-zA-Z]+[a-zA-Z0-9]*)\s+.*/\1 no/'
sed -i 's/^#*\s*PubkeyAuthentication\s*\(\(no\|yes\)\)/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Kiểm tra xem đã thêm thành công hay không
if [ $? -eq 0 ]; then
    echo "Đã thêm cấu hình thành công."
else
    echo "Lỗi: Không thể thêm cấu hình vào file."
fi
}

show_menu() {
    echo "----- Menu Lựa Chọn -----"
    echo "1. Tạo SSH Key"
    echo "2. Nhập key"
    echo "3. Thoát"
    echo "-------------------------"
}

get_user_choice() {
    read -p "Nhập lựa chọn của bạn (1-3): " choice
    case $choice in
        1) create_new_user ;;
        2) input_key_for_existing_user ;;
        3) echo "Thoát"; exit ;;
        *) echo "Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3." ;;
    esac
}

get_user_confirmation() {
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
