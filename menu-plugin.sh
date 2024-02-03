#!/bin/bash
# Nam-Nguyen
# 03-02-2024
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
pwdd=`pwd`


# Hàm cài đặt và kích hoạt plugin
install_and_activate_plugin() {
    plugin_url=$1
    wp plugin install "$plugin_url" --activate --allow-root
}
# Hàm cài đặt và kích hoạt Theme
install_and_activate_theme() {
    plugin_url=$1
    wp theme install "$plugin_url" --activate --allow-root
}
# Hàm hiển thị danh sách plugin đã cài đặt
display_installed_plugins() {
    wp plugin list --allow-root
}
# Hàm tắt alll plugin
disable_all_plugin() {
wp plugin deactivate --all --allow-root
}
# Hàm Enable all plugin alll plugin
enable_all_plugin() {
wp plugin activate --all --allow-root
}
# Hàm xoá plugin
delete_plugin() {
    # Hiển thị danh sách plugin
    wp plugin list --allow-root | awk 'NR > 2 {print $1}'
    # Nhập tên plugin cần xoá
    read -p "Nhập tên plugin cần xoá: " plugin_name
    # Kiểm tra xem plugin có tồn tại không
    if wp plugin list --allow-root | grep -q "$plugin_name"; then
        wp plugin deactivate "$plugin_name" --allow-root
        wp plugin delete "$plugin_name" --allow-root
        echo "Đã xoá plugin $plugin_name thành công."
    else
        echo "Không tìm thấy plugin $plugin_name."
    fi
}
# Hàm update plugin
update_plugin() {
    # Hiển thị danh sách plugin
    wp plugin list --allow-root | awk 'NR > 2 {print $1}'
    # Nhập tên plugin cần update_plugin
    read -p "Nhập tên plugin cần update: " plugin_update
    # Kiểm tra xem plugin có tồn tại không
    if wp plugin list --allow-root | grep -q "$plugin_update"; then
        wp plugin update "$plugin_update" --allow-root
        echo "Đã update plugin $plugin_update thành công."
    else
        echo "Không tìm thấy plugin $plugin_update."
    fi
}

#Hàm update all plugin
update_all_plugin() {
wp plugin update --all --allow-root
}

#Hàm Hiện Show Theme.
show_theme_list() {
wp theme list --allow-root
}







#rm -f ${pwdd}/plugin-cli-new.sh;
