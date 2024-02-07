#!/bin/bash
# Nam-Nguyen
# 03-02-2024
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
pwdd=`pwd`

#set -x
dislay_play(){

#!/bin/bash

# Define color codes
COLOR1='\033[31m'    # Red
COLOR2='\033[32m'    # Green
COLOR3='\033[33m'    # Yellow
COLOR4='\033[34m'    # Blue
COLOR5='\033[35m'    # Purple
COLOR6='\033[36m'    # Cyan
COLOR7='\033[37m'    # White
RESET='\033[0m'      # Reset color

# Display text with colors
echo -e "${COLOR1}+===================================================================+${RESET}"
echo -e "${COLOR2}| ${COLOR3}_   _                                     _   _                   ${COLOR2}|${RESET}"
echo -e "${COLOR4}|| | | |  ___    __ _  _ __    __ _        | \\ | |  __ _  _ __ ___  ${COLOR4}|${RESET}"
echo -e "${COLOR5}|| |_| | / _ \\  / _\` || '_ \\  / _\` | _____ |  \\| | / _\` || '_ \` _ \\ ${COLOR5}|${RESET}"
echo -e "${COLOR6}||  _  || (_) || (_| || | | || (_| ||_____|| |\\  || (_| || | | | | |${COLOR6}|${RESET}"
echo -e "${COLOR7}||_| |_| \\___/  \\__,_||_| |_| \\__, |       |_| \\_| \\__,_||_| |_| |_|${COLOR7}|${RESET}"
echo -e "${COLOR1}|                             |___/                                 |${RESET}"
echo -e "${COLOR1}+==================== \033[32mhttps://kienthuclinux.info \033[31m===============================================+${RESET}"

}




##############################################################
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
if [ $? -eq 1 ]; then
    read -p "Theme đã tồn tại, bạn muốn thay thế (Y/N): " confirm
        if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
            wp theme install "$theme_url" --activate --force --allow-root
        fi
 echo "Cài đặt thành công Theme"
fi
}
##########################--Plugin--##########################
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
##########################--Theme--##########################
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

##-Theme-Divi
divi="https://tool.kienthuclinux.info/theme/divi/Divi.zip"
bloom="https://tool.kienthuclinux.info/theme/divi/bloom.zip"
divibuilder="https://tool.kienthuclinux.info/theme/divi/divi-builder.zip"
extra="https://tool.kienthuclinux.info/theme/divi/Extra.zip"
monarch="https://tool.kienthuclinux.info/theme/divi/monarch.zip"



