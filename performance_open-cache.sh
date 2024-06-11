#!/bin/bash

# Cấu hình kết nối MySQL
MYSQL_USER="root"
MYSQL_PASSWORD="your_root_password"
MYSQL_HOST="localhost"  # Sử dụng localhost nếu MySQL chạy trên cùng máy

# Lấy thông tin từ MySQL
open_table_definitions=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Open_table_definitions';" | awk 'NR==2 {print $2}')
opened_table_definitions=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Opened_table_definitions';" | awk 'NR==2 {print $2}')

# Kiểm tra nếu giá trị không phải là số hoặc là zero để tránh chia cho zero
if ! [[ "$open_table_definitions" =~ ^[0-9]+$ ]] || ! [[ "$opened_table_definitions" =~ ^[0-9]+$ ]] || [ "$opened_table_definitions" -eq 0 ]; then
  echo "Error: Values are not valid numbers or Opened_table_definitions is zero."
  exit 1
fi

# Hiển thị giá trị Open_table_definitions và Opened_table_definitions
echo "Giá trị Open_table_definitions là: $open_table_definitions"
echo "Giá trị Opened_table_definitions là: $opened_table_definitions"
# Tính toán tỷ lệ
ratio=$(echo "scale=2; ($open_table_definitions / $opened_table_definitions) * 100" | bc)

# Hiển thị kết quả
echo "Tỷ lệ (Open_table_definitions / Opened_table_definitions) * 100 là: $ratio"

# Kiểm tra nếu tỷ lệ nhỏ hơn 80, thực hiện tối ưu hóa
if [ $(echo "$ratio < 80" | bc) -eq 1 ]; then
  echo "Tỷ lệ thấp hơn 80. Cần tối ưu hóa!"
  # Thực hiện các hành động tối ưu hóa ở đây
fi
