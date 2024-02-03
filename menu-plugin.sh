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


# Menu Script
install_plugin() {
    echo "+---------------------------------------------+"
    echo "| Chọn Script mà bạn muốn cài:                |"
    echo "+---------------------------------------------+"
    echo "| 1.                 |"
    echo "| 2.                          |"
    echo "| 3.                           |"
    echo "| 4.                     |"
    echo "| 5.                    |"
    echo "| 6.                          |"
    echo "| 7.                   |"
    echo "| 8.                           |"
    echo "| 9.                            |"
    echo "| 10.                      |"
    echo "| 0. Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " choice_plugin
    case $choice_plugin in
        0) install_and_activate_plugin ;;
        1) install_hostvn_script ;;
        2) install_hocvps ;;
        3) install_larvps ;;
        4) install_centmind_mod ;;
        5) install_tinovps_script ;;
        6) install_webinoly_script ;;
        7) install_easyengine_script ;;
        8) install_wordops_script ;;
        9) install_dlemp_script ;;
        10) install_lempstack ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

install_themes(){
    echo "+---------------------------------------------+"
    echo "| Chọn Control Panel mà bạn muốn cài:         |"
    echo "+---------------------------------------------+"
    echo "| 1. Cài đặt HestiaCP                         |"
    echo "| 2. Cài đặt CloudPanel                       |"
    echo "| 3. Cài đặt AApanel                          |"
    echo "| 4. Cài đặt FastPanel                        |"
    echo "| 5. Cài đặt CyberPanel                       |"
    echo "| 6. Cài đặt CWP (Control-WebPanel)           |"
    echo "| 7. Cài đặt Webmin                           |"
    echo "| 8. Cài đặt DirectAdmin                      |"
    echo "| 9. Cài đặt VestaCP                          |"
    echo "| 0. Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " control_panel_choice
    case $control_panel_choice in
        0) back_to_main_menu ;;
        1) install_hestiacp ;;
        2) install_cloudpanel ;;
        3) install_aapanel ;;
        4) install_fastpanel ;;
        5) install_cyberpanel ;;
        6) install_cwp ;;
        7) install_webmin ;;
        8) install_directadmin ;;
        9) install_vestacp ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}


#main_menu
main_menu() {
    # Các phần hiển thị thông tin máy chủ và hệ điều hành ở đây

    echo "+---------------------------------------------+"
    echo "| Chọn loại cài đặt mà bạn muốn thực hiện:    |"
    echo "+---------------------------------------------+"
    echo "| 1. cai đặt theme                            |"
    echo "| 2. Cài đặt plugin                           |"
    echo "| 0. Thoát                                    |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " main_choice
    case $main_choice in
        0) exit ;;
        1) install_plugin ;;
        2) install_themes ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

main_menu

#rm -f ${pwdd}/plugin-cli-new.sh;