# Menu Script
install_plugin() {
while true; do
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;34m| \033[0mChọn Plugin mà bạn muốn cài:                \033[1;34m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;32m| \033[0m1. \033[1;33mWP-Rocket                       \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m2. \033[1;36mWPMU-Dev-Dashboard              \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m3. \033[1;35mSEO-Rank-Math-Pro               \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m4. \033[1;31mElementskit.                   \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m5. \033[1;92msitepress-multilingual          \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m6. \033[1;93mSeedprod                        \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m7. \033[1;94mWpstaging                       \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m8. \033[1;95mall-in-one-wp-migration        \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m9. \033[1;96mShow tất cả plugin             \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m10. \033[1;91mXoá plugin                     \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m11. \033[1;35mTắt plugin                     \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m12. \033[1;34mupdate plugin                  \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m13. \033[1;36mupdate all plugin                \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m0. \033[1;92mQuay lại Menu Chính            \033[1;32m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
    read -p "Nhập vào lựa chọn: " choice_plugin
    case $choice_plugin in
        0) main_menu;break;;
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
done
}

install_theme_astra() {
while true; do
    echo -e "\033[1;31m+---------------------------------------------+\033[0m"
    echo -e "\033[1;31m| \033[0m   Chọn Theme và plugin Astra                \033[1;31m|\033[0m"
    echo -e "\033[1;32m+---------------------------------------------+\033[0m"
    echo -e "\033[1;32m| \033[0m1. \033[1;33mastra-child                      \033[1;32m|\033[0m"
    echo -e "\033[1;32m| \033[0m2. \033[1;34mastra                            \033[1;32m|\033[0m"
    echo -e "\033[1;32m| \033[0m3. \033[1;35mAstra Addon Plugin                  \033[1;32m|\033[0m"
    echo -e "\033[1;36m| \033[0m4. \033[1;91mAstra-premium-sites                \033[1;36m|\033[0m"
    echo -e "\033[1;36m| \033[0m5. \033[1;92mwp-schema-pro                       \033[1;36m|\033[0m"
    echo -e "\033[1;36m| \033[0m6. \033[1;93mUltimate Elementor                     \033[1;36m|\033[0m"
    echo -e "\033[1;36m| \033[0m7. \033[1;94mconvertpro-addon                     \033[1;36m|\033[0m"
    echo -e "\033[1;34m| \033[0m8. \033[1;95mbb-ultimate-addon                \033[1;34m|\033[0m"
    echo -e "\033[1;36m| \033[0m9. \033[1;92mLùi về Trước                       \033[1;36m|\033[0m"
    echo -e "\033[1;34m| \033[0m0. \033[1;96mQuay lại Menu Chính                \033[1;34m|\033[0m"
    echo -e "\033[1;32m+---------------------------------------------+\033[0m"
    read -p "Nhập vào lựa chọn: " choice_thems_astra
    case $choice_thems_astra in
        0) main_menu;break;;
        1) install_and_activate_theme "$astrachild";;
        2) install_and_activate_theme "$astra";;
        3) install_and_activate_plugin "$astraaddonplugin";;
        4) install_and_activate_plugin "$astrapremiumsites";;
        5) install_and_activate_plugin "$wpschemapro";;
        6) install_and_activate_plugin "$ultimateelementor";;
        7) install_and_activate_plugin "$convertproaddon";;
        8) install_and_activate_plugin "$bbultimateaddon";;
        9) install_themes;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
done
}
instal_theme_Divi() {
 while true; do
COLOR1='\033[0;31m'    # Red
COLOR2='\033[0;32m'    # Green
COLOR3='\033[0;33m'    # Yellow
COLOR4='\033[0;34m'    # Blue
COLOR5='\033[0;35m'    # Purple
COLOR6='\033[0;36m'    # Cyan
COLOR7='\033[0;37m'    # White
RESET='\033[0m'

echo -e "${COLOR1}+---------------------------------------------+${RESET}"
echo -e "${COLOR2}| ${COLOR3}Chọn cài đặt Theme Divi                      ${COLOR2}|${RESET}"
echo -e "${COLOR4}+---------------------------------------------+${RESET}"
echo -e "${COLOR5}| ${COLOR6}1. Theme Divi                               ${COLOR5}|${RESET}"
echo -e "${COLOR7}| ${COLOR1}2. DIVI BUILDER                             ${COLOR7}|${RESET}"
echo -e "${COLOR2}| ${COLOR3}3. EXTRA Magazine Theme                     ${COLOR2}|${RESET}"
echo -e "${COLOR4}| ${COLOR5}4. BLOOM Email Opt-in Plugin                ${COLOR4}|${RESET}"
echo -e "${COLOR6}| ${COLOR7}5. MONARCH Social Share & Follow Plugin     ${COLOR6}|${RESET}"
echo -e "${COLOR1}| ${COLOR2}6. Quay về Trước                            ${COLOR1}|${RESET}"
echo -e "${COLOR3}| ${COLOR4}0. Màng hình chính                          ${COLOR3}|${RESET}"
echo -e "${COLOR5}+---------------------------------------------+${RESET}"

    read -p "Nhập vào lựa chọn: " main_choice_divi
    case $main_choice_divi in
        0) main_menu;break ;;
        1) install_and_activate_theme "$divi";;
        2)install_and_activate_plugin "$divibuilder";;
        3)install_and_activate_plugin "$extra=";;
        4)install_and_activate_plugin "$bloom";;
        5)install_and_activate_plugin "$monarch";;
        6)install_themes ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
    done
}

install_themes(){
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;34m| \033[0mChọn cài đặt Theme muốn thực hiện:          \033[1;34m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;32m| \033[0m1. \033[1;33mCài Đặt Theme Astra              \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m2. \033[1;36mCài Đặt Divi                     \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m0. \033[1;91mThoát                             \033[1;32m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
    read -p "Nhập vào lựa chọn: " choice_theme
    case $choice_theme in
        0) exit ;;
        1) install_theme_astra ;;
        2) instal_theme_Divi ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}


#main_menu
main_menu() {
    # Các phần hiển thị thông tin máy chủ và hệ điều hành ở đây
dislay_play
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;34m| \033[0mChọn cài đặt Theme hoặc Plugin              \033[1;34m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"
echo -e "\033[1;32m| \033[0m1. \033[1;33mCài Đặt Theme                   \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m2. \033[1;36mCài Đặt plugin                  \033[1;32m|\033[0m"
echo -e "\033[1;32m| \033[0m0. \033[1;91mThoát                           \033[1;32m|\033[0m"
echo -e "\033[1;34m+---------------------------------------------+\033[0m"

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
