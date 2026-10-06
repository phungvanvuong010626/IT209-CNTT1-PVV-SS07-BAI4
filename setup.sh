#!/bin/bash
# ==============================================================================
# Script tự động triển khai Cấu hình Nginx Reverse Proxy cho Bài 4 (SS07)
# Hệ điều hành hỗ trợ: Ubuntu / Debian
# ==============================================================================

set -e

echo "=== [BƯỚC 1] Cập nhật và đảm bảo Nginx đã được cài đặt ==="
if ! command -v nginx &> /dev/null; then
    echo "Nginx chưa được cài đặt. Đang tiến hành cài đặt..."
    sudo apt update
    sudo apt install -y nginx curl
else
    echo "Nginx đã được cài đặt."
fi

echo ""
echo "=== [BƯỚC 2] Tạo cấu trúc thư mục và sao chép trang tĩnh ==="
sudo mkdir -p /var/www/html
sudo cp index.html /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
echo "-> Đã sao chép index.html vào /var/www/html/index.html"

echo ""
echo "=== [BƯỚC 3] Triển khai tệp cấu hình Nginx Server Block ==="
sudo cp spring-proxy.conf /etc/nginx/sites-available/spring-proxy.conf
echo "-> Đã sao chép cấu hình vào /etc/nginx/sites-available/spring-proxy.conf"

echo ""
echo "=== [BƯỚC 4] Kích hoạt cấu hình (Tạo liên kết mềm symlink) ==="
# Tắt default site nếu có để tránh xung đột port 80
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "Phát hiện site mặc định 'default', đang gỡ bỏ khỏi sites-enabled để tránh xung đột..."
    sudo rm -f /etc/nginx/sites-enabled/default
fi

# Tạo symlink
sudo ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/spring-proxy.conf
echo "-> Đã tạo symlink /etc/nginx/sites-enabled/spring-proxy.conf"

echo ""
echo "=== [BƯỚC 5] Kiểm tra cú pháp cấu hình Nginx ==="
sudo nginx -t

echo ""
echo "=== [BƯỚC 6] Khởi động lại / Reload dịch vụ Nginx ==="
sudo systemctl reload nginx || sudo systemctl restart nginx
sudo systemctl enable nginx
echo "-> Nginx đã được reload thành công!"

echo ""
echo "=== [BƯỚC 7] Kiểm tra kết nối HTTP cục bộ ==="
echo "[1] Kiểm tra Headers trang tĩnh /:"
curl -I http://localhost/

echo ""
echo "[2] Kiểm tra nội dung trang tĩnh /:"
curl -s http://localhost/ | head -n 25

echo ""
echo "=== Hoàn thành triển khai! ==="
