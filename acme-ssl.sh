#!/bin/bash
# Nam-Nguyen
# 29-09-2024 

# Hàm kiểm tra tên miền hợp lệ
function is_valid_domain() {
    local domain=$1
    if [[ $domain =~ ^[a-zA-Z0-9.-]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Nhập tên miền chính
read -p "Nhập tên miền chính (ví dụ: example.com): " domain

# Kiểm tra tên miền hợp lệ không
if ! is_valid_domain "$domain"; then
    echo "Tên miền không hợp lệ. Vui lòng nhập lại."
    exit 1
fi

# Nhập tên miền phụ (www)
read -p "Nhập tên miền phụ (ví dụ: www.example.com) hoặc để trống nếu không có: " subdomain

# Nếu không nhập tên miền phụ, mặc định sẽ thêm www
if [ -z "$subdomain" ]; then
    subdomain="www.$domain"
fi

# Nhập đường dẫn thư mục web
read -p "Nhập đường dẫn đến thư mục web (ví dụ: /home/example.com/public_html): " webroot

# Kiểm tra nếu đường dẫn tồn tại
if [ ! -d "$webroot" ]; then
    echo "Thư mục web không tồn tại. Vui lòng kiểm tra lại."
    exit 1
fi
# tải acme về 
wget -O - https://get.acme.sh| sh

# Đăng ký email cho ACME nếu chưa có
read -p "Nhập email để đăng ký với ACME (ví dụ: email@example.com): " email
/root/.acme.sh/acme.sh --register-account -m "$email"

# Cấp chứng chỉ SSL cho domain
/root/.acme.sh/acme.sh --issue -d "$domain" -d "$subdomain" \
--cert-file /etc/letsencrypt/live/"$domain"/cert.pem \
--key-file /etc/letsencrypt/live/"$domain"/privkey.pem \
--fullchain-file /etc/letsencrypt/live/"$domain"/fullchain.pem \
-w "$webroot" --force

# Kiểm tra kết quả
if [ $? -eq 0 ]; then
    echo "Cấp chứng chỉ SSL thành công cho $domain và $subdomain."
else
    echo "Có lỗi xảy ra khi cấp chứng chỉ SSL."
fi
