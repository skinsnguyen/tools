#!/bin/bash
# Nam-Nguyen
# 29-09-2024

# Hàm kiểm tra xem giá trị có trống hay không và yêu cầu nhập lại nếu cần
function check_empty_input() {
    while [[ -z "$1" ]]; do
        echo "Giá trị không được để trống. Vui lòng nhập lại."
        read -p "$2" INPUT
        set -- "$INPUT" "$2"
    done
    echo "$1"
}

# Yêu cầu người dùng nhập domain hoặc subdomain
read -p "Nhập tên domain hoặc subdomain (ví dụ: example.com hoặc sub.example.com): " DOMAIN
DOMAIN=$(check_empty_input "$DOMAIN" "Nhập tên domain hoặc subdomain (ví dụ: example.com hoặc sub.example.com): ")

# Tự động tạo email dựa trên domain
EMAIL="admin@$DOMAIN"

# Yêu cầu người dùng nhập Webroot (thư mục gốc của website)
read -p "Nhập đường dẫn webroot cho domain (ví dụ: /home/user/public_html): " WEBROOT
WEBROOT=$(check_empty_input "$WEBROOT" "Nhập đường dẫn webroot cho domain (ví dụ: /home/user/public_html): ")

# Hỏi người dùng xem đây có phải là subdomain không
read -p "Tên domain này có phải là subdomain không? (y/n): " IS_SUBDOMAIN

# Gán domain list tùy theo việc domain có phải là subdomain hay không
if [[ "$IS_SUBDOMAIN" == "y" ]]; then
    DOMAIN_LIST="-d $DOMAIN"
else
    DOMAIN_LIST="-d $DOMAIN -d www.$DOMAIN"
fi

# Xác nhận thông tin
echo "---------------------------------"
echo "Xác nhận thông tin:"
echo "Tên domain: $DOMAIN"
echo "Email: $EMAIL"
echo "Webroot: $WEBROOT"
echo "Subdomain: $IS_SUBDOMAIN"
echo "---------------------------------"
read -p "Bạn có chắc chắn muốn tiếp tục? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Quá trình cài đặt đã bị hủy."
    exit 1
fi

# Tạo log file
LOGFILE="$DOMAIN-acme.log"
touch $LOGFILE

# Tải và cài đặt acme.sh
echo "Đang tải và cài đặt acme.sh..." | tee -a $LOGFILE
wget -O - https://get.acme.sh | sh -s email=$EMAIL 2>&1 | tee -a $LOGFILE
if [[ $? -ne 0 ]]; then
    echo "Lỗi: Cài đặt acme.sh thất bại." | tee -a $LOGFILE
    exit 1
fi

# Tải lại bashrc để áp dụng thay đổi
source ~/.bashrc

# Sử dụng acme.sh để tạo chứng chỉ SSL
echo "Đang tạo chứng chỉ SSL cho $DOMAIN..." | tee -a $LOGFILE
acme.sh --issue --webroot $WEBROOT $DOMAIN_LIST --force 2>&1 | tee -a $LOGFILE
if [[ $? -ne 0 ]]; then
    echo "Lỗi: Tạo chứng chỉ SSL thất bại." | tee -a $LOGFILE
    exit 1
fi

# Triển khai chứng chỉ SSL trên cPanel sử dụng deploy hook
echo "Đang triển khai chứng chỉ SSL..." | tee -a $LOGFILE
acme.sh --deploy --deploy-hook cpanel_uapi --domain $DOMAIN 2>&1 | tee -a $LOGFILE
if [[ $? -ne 0 ]]; then
    echo "Lỗi: Triển khai chứng chỉ SSL thất bại." | tee -a $LOGFILE
    exit 1
fi

echo "Quá trình hoàn tất thành công!" | tee -a $LOGFILE
