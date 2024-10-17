#!/bin/bash

# Màu sắc cho output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kiểm tra file domain.txt có tồn tại không
if [[ ! -f "domain.txt" ]]; then
  echo -e "${RED}File domain.txt không tồn tại.${NC}"
  exit 1
fi

# Đọc danh sách domain từ file domain.txt
while IFS= read -r DOMAIN; do
  # Kiểm tra xem domain có hợp lệ không
  if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "${RED}Domain không hợp lệ: $DOMAIN${NC}"
    continue
  fi

  # Kiểm tra xem thư mục /etc/letsencrypt/live có tồn tại không
  if [[ ! -d /etc/letsencrypt/live ]]; then
    echo -e "${RED}Vui lòng chạy script nâng cấp - https://community.cyberpanel.net/docs?topic=81${NC}"
    exit 1
  fi

  # Xóa key của domain, không bao gồm mail hoặc bất kỳ subdomain nào khác của domain đó
  if [[ ! -d /etc/letsencrypt/live/$DOMAIN ]]; then
    rm -f  /etc/letsencrypt/live/$DOMAIN/privkey.pem && rm -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem
  fi

  # Cấp chứng chỉ SSL với Let's Encrypt
  echo -e "Đang cấp chứng chỉ SSL cho domain: ${GREEN}$DOMAIN${NC}"
  /root/.acme.sh/acme.sh --issue -d $DOMAIN -d www.$DOMAIN --cert-file /etc/letsencrypt/live/$DOMAIN/cert.pem --key-file /etc/letsencrypt/live/$DOMAIN/privkey.pem --fullchain-file /etc/letsencrypt/live/$DOMAIN/fullchain.pem -w /usr/local/lsws/Example/html --force --debug

  if [[ $? -eq 0 ]]; then
    echo -e "Cấp chứng chỉ SSL cho domain ${GREEN}$DOMAIN${NC} thành công."
  else
    echo -e "${RED}Cấp chứng chỉ SSL cho domain $DOMAIN thất bại.${NC}"
  fi
done < domain.txt
