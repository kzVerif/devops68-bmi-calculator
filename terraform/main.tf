provider "aws" {
  region = var.aws_region
  # กำหนด Region ของ AWS ที่จะใช้งาน โดยดึงค่าจาก Variable
}

# -------------------------------------------------------
# สร้าง TLS Private Key สำหรับใช้เป็น SSH Key Pair
# -------------------------------------------------------
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
  # ใช้อัลกอริทึม RSA ขนาด 4096 bits เพื่อความปลอดภัยสูง
}

# นำ Public Key ที่สร้างขึ้นไปลงทะเบียนใน AWS เพื่อใช้เชื่อมต่อ EC2
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh

  lifecycle {
    ignore_changes = [public_key]
    # ป้องกันการแทนที่ Key Pair เดิม หาก Key นี้มีอยู่ใน AWS หรือ State แล้ว
  }
}

# บันทึก Private Key ลงไฟล์ .pem ในเครื่อง สำหรับใช้ SSH เข้า EC2
resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
  # ตั้งสิทธิ์ไฟล์เป็น 0400 (เจ้าของอ่านได้คนเดียว) เพื่อความปลอดภัย
}

# -------------------------------------------------------
# สร้าง Security Group สำหรับควบคุม Traffic เข้า-ออก
# -------------------------------------------------------
resource "aws_security_group" "app_sg" {
  name_prefix = "app_sg"
  description = "Security Group for App and DB"

  # อนุญาต SSH จากทุก IP (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # อนุญาต HTTP จากทุก IP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # อนุญาต Traffic สำหรับ Node.js Application (Port 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # อนุญาต Traffic ขาออกทุกชนิดไปยังทุก IP
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------------------------------
# สร้าง EC2 Instance สำหรับรัน Node.js Application
# -------------------------------------------------------
resource "aws_instance" "nodejs_server" {
  ami                    = "ami-060e277c0d4cce553" # Ubuntu AMI ID ที่ใช้งาน
  instance_type          = var.instance_type        # ขนาด Instance ดึงจาก Variable
  key_name               = var.key_name             # ชื่อ Key Pair ที่ใช้ SSH ดึงจาก Variable
  vpc_security_group_ids = [aws_security_group.app_sg.id] # ผูกกับ Security Group ที่สร้างไว้

  # Script ที่จะรันอัตโนมัติตอน EC2 เปิดครั้งแรก
  user_data = <<-EOF
              #!/bin/bash
              # บันทึก Log ทุกอย่างไว้ที่ /var/log/user-data.log เพื่อง่ายต่อการ Debug
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
             
              echo "Starting User Data Script"

              # ปิด Interactive Prompt ที่อาจค้างการติดตั้ง เช่น "kernel outdated" หรือ "restart services"
              export DEBIAN_FRONTEND=noninteractive

              # ขั้นตอนที่ 1: อัปเดต Package Index ของระบบ
              sudo -E apt-get update -y

              # ขั้นตอนที่ 2: ติดตั้ง curl
              sudo -E apt-get install -y curl

              # ขั้นตอนที่ 3: เพิ่ม NodeSource Repository สำหรับ Node.js 20.x LTS
              # Script นี้จัดการ GPG Key และ sources.list ให้อัตโนมัติ
              sudo curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

              # ขั้นตอนที่ 4: ติดตั้ง Node.js (รวม npm มาในตัว)
              sudo -E apt-get install -y nodejs

              # ขั้นตอนที่ 5: ตรวจสอบเวอร์ชันที่ติดตั้ง
              echo "Node version: $(node -v)"
              echo "NPM version: $(npm -v)"

              # ขั้นตอนที่ 6: ติดตั้ง Git สำหรับ Clone โปรเจกต์
              sudo apt-get install -y git

              # เปลี่ยน Directory ไปที่ Home ของ ubuntu แล้ว Clone โปรเจกต์จาก GitHub
              cd /home/ubuntu
              git clone https://github.com/kzVerif/devops68-bmi-calculator
              cd devops68-bmi-calculator

              # ติดตั้ง Dependencies ของโปรเจกต์ Node.js
              npm install
             
              # รัน Application แบบ Background Process
              # nohup ป้องกันไม่ให้ App ถูกปิดเมื่อ SSH Session สิ้นสุด
              nohup node index.js
             
              echo "User Data Script Finished"
              EOF
 
  # หาก user_data มีการเปลี่ยนแปลง Terraform จะทำการสร้าง EC2 ใหม่แทนการ Update
  user_data_replace_on_change = true
}