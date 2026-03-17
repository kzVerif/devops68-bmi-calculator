output "app_public_url" {
  value = "http://${aws_instance.nodejs_server.public_ip}:30002/calculate?weight=70&height=1.75"
  description = "Copy URL นี้ไปเปิดใน Browser"
}