#!/bin/bash

# Cấu hình kết nối MySQL
MYSQL_USER="root"
MYSQL_PASSWORD="your_root_password"
MYSQL_HOST="localhost"  # Sử dụng localhost nếu MySQL chạy trên cùng máy

# Lấy thông tin từ MySQL
created_tmp_tables=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Created_tmp_tables';" | awk 'NR==2 {print $2}')
created_tmp_disk_tables=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" -e "SHOW GLOBAL STATUS LIKE 'Created_tmp_disk_tables';" | awk 'NR==2 {print $2}')

# Kiểm tra nếu giá trị không phải là số hoặc là zero để tránh chia cho zero
if ! [[ "$created_tmp_tables" =~ ^[0-9]+$ ]] || ! [[ "$created_tmp_disk_tables" =~ ^[0-9]+$ ]] || [ "$created_tmp_tables" -eq 0 ]; then
  echo "Error: Values are not valid numbers or Created_tmp_tables is zero."
  exit 1
fi
# Hiển thị giá trị Created_tmp_tables và Created_tmp_disk_tables
echo "Giá trị Created_tmp_tables là: $created_tmp_tables"
echo "Giá trị Created_tmp_disk_tables là: $created_tmp_disk_tables"
# Tính toán tỷ lệ
ratio=$(echo "scale=2; (($created_tmp_tables - $created_tmp_disk_tables) / $created_tmp_tables) * 100" | bc)

# Hiển thị kết quả
echo "Tỷ lệ ((Created_tmp_tables - Created_tmp_disk_tables) / Created_tmp_tables) * 100 là: $ratio"

# Kiểm tra nếu tỷ lệ nhỏ hơn 80, thực hiện tối ưu hóa
if [ $(echo "$ratio < 80" | bc) -eq 1 ]; then
  echo "Tỷ lệ thấp hơn 80. Cần tối ưu hóa!"
  # Thực hiện các hành động tối ưu hóa ở đây
fi
