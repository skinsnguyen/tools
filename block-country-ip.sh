#!/bin/bash

# Hàm kiểm tra sự tồn tại của quốc gia trong danh sách
check_country() {
  country=$1

  # Đọc từ danh sách và kiểm tra sự tồn tại
  while IFS= read -r line; do
    if [ "$line" == "$country.zone" ]; then
      echo "Quốc gia $country có trong danh sách."
      return 0  # Sự tồn tại của quốc gia
    fi
  done < list-country.txt

  # Nếu không tìm thấy
  echo "Quốc gia $country không có trong danh sách."
  return 1  # Quốc gia không tồn tại
}

# Nhập quốc gia từ người dùng
read -p "Nhập tên quốc gia: " input_country

# Gọi hàm để kiểm tra
check_country "$input_country"
