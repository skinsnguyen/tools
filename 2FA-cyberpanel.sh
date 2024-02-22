#!/bin/bash
# Nam-Nguyen
# 22-02-2024
while true; do
  echo "Chọn lựa enabled 1 2FA hoặc disable 0 2FA:"
  echo "1. Tắt 2FA twoFA "
  echo "2. Bật 2FA twoFA "
  echo "3. Kiểm tra Bật/Tắt 2FA"
  echo "4. Exit"

  read -p "Enter your choice (1-4): " choice

  PASSWORD=$(cat /etc/cyberpanel/mysqlPassword)
  DB_NAME=cyberpanel

  case $choice in
    1)
      mysql -uroot -p${PASSWORD} "${DB_NAME}" -e "UPDATE loginSystem_administrator SET twoFA = '0' WHERE id = 1;"
      ;;
    2)
      mysql -uroot -p${PASSWORD} "${DB_NAME}" -e "UPDATE loginSystem_administrator SET twoFA = '1' WHERE id = 1;"
      ;;
    3)
      mysql -uroot -p${PASSWORD} "${DB_NAME}" -e "SELECT twoFA FROM loginSystem_administrator WHERE id = 1;"
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1 and 4."
      ;;
  esac
done
