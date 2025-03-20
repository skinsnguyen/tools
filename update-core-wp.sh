#!/bin/bash

echo "======================================="
echo "  Xóa danh sách tệp và cập nhật WordPress mới nhất"
echo "======================================="

# Kiểm tra quyền root
if [[ $EUID -eq 0 ]]; then
    echo "❌ Script không nên chạy với quyền root để tránh rủi ro. Vui lòng chạy với user thường."
    exit 1
fi

# Danh sách các tệp/thư mục cần xóa trước khi cập nhật
files_to_remove=(
    "index.php"
    "license.txt"
    "readme.html"
    "wp-activate.php"
    "wp-admin"
    "wp-blog-header.php"
    "wp-comments-post.php"
    "wp-config-sample.php"
    "wp-cron.php"
    "wp-includes"
    "wp-links-opml.php"
    "wp-load.php"
    "wp-login.php"
    "wp-mail.php"
    "wp-settings.php"
    "wp-signup.php"
    "wp-trackback.php"
    "xmlrpc.php"
)

# Kiểm tra xem đang ở thư mục WordPress hợp lệ không
if [ ! -f "wp-config.php" ] || [ ! -d "wp-content" ]; then
    echo "❌ Đây không phải thư mục WordPress hợp lệ. Vui lòng chạy script trong thư mục chứa wp-config.php và wp-content."
    exit 1
fi

# Sao lưu wp-config.php
echo "🔒 Đang sao lưu wp-config.php..."
cp wp-config.php wp-config.php.bak
if [[ $? -eq 0 ]]; then
    echo "✅ Đã tạo bản sao lưu: wp-config.php.bak"
else
    echo "❌ Lỗi khi sao lưu wp-config.php!"
    exit 1
fi

# Lấy danh sách phiên bản có sẵn từ API WordPress
echo "🌐 Đang lấy danh sách phiên bản từ API WordPress..."
versions=$(curl -s https://api.wordpress.org/core/version-check/1.7/ | grep -oP '(?<="version":")[^"]+' | head -n 10)
if [[ -z "$versions" ]]; then
    echo "❌ Không thể lấy danh sách phiên bản từ API. Kiểm tra kết nối mạng."
    exit 1
else
    echo "ℹ️ Các phiên bản khả dụng: $versions"
fi

# Nhập phiên bản từ người dùng
while true; do
    read -p "Nhập phiên bản WordPress muốn tải (Enter để tải bản mới nhất): " version
    
    if [[ -z "$version" ]]; then
        url="https://wordpress.org/latest.zip"
        file_name="wordpress-latest.zip"
        echo "📌 Không nhập phiên bản. Mặc định tải về bản mới nhất!"
        break
    else
        # Kiểm tra xem phiên bản có trong danh sách không
        if echo "$versions" | grep -qw "$version"; then
            url="https://downloads.wordpress.org/release/wordpress-${version}-no-content.zip"
            file_name="wordpress-${version}-no-content.zip"
            # Kiểm tra xem URL có tồn tại không
            if curl --head --silent --fail "$url" > /dev/null; then
                echo "✅ Phiên bản $version hợp lệ và sẵn sàng tải."
                break
            else
                echo "❌ Phiên bản $version không có gói 'no-content'. Vui lòng thử lại."
            fi
        else
            echo "❌ Phiên bản '$version' không hợp lệ hoặc không nằm trong danh sách! Vui lòng nhập lại."
            echo "ℹ️ Các phiên bản khả dụng: $versions"
        fi
    fi
done

# Xác nhận trước khi xóa và cập nhật
read -p "⚠️ Bạn có chắc chắn muốn xóa danh sách tệp và cập nhật WordPress phiên bản ${version:-mới nhất}? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "❌ Đã hủy thao tác."
    exit 0
fi

# Xóa các tệp/thư mục trong danh sách
echo "🗑️ Đang xóa các tệp/thư mục trong danh sách..."
for file in "${files_to_remove[@]}"; do
    if [ -e "$file" ]; then
        rm -rf "$file"
        echo "✅ Đã xóa: $file"
    else
        echo "⚠️ Không tìm thấy: $file"
    fi
done

# Tải xuống phiên bản đã chọn
echo "🔽 Đang tải về: $url ..."
wget -c "$url" -O "$file_name"

# Kiểm tra tải xuống
if [[ $? -eq 0 ]]; then
    echo "✅ Tải về thành công: $file_name"
    
    # Giải nén và ghi đè
    echo "📂 Đang giải nén và ghi đè..."
    unzip -o "$file_name" -d ./
    if [[ $? -eq 0 ]]; then
        mv wordpress/* ./ && rmdir wordpress
    else
        echo "❌ Lỗi khi giải nén!"
        exit 1
    fi
    
    # Xóa file zip
    rm "$file_name"
    echo "✅ Hoàn tất xóa và cập nhật phiên bản ${version:-mới nhất}!"
else
    echo "❌ Lỗi! Không thể tải về phiên bản đã chọn. Kiểm tra kết nối."
    exit 1
fi

# Khôi phục wp-config.php từ bản sao lưu
#if [ -f "wp-config.php.bak" ]; then
 #   mv wp-config.php.bak wp-config.php
 #   echo "✅ Đã khôi phục wp-config.php từ bản sao lưu"
#fi

# Hiển thị các tệp còn lại để kiểm tra
echo "📋 Danh sách tệp còn lại:"
ls -la

# Gợi ý bước tiếp theo
echo "ℹ️ Đừng quên kiểm tra website và chạy cập nhật database nếu cần qua /wp-admin!"
