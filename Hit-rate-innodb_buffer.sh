#!/bin/bash

# Đặt các biến đăng nhập MySQL
your_username="your_mysql_username"
your_password="your_mysql_password"
your_host="your_mysql_host"
your_database="your_mysql_database"

# Thực hiện truy vấn để lấy giá trị innodb_buffer_pool_reads và innodb_buffer_pool_read_requests
query="SELECT variable_name, variable_value FROM sys.metrics WHERE variable_name IN ('innodb_buffer_pool_reads', 'innodb_buffer_pool_read_requests');"
result=$(mysql -u "$your_username" -p"$your_password" -h "$your_host" -e "$query" "$your_database")

# Kiểm tra kết quả truy vấn
if [ $? -eq 0 ]; then
    # Lấy giá trị của innodb_buffer_pool_reads và innodb_buffer_pool_read_requests từ kết quả truy vấn
    reads=$(echo "$result" | grep 'innodb_buffer_pool_reads' | awk '{print $2}')
    read_requests=$(echo "$result" | grep 'innodb_buffer_pool_read_requests' | awk '{print $2}')

    # Tính toán Hit Rate
    if [ "$reads" != "" ] && [ "$read_requests" != "" ]; then
        hit_rate=$((100 * (1 - (reads / read_requests))))

        # In kết quả
        echo "Hit Rate: $hit_rate%"
    else
        echo "Error: Unable to extract values from the query result."
    fi
else
    echo "Error: MySQL query execution failed."
fi

#Nếu hit rate cao (gần 100%), điều này cho thấy rằng hệ thống đang hoạt động tốt và đáp ứng tốt các yêu cầu truy vấn.
#Ngược lại, nếu hit rate thấp (dưới 90%), điều này có thể cho thấy rằng kích thước của InnoDB buffer pool quá nhỏ hoặc yêu cầu truy vấn đang quá tải, dẫn đến việc đọc dữ liệu từ đĩa nhiều hơn, dẫn đến giảm hiệu suất của hệ thống.
#https://tech.cybozu.vn/mot-so-options-quan-trong-cua-innodb-buffer-pool-trong-mysql-cd1ee/
