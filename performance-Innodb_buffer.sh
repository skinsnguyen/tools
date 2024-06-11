#!/bin/bash

# Cấu hình kết nối MySQL
MYSQL_USER="root"
MYSQL_PASSWORD="your_root_password"
MYSQL_HOST="localhost"  # Sử dụng localhost nếu MySQL chạy trên cùng máy

# Truy vấn MySQL để lấy giá trị của các thông số
read_requests=$(mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -sse "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_read_requests';" | awk '{ print $2 }')
reads=$(mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -sse "SHOW GLOBAL STATUS LIKE 'Innodb_buffer_pool_reads';" | awk '{ print $2 }')

# Kiểm tra xem các giá trị đã được lấy thành công chưa
if [ -z "$read_requests" ] || [ -z "$reads" ]; then
    echo "Lỗi: Không thể lấy giá trị từ MySQL."
    exit 1
fi

# In các giá trị read_requests và reads
echo "Innodb_buffer_pool_read_requests: $read_requests"
echo "Innodb_buffer_pool_reads: $reads"

# Tính toán hiệu suất của bộ nhớ đệm
performance=$(echo "scale=2; ($read_requests - $reads) * 100 / $read_requests" | bc)

# In kết quả
echo "Hiệu suất của bộ nhớ đệm InnoDB: $performance%"

# Kiểm tra hiệu suất và thông báo nếu cần thiết
if (( $(echo "$performance < 80" | bc -l) )); then
    echo "Cần tối ưu lại các thông số InnoDB vì hiệu suất dưới 80%."
fi
