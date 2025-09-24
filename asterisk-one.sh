
#!/bin/bash
# Script cài đặt FreePBX (sử dụng Asterisk 20 LTS) trên Ubuntu 20.04 LTS
# Tác giả: Dựa trên yêu cầu của người dùng và các hướng dẫn hiện đại cho Ubuntu/Asterisk
# Cần chạy với quyền ROOT

# ----------------------------------------------------
# KHAI BÁO BIẾN (Có thể điều chỉnh)
# ----------------------------------------------------
ASTERISK_VERSION="20-current" # Hoặc "20-current" nếu muốn bản mới hơn 20 LTS
FREEPBX_VERSION="16.0-latest"
PHP_VERSION="7.4" # PHP 7.4 là phiên bản ổn định cho Ubuntu 20.04
DB_PASS="namhiou213HT" # THAY THẾ bằng mật khẩu phức tạp

# Tắt chế độ dừng khi có lỗi
set +e

echo "BẮT ĐẦU CÀI ĐẶT FREEPBX VÀ ASTERISK 20 TRÊN UBUNTU 20.04"
echo "----------------------------------------------------"

# --- PHẦN 1: CẬP NHẬT HỆ THỐNG VÀ CÀI ĐẶT GÓI CƠ BẢN ---
echo "1. Cập nhật hệ thống và cài đặt gói tiền đề..."
apt update && apt upgrade -y
apt install -y curl wget git build-essential autoconf libssl-dev libxml2-dev libncurses5-dev \
libnewt-dev libsqlite3-dev pkg-config uuid-dev subversion libtool-bin

# Cài đặt PHP, Apache và MariaDB
echo "2. Cài đặt Apache, MariaDB và PHP $PHP_VERSION..."
apt install -y apache2 mariadb-server php$PHP_VERSION php$PHP_VERSION-mysql php$PHP_VERSION-curl \
php$PHP_VERSION-gd php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-json php$PHP_VERSION-ldap \
php$PHP_VERSION-zip php$PHP_VERSION-bcmath php$PHP_VERSION-common php$PHP_VERSION-readline php$PHP_VERSION-cli

# Cấu hình PHP
sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/$PHP_VERSION/apache2/php.ini
systemctl restart apache2

# --- BƯỚC THỦ CÔNG: CẤU HÌNH MARIADB ---
echo -e "\n==================================================================="
echo "BƯỚC THỦ CÔNG (1/2): BẢO MẬT MARIADB"
echo "Vui lòng chạy lệnh: mysql_secure_installation"
echo "    - Không đặt mật khẩu cho user root MariaDB (Enter)"
echo "    - Nhấn Y cho các câu hỏi còn lại."
echo "Sau khi hoàn tất, nhấn Enter để tiếp tục script."
echo "==================================================================="
read -p "Nhấn ENTER để tiếp tục script sau khi đã chạy mysql_secure_installation..."

# Tạo Database và User
echo "3. Tạo Database và User cho Asterisk/FreePBX..."
mysql -u root <<EOF
CREATE DATABASE asterisk;
CREATE USER 'asteriskuser'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON asterisk.* TO 'asteriskuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Cấu hình Apache để sử dụng FreePBX
echo "4. Cấu hình Apache..."
# Cấu hình Apache user thành asterisk (Giống như CentOS, FreePBX chạy tốt nhất với quyền asterisk)
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf
systemctl restart apache2

# --- PHẦN 2: CÀI ĐẶT VÀ BIÊN DỊCH ASTERISK ---
echo "5. Tải mã nguồn Asterisk..."
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz
tar -xvzf asterisk-${ASTERISK_VERSION}.tar.gz
rm -f asterisk-${ASTERISK_VERSION}.tar.gz
#ASTERISK_DIR=$(tar -tf /usr/src/asterisk-${ASTERISK_VERSION}.tar.gz | head -1 | cut -f1 -d"/")
#cd $ASTERISK_DIR
cd asterisk-${ASTERISK_VERSION}

# Cài đặt các gói phụ thuộc và cấu hình
echo "6. Cài đặt các gói phụ thuộc của Asterisk và cấu hình..."
contrib/scripts/install_prereq install
./configure

# --- BƯỚC THỦ CÔNG: MAKE MENUSELECT ---
echo -e "\n==================================================================="
echo "BƯỚC THỦ CÔNG (2/2): ASTERISK MENUSELECT"
echo "Lệnh 'make menuselect' sẽ chạy. Vui lòng:"
echo "    1. Bật hỗ trợ MP3 (Core Sound Packages -> 'MP3 Source')."
echo "    2. Chọn các module cần thiết (Ví dụ: Format MP3)."
echo "    3. Lưu và Thoát (F12)."
echo "==================================================================="
make menuselect

# Tiếp tục biên dịch Asterisk
echo "7. Biên dịch và cài đặt Asterisk..."
make && make install
make samples # Cài đặt các file cấu hình mẫu
make config  # Cài đặt file khởi động
ldconfig

# Tạo user asterisk và phân quyền
echo "8. Tạo user 'asterisk' và phân quyền..."
useradd -m -c "Asterisk User" asterisk
chown -R asterisk:asterisk /var/lib/asterisk /var/log/asterisk /var/spool/asterisk /etc/asterisk
chown -R asterisk:asterisk /var/www/html # Đảm bảo Apache/FreePBX có quyền

# Tải các gói âm thanh chuẩn
echo "9. Tải các gói âm thanh..."
cd /var/lib/asterisk/sounds
wget -O core_sounds.tar.gz http://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
wget -O extra_sounds.tar.gz http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
tar xzf core_sounds.tar.gz && rm -f core_sounds.tar.gz
tar xzf extra_sounds.tar.gz && rm -f extra_sounds.tar.gz

# --- PHẦN 3: CÀI ĐẶT FREEPBX ---
echo "10. Cài đặt FreePBX..."
cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-${FREEPBX_VERSION}.tgz
tar xzf freepbx-${FREEPBX_VERSION}.tgz
rm -f freepbx-${FREEPBX_VERSION}.tgz
cd freepbx

# Cài đặt FreePBX
./start_asterisk start
./install -n --dbuser=asteriskuser --dbpass=${DB_PASS} --dbhost=localhost --dbname=asterisk

# Tạo service file cho FreePBX
echo "11. Cấu hình dịch vụ systemd cho FreePBX..."
cat << EOF > /etc/systemd/system/freepbx.service
[Unit]
Description=FreePBX VoIP Server
After=mariadb.service
[Service]
Type=forking
User=root
Group=root
ExecStart=/usr/sbin/fwconsole start
ExecStop=/usr/sbin/fwconsole stop
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

# Khởi động và kích hoạt dịch vụ
systemctl daemon-reload
systemctl enable freepbx
systemctl start freepbx

# Cấu hình Firewall UFW
echo "12. Cấu hình Firewall UFW (Mở cổng VoIP)..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 5060/udp
ufw allow 5061/udp
ufw allow 10000:20000/udp
ufw --force enable

echo -e "\n==================================================================="
echo "CÀI ĐẶT FREEPBX HOÀN TẤT!"
echo "Database Password: ${DB_PASS}"
echo "----------------------------------------------------"
echo "Truy cập: http://[IP_MÁY_CHỦ]/ để thiết lập tài khoản Admin."
echo "==================================================================="
