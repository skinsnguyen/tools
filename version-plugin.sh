#Theme Astra
#export Astra_main="4.8.1"
#export astra_child=""
#Plugin Astra
#export astra_addon_plugin="4.8.1"
#export astra_premium_sites="4.4.2"
#export astra_portfolio="1.11.9"
#export bb_ultimate-addon="1.35.23"
#export convertpro="1.7.7"
#export convertpro_addon="1.5.10"
#export ultimate_elementor="1.36.36"
#export wp_schema_pro="2.7.19"
####################################################
###########Divi Theme"##########################
#export divi_main=""
#export divi-builder=""
########################################
# Bộ Plugin WPDeveloper
#export essential_addons_elementor="6.0.3"
#export wp_scheduled_posts_pro="5.0.12"
#export notificationx_pro="2.9.6"
#export betterdocs_pro="3.4.5"
#export embedpress_pro="3.6.5"
#export betterlinks_pro="2.1.1"
#export essential_blocks_pro="1.9.1"
#export better_payment_pro="1.0.5"
####################################
#export elementskit="3.6.9"
#export ithemes-security_pro="8.5.0"
#export otgs_installer="3.1.3"


################-Theme-Astra-##################

astra="https://tainguyenwp.azdigi.com/WordPress-Astra/Theme/astra.4.8.1.zip"
astrachild="https://tainguyenwp.azdigi.com/WordPress-Astra/Theme/astra-child.zip"

################-Plugin-Astra-##################
astraaddon_plugin="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/astra-addon-plugin-4.8.1.zip"
astrapremium_sites="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/astra-premium-sites-4.4.2.zip"
astraportfolio="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/astra-portfolio-1.11.9.zip"
bbultimate_addon="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/bb-ultimate-addon-1.35.23.zip"
convertpro="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/convertpro-1.7.7.zip"
convertpro_addon="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/convertpro-addon-1.5.10.zip"
ultimate_elementor="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/ultimate-elementor-1.36.36.zip"
wpschema_pro="https://tainguyenwp.azdigi.com/WordPress-Astra/Plugin/wp-schema-pro-2.7.19.zip"

############################-Theme-DiVi-############################

divi="https://tainguyenwp.azdigi.com/divi/Divi.zip"
divi_builder="https://tainguyenwp.azdigi.com/divi/divi-builder.zip"

############################-Theme-Brick-############################
bricks="https://tainguyenwp.azdigi.com/wordpress-themes-other/Bricks.1.11.zip"

##############-Plugin-WPDeveloper-##############

essentialaddons_elementor="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/essential-addons-elementor.6.0.3.zip"
wpscheduledposts_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/wp-scheduled-posts-pro.5.0.12.zip"
notificationx_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/notificationx-pro.2.9.6.zip"
betterdocs_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/betterdocs-pro.3.4.5.zip"
embedpress_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/embedpress-pro.3.6.5.zip"
betterlinks_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/betterlinks-pro.2.1.1.zip"
essentialblocks_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/essential-blocks-pro.1.9.1.zip"
betterpayment_pro="https://tainguyenwp.azdigi.com/wordpress-wpdeveloper/better-payment-pro.1.0.5.zip"

############################-Plugin-Khac


elementskit="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/elementskit-3.6.9.zip"
ithemessecurity_pro="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/ithemes-security-pro-8.5.0.zip"
otgsinstaller_plugin="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/otgs-installer-plugin.3.1.3.zip"
seedprodcomingsoon_pro="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/seedprod-coming-soon-pro-5-6.18.5.zip"
seobyrankmath_pro="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/seo-by-rank-math-pro.zip"
sitepressmultilingual_cms="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/sitepress-multilingual-cms.4.6.13.zip"
swift_ai="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/swift-ai.zip"
wpstaging_pro="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/wp-staging-pro.zip"
speedycache_pro="https://tainguyenwp.azdigi.com/WordPress-Plugins-Other/speedycache-pro.zip"


############################-Dashboard-WPMU-Dev--############################
wpmudev_dashboard="https://tainguyenwp.azdigi.com/wordpress-plugin-wpmudev/881630_wpmu-dev-dashboard-4.11.26.zip"
smush_pro="https://tainguyenwp.azdigi.com/wordpress-plugin-wpmudev/881630_smush-pro-3.16.7.zip"
defender_pro="https://tainguyenwp.azdigi.com/wordpress-plugin-wpmudev/881630_defender-pro-4.9.zip"



###################################################################################################################

echo "################-Theme-Astra-##################"

ver_astra=$(echo "$astra" | grep -oP '\d+(\.\d+)+')
ver_astrachild=$(echo "$astrachild" | grep -oP '\d+(\.\d+)+')
echo "Phiên bản Astra là:  $ver_astra"
echo "Phiên bản Astra-child là:  $ver_astrachild"

################-Plugin-Astra-##################
ver_astraaddon_plugin=$(echo "$astraaddon_plugin" | grep -oP '\d+(\.\d+)+')
ver_astrapremium_sites=$(echo "$astrapremium_sites"  | grep -oP '\d+(\.\d+)+')
ver_astraportfolio=$(echo "$astraportfolio" | grep -oP '\d+(\.\d+)+')
ver_bbultimate_addon=$(echo "$bbultimate_addon" | grep -oP '\d+(\.\d+)+')
ver_convertpro=$(echo "$convertpro" | grep -oP '\d+(\.\d+)+')
ver_convertpro_addon=$(echo "$convertpro_addon" | grep -oP '\d+(\.\d+)+')
ver_ultimate_elementor=$(echo "$ultimate_elementor" | grep -oP '\d+(\.\d+)+')
ver_wpschema_pro=$(echo "$wpschema_pro" | grep -oP '\d+(\.\d+)+')

