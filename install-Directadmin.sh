#!/bin/bash
# Tác giả: Nam-Nguyen
# Ngày: 06-10-2024
# Cập nhật: 17-03-2025

# Kiểm tra quyền root
if [[ "$EUID" -ne 0 ]]; then
    echo "==========================================="
    echo "Bạn cần chạy script này với quyền root."
    echo "Vui lòng sử dụng sudo hoặc đăng nhập dưới quyền root."
    echo "==========================================="
    exit 1
fi

# Thiết lập các biến môi trường
hostname=$(hostname)
export DA_EMAIL="email@kienthuclinux.info"
export DA_NS1="ns1.kienthuclinux.info"
export DA_NS2="ns2.kienthuclinux.info"
export DA_HOSTNAME="$hostname"
export php_imap="yes"

# Thiết lập hệ thống log
LOG_DIR="/var/log/directadmin_install"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"

# Hàm ghi log
log() {
    mkdir -p "$LOG_DIR"
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $*" | tee -a "$LOG_FILE"
}

log "==========================================="
log "Bắt đầu quá trình cài đặt DirectAdmin"
log "Thời gian: $(date)"
log "Hostname: $hostname"
log "==========================================="

# Tạo thư mục và tải cấu hình
log "Tạo thư mục /usr/local/directadmin/custombuild ..."
if ! mkdir -p /usr/local/directadmin/custombuild 2>> "$LOG_FILE"; then
    log "Không thể tạo thư mục /usr/local/directadmin/custombuild"
    exit 1
fi
#php1=7.4 php2=7.3 php3_=8.3 php4_=8.2 php5=8.0 mode=php-fpm
#webserver nginx_apache
log "Tải options.conf từ GitHub ..."
if ! wget -O /usr/local/directadmin/custombuild/options.conf \
    "https://raw.githubusercontent.com/skinsnguyen/tools/refs/heads/main/options.conf" 2>> "$LOG_FILE"; then
    log "Không thể tải options.conf"
    exit 1
fi

# Chuyển đến thư mục /root/
log "Chuyển đến thư mục /root/"
if ! cd /root/; then
    log "Không thể chuyển đến thư mục /root/"
    exit 1
fi

# Tải và thiết lập script cài đặt DirectAdmin
log "Tải script cài đặt DirectAdmin ..."
if ! wget -O setup.sh https://download.directadmin.com/setup.sh 2>> "$LOG_FILE"; then
    log "Không thể tải setup.sh từ DirectAdmin"
    exit 1
fi

log "Đặt quyền thực thi cho setup.sh"
if ! chmod +x setup.sh 2>> "$LOG_FILE"; then
    log "Không thể đặt quyền thực thi cho setup.sh"
    exit 1
fi

# Hàm kiểm tra cú pháp LICENSE_KEY
check_license_key() {
    local key="$1"
    # Kiểm tra xem key có rỗng không
    if [ -z "$key" ]; then
        return 1
    fi
    # Kiểm tra cú pháp Base64: chỉ chứa A-Z, a-z, 0-9, +, / và = ở cuối
    # Độ dài tối thiểu 43 ký tự (dựa trên ví dụ)
    if [[ "$key" =~ ^[A-Za-z0-9+/]+={0,2}$ ]] && [ ${#key} -ge 43 ]; then
        return 0
    else
        return 1
    fi
}

# Nhập và kiểm tra LICENSE_KEY
log "Yêu cầu nhập LICENSE_KEY"
while true; do
    read -s -p "Vui lòng nhập LICENSE_KEY của bạn: " LICENSE_KEY
    echo
    if check_license_key "$LICENSE_KEY"; then
        log "LICENSE_KEY hợp lệ"
        break
    else
        echo "LICENSE_KEY không hợp lệ. Vui lòng nhập lại."
        echo "Key phải là chuỗi Base64 hợp lệ (ví dụ: eZtc0j+N3CMYaQVvnE5GNQN8O2pxL2tPFQPxVqB6suI=)"
    fi
done

# Thực thi script cài đặt
log "Bắt đầu thực thi script cài đặt DirectAdmin với LICENSE_KEY"
if ! ./setup.sh "$LICENSE_KEY" 2>> "$LOG_FILE"; then
    log "Có lỗi xảy ra trong quá trình cài đặt DirectAdmin"
    log "Vui lòng kiểm tra log tại $LOG_FILE để biết thêm chi tiết"
    exit 1
else
    log "Cài đặt DirectAdmin thành công!"
    log "==========================================="
    log "Quá trình cài đặt hoàn tất vào $(date)"
    log "==========================================="
fi
