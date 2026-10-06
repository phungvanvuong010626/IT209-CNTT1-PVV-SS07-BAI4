#!/usr/bin/env python3
"""
Mock Spring Boot Backend chạy trên port 8082
Dùng để test Reverse Proxy Nginx khi chưa khởi chạy Spring Boot thật.
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

PORT = 8082

class MockBackendHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Trả về JSON trạng thái cho endpoint /health hoặc /api/health
        if self.path in ['/health', '/health/', '/api/health', '/api/health/']:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()
            response = {
                "status": "UP",
                "service": "Spring Boot Backend Service",
                "port": PORT,
                "client_ip": self.headers.get('X-Real-IP', self.client_address[0]),
                "forwarded_for": self.headers.get('X-Forwarded-For', 'None'),
                "host_header": self.headers.get('Host', 'Unknown'),
                "path_received": self.path,
                "message": "Kết nối Reverse Proxy Nginx thành công!"
            }
            self.wfile.write(json.dumps(response, ensure_ascii=False, indent=2).encode('utf-8'))
        else:
            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()
            response = {
                "status": "OK",
                "path": self.path,
                "message": f"Spring Boot Backend received request at {self.path}"
            }
            self.wfile.write(json.dumps(response, ensure_ascii=False, indent=2).encode('utf-8'))

    def log_message(self, format, *args):
        print(f"[Spring Boot Mock :8082] {args[0]} - {args[1]}")

if __name__ == '__main__':
    server = HTTPServer(('127.0.0.1', PORT), MockBackendHandler)
    print(f"Mock Spring Boot Backend đang lắng nghe tại http://127.0.0.1:{PORT}")
    print("Nhấn Ctrl+C để dừng server.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nĐã dừng Mock Server.")
