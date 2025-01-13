#!/bin/bash
# Author: Namnh

# Hàm kiểm tra domain
check_domain() {
    local domain=$1
    local ip_sources=("https://ipv4.icanhazip.com" "https://api.ipify.org" "https://ipv4.ident.me/")
    local server_ip=""
    local domain_ip=$(dig +short $domain)

    # Lấy địa chỉ IP từ các nguồn
    for source in "${ip_sources[@]}"; do
        server_ip=$(curl -s $source)
        if [[ -n "$server_ip" ]]; then
            break
        fi
    done

    # Kiểm tra nếu không thể lấy được IP server
    if [[ -z "$server_ip" ]]; then
        echo "Không thể lấy địa chỉ IP của server."
        return 2  # Mã lỗi 2: Không lấy được IP server
    fi

    # So sánh IP của domain với IP server
    if [[ "$domain_ip" == "$server_ip" ]]; then
        return 0  # Domain đã trỏ đúng
    else
        return 1  # Domain chưa trỏ đúng
    fi
}

# Hàm cài đặt SSL cho main domain
install_ssl_main_domain() {
    read -p "Nhập vào domain chính: " main_domain

    check_domain $main_domain
    case $? in
        0)
            echo "Domain đã trỏ đúng. Tiến hành cài đặt SSL."
            wget -O - https://get.acme.sh | sh -s email=ssl@azdigi.info
            bash /home/*/.acme.sh/acme.sh --issue --webroot ~/public_html -d $main_domain -d www.$main_domain --keylength 2048 --force
            bash /home/*/.acme.sh/acme.sh --deploy --deploy-hook cpanel_uapi --domain $main_domain --domain www.$main_domain
            ;;
        1)
            echo "Domain chưa trỏ đúng IP. Hãy kiểm tra lại."
            ;;
        2)
            echo "Không thể lấy địa chỉ IP của server. Hãy thử lại sau."
            ;;
    esac
}

# Hàm cài đặt SSL cho addon domain
install_ssl_addon_domain() {
    read -p "Nhập vào addon domain: " addon_domain

    check_domain $addon_domain
    case $? in
        0)
            echo "Domain đã trỏ đúng. Tiến hành cài đặt SSL."
            wget -O - https://get.acme.sh | sh -s email=ssl@azdigi.info
            bash /home/*/.acme.sh/acme.sh --issue --webroot ~/$addon_domain -d $addon_domain -d www.$addon_domain --keylength 2048 --force
            bash /home/*/.acme.sh/acme.sh --deploy --deploy-hook cpanel_uapi --domain $addon_domain --domain www.$addon_domain
            ;;
        1)
            echo "Domain chưa trỏ đúng IP. Hãy kiểm tra lại."
            ;;
        2)
            echo "Không thể lấy địa chỉ IP của server. Hãy thử lại sau."
            ;;
    esac
}

# Hàm cài đặt SSL cho sub addon domain
install_ssl_sub_addon_domain() {
    read -p "Nhập vào sub addon domain: " sub_addon_domain

    check_domain $sub_addon_domain
    case $? in
        0)
            echo "Domain đã trỏ đúng. Tiến hành cài đặt SSL."
            wget -O - https://get.acme.sh | sh -s email=ssl@azdigi.info
            bash /home/*/.acme.sh/acme.sh --issue --webroot ~/$sub_addon_domain -d $sub_addon_domain --keylength 2048 --force
            bash /home/*/.acme.sh/acme.sh --deploy --deploy-hook cpanel_uapi --domain $sub_addon_domain
            ;;
        1)
            echo "Domain chưa trỏ đúng IP. Hãy kiểm tra lại."
            ;;
        2)
            echo "Không thể lấy địa chỉ IP của server. Hãy thử lại sau."
            ;;
    esac
}

# Script chính
echo "Các tuỳ chọn:"
echo "1. Cài đặt Main Domain"
echo "2. Cài đặt Addon Domain"
echo "3. Cài đặt Sub Addon Domain"
read -p "Nhập vào (1, 2, hoặc 3): " option

case $option in
    1)
        install_ssl_main_domain
        ;;
    2)
        install_ssl_addon_domain
        ;;
    3)
        install_ssl_sub_addon_domain
        ;;
    *)
        echo "Tuỳ chọn không hợp lệ. Vui lòng chọn 1, 2 hoặc 3."
        ;;
esac
