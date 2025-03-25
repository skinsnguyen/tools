#!/bin/bash
# Hoang-Nam
# 15/03/2025

# Định nghĩa mã màu ANSI
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Tìm kiếm các thư mục chiếm dụng nhiều Inodes trên VPS..."
echo "--------------------------------------------------"

# Thư mục gốc để bắt đầu tìm kiếm (thường là /)
ROOT_DIR="/"

# Số lượng thư mục hiển thị (top N)
TOP_N=10

# Kiểm tra tổng Inodes toàn hệ thống
TOTAL_INODES=$(df -i "$ROOT_DIR" | tail -1 | awk '{print $2}')
USED_INODES=$(df -i "$ROOT_DIR" | tail -1 | awk '{print $3}')
INODE_PERCENT=$(df -i "$ROOT_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')

echo "Tổng Inodes: $TOTAL_INODES, Đã dùng: $USED_INODES, Phần trăm: $INODE_PERCENT%"
echo "--------------------------------------------------"

# Tìm và đếm số tệp trong các thư mục con, sắp xếp theo số lượng
echo "Đang quét các thư mục con trong $ROOT_DIR (có thể mất thời gian)..."
find "$ROOT_DIR" -type d 2>/dev/null | while read -r dir; do
    FILE_COUNT=$(find "$dir" -type f 2>/dev/null | wc -l)
    echo "$FILE_COUNT $dir"
done | sort -rn | head -n "$TOP_N" | while read -r count dir; do
    # Tính phần trăm Inodes mà thư mục này chiếm
    PERCENT=$(echo "scale=2; $count * 100 / $TOTAL_INODES" | bc)

    # Chọn màu dựa trên số lượng tệp
    if [ "$count" -gt 10000 ]; then
        COLOR=$RED
    elif [ "$count" -gt 1000 ]; then
        COLOR=$YELLOW
    else
        COLOR=$GREEN
    fi

    # In kết quả với màu
    echo -e "${COLOR}Thư mục: $dir - Số tệp: $count (chiếm $PERCENT% tổng Inodes)${NC}"
done

echo "--------------------------------------------------"
echo "Hoàn tất. Các thư mục trên là top $TOP_N chiếm dụng nhiều Inodes nhất."

exit 0
