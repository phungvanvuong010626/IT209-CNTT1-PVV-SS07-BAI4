# Bài 4: Cấu hình Reverse Proxy Nginx cho ứng dụng Spring Boot

Tài liệu hướng dẫn và mã nguồn hoàn chỉnh cho Bài 4 (Session 07).

## Danh mục tệp tin trong bài nộp:
- [spring-proxy.conf](file:///d:/IT209/SS07/BAI4/spring-proxy.conf): Tệp cấu hình Nginx Server Block (Reverse Proxy + Static files).
- [index.html](file:///d:/IT209/SS07/BAI4/index.html): Trang tĩnh HTML hiển thị thông tin sinh viên tại `/var/www/html/index.html`.
- [BAO_CAO.md](file:///d:/IT209/SS07/BAI4/BAO_CAO.md): Báo cáo thực hành chi tiết kèm ảnh chụp/kết quả lệnh terminal theo yêu cầu.
- [setup.sh](file:///d:/IT209/SS07/BAI4/setup.sh): Bash script hỗ trợ triển khai nhanh trên Ubuntu/Debian.
- [mock_backend.py](file:///d:/IT209/SS07/BAI4/mock_backend.py): Mock server backend Python trên cổng 8082 để test endpoint `/api/health`.

---

## Tóm tắt các bước thực hiện:

### 1. Triển khai tệp cấu hình Nginx:
```bash
sudo cp spring-proxy.conf /etc/nginx/sites-available/spring-proxy.conf
sudo ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/spring-proxy.conf
sudo rm -f /etc/nginx/sites-enabled/default
```

### 2. Triển khai trang web tĩnh:
```bash
sudo mkdir -p /var/www/html
sudo cp index.html /var/www/html/index.html
sudo chmod 644 /var/www/html/index.html
```

### 3. Kiểm tra cú pháp và kích hoạt:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Kiểm tra kết quả qua cURL:
```bash
curl -I http://localhost/
curl -I http://localhost/api/health
```

Xem toàn bộ nội dung báo cáo nộp bài chi tiết tại [BAO_CAO.md](file:///d:/IT209/SS07/BAI4/BAO_CAO.md).
