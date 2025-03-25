#!/bin/bash
# Hoang-Nam
# 25/03/2025
  
# Định nghĩa mã màu ANSI
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color (đặt lại màu mặc định)

# Ngưỡng Inodes sử dụng (phần trăm)
THRESHOLD_YELLOW=70  # Cảnh báo vàng
THRESHOLD_RED=90     # Cảnh báo đỏ

echo "Kiểm tra phần trăm Inodes đã sử dụng trên toàn bộ VPS:"
echo "--------------------------------------------------"

# Lấy thông tin Inodes từ tất cả các phân vùng
df -i | tail -n +2 | while read -r line; do
    # Trích xuất các cột cần thiết
    FILESYSTEM=$(echo "$line" | awk '{print $1}')
    INODES=$(echo "$line" | awk '{print $2}')
    IUSED=$(echo "$line" | awk '{print $3}')
    IFREE=$(echo "$line" | awk '{print $4}')
    IUSE_PERCENT=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT_POINT=$(echo "$line" | awk '{print $6}')

    # Kiểm tra nếu IUSE_PERCENT không rỗng
    if [ -n "$IUSE_PERCENT" ]; then
        echo "Phân vùng: $FILESYSTEM"
        echo "Điểm gắn kết: $MOUNT_POINT"
        echo "Tổng Inodes: $INODES, Đã dùng: $IUSED, Còn trống: $IFREE"

        # Chọn màu dựa trên phần trăm Inodes
        if [ "$IUSE_PERCENT" -ge "$THRESHOLD_RED" ]; then
            COLOR=$RED
            STATUS="CẢNH BÁO NGHIÊM TRỌNG: Inodes đã sử dụng ($IUSE_PERCENT%) vượt ngưỡng $THRESHOLD_RED%!"
        elif [ "$IUSE_PERCENT" -ge "$THRESHOLD_YELLOW" ]; then
            COLOR=$YELLOW
            STATUS="CẢNH BÁO: Inodes đã sử dụng ($IUSE_PERCENT%) vượt ngưỡng $THRESHOLD_YELLOW%!"
        else
            COLOR=$GREEN
            STATUS="AN TOÀN: Inodes đã sử dụng ($IUSE_PERCENT%) dưới ngưỡng $THRESHOLD_YELLOW%."
        fi

        # In thông báo với màu
        echo -e "${COLOR}${STATUS}${NC}"
        echo "--------------------------------------------------"
    fi
done

exit 0
