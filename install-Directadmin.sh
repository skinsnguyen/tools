#!/bin/bash
# Tác giả: Nam-Nguyen
# Ngày: 06-10-2024

# =============================================
# Kiểm tra script có được chạy với quyền root
# =============================================

if [[ "$EUID" -ne 0 ]]; then
  echo "==========================================="
  echo "Bạn cần chạy script này với quyền root."
  echo "Vui lòng sử dụng sudo hoặc đăng nhập dưới quyền root."
  echo "==========================================="
  exit 1
fi

# =============================================
# Thiết lập các biến môi trường
# =============================================

# Lấy hostname của máy
hostname=$(hostname)

export DA_EMAIL=email@kienthuclinux.info
export DA_NS1=ns1.kienthuclinux.info
export DA_NS2=ns2.kienthuclinux.info
export DA_HOSTNAME="$hostname"
export php_imap=yes

# =============================================
# Thiết lập hệ thống log
# =============================================

# Tạo thư mục log nếu chưa tồn tại
LOG_DIR="/var/log/directadmin_install"
mkdir -p "$LOG_DIR"

# Đặt tên tệp log với thời gian thực
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"

# Hàm để ghi log với timestamp
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $*" | tee -a "$LOG_FILE"
}

log "==========================================="
log "Bắt đầu quá trình cài đặt DirectAdmin"
log "Thời gian: $(date)"
log "Hostname: $hostname"
log "==========================================="

# =============================================
# Tạo các thư mục cần thiết và tải cấu hình (nếu cần)
# =============================================

# Nếu bạn cần tạo các thư mục hoặc tải các cấu hình bổ sung, hãy bỏ comment các dòng dưới đây
# log "Tạo thư mục /usr/local/directadmin/custombuild ..."
mkdir -p /usr/local/directadmin/custombuild 2>&1 | tee -a "$LOG_FILE"
# log "Tải options.conf từ yourdomain.com ..."
#php1=7.4 php2=7.3 php3_=8.3 php4_=8.2 php5=8.0 mode=php-fpm
#webserver nginx_apache
wget -O /usr/local/directadmin/custombuild/options.conf "https://raw.githubusercontent.com/skinsnguyen/tools/refs/heads/main/options.conf" 2>&1 | tee -a "$LOG_FILE"
# log "Tạo thư mục /usr/local/directadmin/conf/ ..."
# mkdir -p /usr/local/directadmin/conf/ 2>&1 | tee -a "$LOG_FILE"
# log "Tải directadmin.conf từ yourdomain.com ..."
# wget -O /usr/local/directadmin/conf/directadmin.conf "http://yourdomain.com/directadmin.conf" 2>&1 | tee -a "$LOG_FILE"

# =============================================
# Tải và thiết lập DirectAdmin
# =============================================

# Chuyển đến thư mục /root/
log "Chuyển đến thư mục /root/"
cd /root/ || { log "Không thể chuyển đến thư mục /root/"; exit 1; }

# Tải script cài đặt DirectAdmin
log "Tải script cài đặt DirectAdmin từ https://download.directadmin.com/setup.sh"
wget -O setup.sh https://download.directadmin.com/setup.sh 2>&1 | tee -a "$LOG_FILE"
if [ $? -ne 0 ]; then
    log "Không thể tải setup.sh từ DirectAdmin."
    exit 1
fi

# Đặt quyền thực thi cho setup.sh
log "Đặt quyền thực thi cho setup.sh"
chmod +x setup.sh 2>&1 | tee -a "$LOG_FILE"

# =============================================
# Nhập LICENSE_KEY từ bàn phím
# =============================================

# Yêu cầu người dùng nhập LICENSE_KEY một cách an toàn (ẩn đầu vào)
read -s -p "Vui lòng nhập LICENSE_KEY của bạn: " LICENSE_KEY
echo

# Kiểm tra xem LICENSE_KEY đã được nhập hay chưa
if [ -z "$LICENSE_KEY" ]; then
    log "Bạn chưa nhập LICENSE_KEY. Đang thoát script."
    exit 1
fi

log "LICENSE_KEY đã được nhập."

# =============================================
# Thực thi script cài đặt với LICENSE_KEY
# =============================================

log "Bắt đầu thực thi script cài đặt DirectAdmin với LICENSE_KEY."

# Chạy setup.sh và ghi log
export DA_HOSTNAME="$hostname"
./setup.sh "$LICENSE_KEY" 2>&1 | tee -a "$LOG_FILE"

# Kiểm tra xem cài đặt có thành công không
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    log "Cài đặt DirectAdmin thành công!"
    log "==========================================="
    log "Quá trình cài đặt hoàn tất vào $(date)"
    log "==========================================="
else
    log "Có lỗi xảy ra trong quá trình cài đặt DirectAdmin."
    log "Please check the log file at $LOG_FILE for more details."
    exit 1
fi
