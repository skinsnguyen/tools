#!/bin/bash

TARGET_DIR="./"  # Đường dẫn thư mục chứa mã nguồn PHP cần sửa

echo "🚀 Bắt đầu sửa mã nguồn PHP 7 → PHP 8 tại: $TARGET_DIR"
echo "------------------------------------------------------"

# Quét tất cả file .php
find "$TARGET_DIR" -type f -name "*.php" | while read FILE; do
    echo "🛠️ Sửa file: $FILE"

    # 1. Thay create_function() bằng anonymous function (chỉ đơn giản hoá, chưa fix logic bên trong)
    perl -pi -e "s/create_function\s*\(\s*'([^']*)'\s*,\s*'([^']*)'\s*\)/function(\1) { \2 }/g" "$FILE"

    # 2. Thêm public cho magic methods __sleep / __wakeup
    sed -i 's/function __sleep(/public function __sleep(/g' "$FILE"
    sed -i 's/function __wakeup(/public function __wakeup(/g' "$FILE"

    # 3. Bỏ 'final' trong private final functions
    sed -i -E 's/private\s+final\s+function/private function/g' "$FILE"

    # 4. Sửa implode(array, glue) → implode(glue, array)
    sed -i -E 's/implode\((\$[a-zA-Z0-9_]+),\s*(\$[a-zA-Z0-9_]+)\)/implode(\2, \1)/g' "$FILE"

    # 5. Ghi chú lỗi toán tử ba ngôi lồng nhau
    grep -qE '\?[^:]+:[^?]+:[^;]+' "$FILE" && echo "⚠️ Toán tử ba ngôi cần sửa tay tại: $FILE" >> php8_manual_fix.txt

    # 6. Sửa lỗi: required parameter sau optional (chỉ gợi ý cho các dòng rõ ràng)
    sed -i -E 's/function ([a-zA-Z0-9_]+)\(([^)]*=[^,)]+),\s*(\$[a-zA-Z0-9_]+)\)/function \1(\2, \3 = null)/g' "$FILE"
done

echo "✅ Hoàn tất tự động sửa."
echo "📄 File cần kiểm tra thủ công: php8_manual_fix.txt"
