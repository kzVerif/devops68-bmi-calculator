variable "aws_region" {
  description = "Region ของ AWS ที่ต้องการสร้าง Resource"
  type        = string
  default     = "ap-southeast-1"
}

# 2. ชื่อกุญแจ SSH (ที่เราสร้างไว้ในข้อ 7.2)
variable "key_name" {
  description = "ชื่อของ Key Pair ใน AWS ที่ใช้สำหรับ SSH เข้าเครื่อง EC2"
  type        = string
  default     = "my-terraform-key-kanghunz"
}

# 3. ขนาดของ Server (Instance Type)
variable "instance_type" {
  description = "ขนาดของ EC2 Instance"
  type        = string
  # แก้ไข Default เป็น t3.micro เพราะ ap-southeast-7 ไม่รองรับ t2
  default     = "t3.micro"
}

# 4. รหัสผ่านฐานข้อมูล (Sensitive Data)
variable "db_password" {
  description = "รหัสผ่านสำหรับ MySQL Database"
  type        = string
  default     = "my5ecre7pa55w0rd"
  sensitive   = true # Terraform จะปิดบังค่านี้ไม่ให้แสดงบนหน้าจอ
}

# 5. ชื่อฐานข้อมูล
variable "db_name" {
  description = "ชื่อ Schema ของฐานข้อมูล"
  type        = string
  default     = "tf_demo"
}

# 6. ชื่อตารางฐานข้อมูล
variable "table_name" {
  description = "ชื่อของตารางในฐานข้อมูล"
  type        = string
  default     = "users"
}

# 7. พอร์ตที่แอปพลิเคชันจะรัน
variable "app_port" {
  description = "พอร์ตที่แอปพลิเคชันจะรัน"
  type        = string
  default     = "3000"
}