echo "Phiên bản Astra-addon_plugin là: $ver_astraaddon_plugin"
echo "Phiên bản Astra-Premiumsites là:$ver_astrapremium_sites"
echo "Phiên bản Astra-Portfolio là: $ver_astraportfolio"
echo "Phiên bản Convert-Pro là: $ver_convertpro"
echo "Phiên bản Convert-Pro-Addon là: $ver_convertpro_addon"
echo "Phiên bản Ultimate-Elementor là: $ver_ultimate_elementor"
echo "Phiên bản Wp-Schema_pro là $ver_wpschema_pro"
echo "############################-Theme-DiVi-############################"

echo "$divi" | grep -oP '\d+(\.\d+)+'
echo "$divi_builder" | grep -oP '\d+(\.\d+)+'

ver_divi=$(echo "$divi" | grep -oP '\d+(\.\d+)+')
ver_divi_builder=$(echo "$divi_builder" | grep -oP '\d+(\.\d+)+')

echo "Phiên bản theme Divi: $ver_divi"
echo "Phiên bản Plugin Divi-Builder: $ver_divi_builder"

echo "================-Theme-Brick-================"

ver_bricks=$(echo "$bricks" | grep -oP '\d+(\.\d+)+')

echo "Phiên bản Theme Bricks: $ver_bricks"

##############-Plugin-WPDeveloper-##############

ver_essentialaddons_elementor=$(echo "$essentialaddons_elementor" | grep -oP '\d+(\.\d+)+')
ver_wpscheduledposts_pro=$(echo "$wpscheduledposts_pro" | grep -oP '\d+(\.\d+)+')
ver_notificationx_pro=$(echo "$notificationx_pro" | grep -oP '\d+(\.\d+)+')
ver_betterdocs_pro=$(echo "$betterdocs_pro" | grep -oP '\d+(\.\d+)+')
ver_embedpress_pro=$(echo "$embedpress_pro" | grep -oP '\d+(\.\d+)+')
ver_betterlinks_pro=$(echo "$betterlinks_pro" | grep -oP '\d+(\.\d+)+')
ver_essentialblocks_pro=$(echo "$essentialblocks_pro" | grep -oP '\d+(\.\d+)+')
ver_betterpayment_pro=$(echo "$betterpayment_pro" | grep -oP '\d+(\.\d+)+')

echo "Phiên bản Essentialaddons_Elementor: $ver_essentialaddons_elementor"
echo "Phiên bản Wp-Scheduledposts_pro $ver_wpscheduledposts_pro"
echo "Phiên bản Notificationx_Pro: $ver_notificationx_pro"
echo "Phiên bản Betterdocs_Pro: $ver_betterdocs_pro"
echo "Phiên bản Embedpress_Pro: $ver_embedpress_pro"
echo "Phiên bản Essentialblocks_Pro: $ver_essentialblocks_pro"
echo "Phiên bản Betterpayment_Pro: $ver_betterpayment_pro"
echo "############################-Plugin-Khac-############################"


ver_elementskit=$(echo "$elementskit" | grep -oP '\d+(\.\d+)+')
ver_ithemessecurity_pro=$(echo "$ithemessecurity_pro" | grep -oP '\d+(\.\d+)+')
ver_otgsinstaller_plugin=$(echo "$otgsinstaller_plugin" | grep -oP '\d+(\.\d+)+')
ver_seedprodcomingsoon_pro=$(echo "$seedprodcomingsoon_pro" | grep -oP '\d+(\.\d+)+')
ver_seobyrankmath_pro=$(echo "$seobyrankmath_pro" | grep -oP '\d+(\.\d+)+')
ver_sitepressmultilingual_cms=$(echo "$sitepressmultilingual_cms" | grep -oP '\d+(\.\d+)+')
ver_swift_ai=$(echo "$swift_ai" | grep -oP '\d+(\.\d+)+')
ver_wpstaging_pro=$(echo "$wpstaging_pro" | grep -oP '\d+(\.\d+)+')
ver_speedycache_pro=$(echo "$speedycache_pro" | grep -oP '\d+(\.\d+)+')

echo "Phiên Bản elementskit-Pro: $ver_elementskit"
echo "Phiên bản Ithemes-security_pro: $ver_ithemessecurity_pro"
echo "Phiên bản Otgs-Installer_Plugin: $ver_otgsinstaller_plugin"
echo "Phiên bản Seed-Prodcoming-Soon-pro: $ver_seedprodcomingsoon_pro"
echo "Phiên bản Seo-ByRankMath-pro: $ver_seobyrankmath_pro"
echo "Phiên bản Sitepress-Multilingual-cms: $ver_sitepressmultilingual_cms"
echo "Phiên bản Swift-ai: $ver_swift_ai"
echo "Phiên bản Wpstaging-Pro: $ver_wpstaging_pro"


echo "############################-Dashboard-WPMU-Dev--############################"
ver_wpmudev_dashboard=$(echo "$wpmudev_dashboard" | grep -oP '\d+(\.\d+)+')
ver_smush_pro=$(echo "$smush_pro" | grep -oP '\d+(\.\d+)+')
ver_defender_pro=$(echo "$defender_pro" | grep -oP '\d+(\.\d+)+')

echo "wpmudev_dashboard: $ver_wpmudev_dashboard"
echo "smush_pro: $ver_smush_pro"
echo "defender_pro: $ver_defender_pro"






















