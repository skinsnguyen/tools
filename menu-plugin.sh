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
if [ $? -eq 1 ]; then
    read -p "Plugin đã tồn tại, bạn muốn thay thế (Y/N): " confirm
        if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
            wp plugin install "$plugin_url" --activate --force --allow-root
        fi
 echo "Cài đặt thành công"
fi
}
# Hàm cài đặt và kích hoạt Theme
install_and_activate_theme() {
    theme_url=$1
    wp theme install "$theme_url" --activate --allow-root
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
##-Danh Sách Plugin
rocket="https://tool.kienthuclinux.info/plugin/wp-rocket_3.12.5.3.zip"
iThemesSecurityPro="https://tool.kienthuclinux.info/plugin/ithemes-security-pro-8.0.2.zip"
WPMUDevDashboard="https://tool.kienthuclinux.info/plugin/wpmu-dev-dashboard.zip"
SEORankMathPro="https://tool.kienthuclinux.info/plugin/seo-by-rank-math-pro.zip"
Elementskit="https://tool.kienthuclinux.info/plugin/elementskit-3.2.1.zip"
sitepressmultilingual="https://tool.kienthuclinux.info/plugin/sitepress-multilingual-cms.4.5.5.zip"
seedprod="https://tool.kienthuclinux.info/plugin/seedprod.zip"
wpstaging="https://tool.kienthuclinux.info/plugin/wp-staging-pro.zip"
migrationunlimitedextension="https://tool.kienthuclinux.info/plugin/all-in-one-wp-migration-unlimited-extension.zip"
allinonewpmigration="https://tool.kienthuclinux.info/plugin/all-in-one-wp-migration.zip"


#Theme-Astra
astrachild="https://tool.kienthuclinux.info/theme/astra-child.zip"
astra="https://tool.kienthuclinux.info/theme/astra.4.0.2.zip"
astraaddonplugin="https://tool.kienthuclinux.info/theme/astra-addon-plugin-4.0.1.zip"
astrapremiumsites="https://tool.kienthuclinux.info/theme/astra-premium-sites-3.1.24.zip"
wpschemapro="https://tool.kienthuclinux.info/theme/wp-schema-pro-2.7.4.zip"
ultimateelementor="https://tool.kienthuclinux.info/theme/ultimate-elementor-1.36.14.zip"
convertproaddon="https://tool.kienthuclinux.info/theme/convertpro-addon-1.5.5.zip"
bbultimateaddon="https://tool.kienthuclinux.info/theme/bb-ultimate-addon-1.35.3.zip"






# Menu Script
install_plugin() {
    echo "+---------------------------------------------+"
    echo "| Chọn Plugin mà bạn muốn cài:                |"
    echo "+---------------------------------------------+"
    echo "| 1.          WP-Rocket                       |"
    echo "| 2.      WPMU-Dev-Dashboard                  |"
    echo "| 3.      SEO-Rank-Math-Pro                   |"
    echo "| 4.       Elementskit.                       |"
    echo "| 5.      sitepress-multilingual              |"
    echo "| 6.        Seedprod                          |"
    echo "| 7.        Wpstaging                         |"
    echo "| 8.   all-in-one-wp-migration                |"
    echo "| 9.       Show tất cả plugin                 |"
    echo "| 10.          Xoá plugin                     |"
    echo "| 11.          Tắt plugin                     |"
    echo "| 12.       update plugin                     |"
    echo "| 13.     update plugin                       |"
    echo "| 0.     Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " choice_plugin
    case $choice_plugin in
        0) main_menu;;
        1) install_and_activate_plugin "$WPMUDevDashboard";;
        2) install_and_activate_plugin "$SEORankMathPro";;
        3) install_and_activate_plugin "$astrapremiumsites";;
        4) install_and_activate_plugin "$sitepressmultilingual";;
        5) install_and_activate_plugin "$seedprod";;
        6) install_and_activate_plugin "$wpstaging";;
        7) install_and_activate_plugin "$migrationunlimitedextension";;
        8) install_and_activate_plugin "$allinonewpmigration";;
        9) display_installed_plugins;;
        10) delete_plugin ;;
        11) disable_all_plugin ;;
        12) update_plugin ;;
        13) update_all_plugin ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

install_theme_astra() {
    echo "+---------------------------------------------+"
    echo "| Chọn Plugin mà bạn muốn cài:                |"
    echo "+---------------------------------------------+"
    echo "| 1.         astra-child                      |"
    echo "| 2.         astra                            |"
    echo "| 3.      Astra Addon Plugin                  |"
    echo "| 4.       Astra-premium-sites                |"
    echo "| 5.      wp-schema-pro                       |"
    echo "| 6.        wp-schema-pro                     |"
    echo "| 7.     convertpro-addon                     |"
    echo "| 8.         bb-ultimate-addon         |"
    echo "| 9.                            |"
    echo "| 10.                      |"
    echo "| 0. Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " choice_thems_astra
    case $choice_thems_astra in
        0) main_menu ;;
        1) install_and_activate_theme "$astrachild";;
        2) install_and_activate_theme "$astra";;
        3) install_and_activate_plugin "$astraaddonplugin";;
        4) install_and_activate_plugin "$astrapremiumsites";;
        5) install_and_activate_plugin "$wpschemapro";;
        6) install_and_activate_plugin "$ultimateelementor";;
        7) install_and_activate_plugin "$convertproaddon";;
        8) install_and_activate_plugin "$bbultimateaddon";;
        9) install_and_activate_plugin "$allinonewpmigration";;
        10) install_and_activate_plugin ;;
        11) display_installed_plugins ;;
        12) delete_plugin ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

install_themes(){
    echo "+---------------------------------------------+"
    echo "| Chọn cài đặt Theme muốn thực hiện:    |"
    echo "+---------------------------------------------+"
    echo "| 1. cai đặt theme aztra                           |"
    echo "| 2. Cài đặt Dvide                           |"
    echo "| 0. Thoát                                    |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " choice_theme
    case $choice_theme in
        0) exit ;;
        1) install_theme_astra ;;
        3) install_and_activate_theme ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}


#main_menu
main_menu() {
    # Các phần hiển thị thông tin máy chủ và hệ điều hành ở đây

    echo "+---------------------------------------------+"
    echo "| Chọn cài đặt Theme hoặc Plugin              |"
    echo "+---------------------------------------------+"
    echo "| 1. Cài Đặt Theme                            |"
    echo "| 2. Cài Đặt plugin                           |"
    echo "| 0. Thoát                                    |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " main_choice
    case $main_choice in
        0) exit ;;
        1) install_themes ;;
        2) install_plugin ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

main_menu

#rm -f ${pwdd}/plugin-cli-new.sh;
