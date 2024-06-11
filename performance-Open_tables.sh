#!/bin/bash

# Cấu hình kết nối MySQL
MYSQL_USER="root"
MYSQL_PASSWORD="your_root_password"
MYSQL_HOST="localhost"  # Sử dụng localhost nếu MySQL chạy trên cùng máy

# Lấy thông tin từ MySQL
open_tables=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Open_tables';" | awk 'NR==2 {print $2}')
opened_tables=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Opened_tables';" | awk 'NR==2 {print $2}')

# Kiểm tra nếu giá trị không phải là số hoặc là zero để tránh chia cho zero
if ! [[ "$open_tables" =~ ^[0-9]+$ ]] || ! [[ "$opened_tables" =~ ^[0-9]+$ ]] || [ "$opened_tables" -eq 0 ]; then
  echo "Error: Values are not valid numbers or Opened_tables is zero."
  exit 1
fi

# Hiển thị giá trị Open_tables và Opened_tables
echo "Giá trị Open_tables là: $open_tables"
echo "Giá trị Opened_tables là: $opened_tables"

# Tính toán tỷ lệ
ratio=$(echo "scale=2; ($open_tables / $opened_tables) * 100" | bc)

# Hiển thị kết quả
echo "Tỷ lệ (Open_tables / Opened_tables) * 100 là: $ratio"

# Kiểm tra nếu tỷ lệ nhỏ hơn 80, thực hiện tối ưu hóa
if [ $(echo "$ratio < 80" | bc) -eq 1 ]; then
  echo "Tỷ lệ thấp hơn 80. Cần tối ưu hóa!"
  # Thực hiện các hành động tối ưu hóa ở đây
fi
