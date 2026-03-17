# BMI Calculator API

Calculate Body Mass Index from weight and height.

## Endpoint

### GET `/calculate`

**Parameters:**
- `weight` (required): Weight in kg (number)
- `height` (required): Height in meters (number)

**Example Request:**
```
http://localhost:3002/calculate?weight=70&height=1.75
```

**Example Response:**
```json
{
  "weight": 70,
  "height": 1.75,
  "bmi": 22.9,
  "category": "Normal"
}
```
# 🚀 วิธีการใช้งาน Terraform กับ AWS (ฉบับสมบูรณ์)

คู่มือนี้จะสอนการตั้งค่าตั้งแต่การลงโปรแกรม ไปจนถึงการสั่งรัน Resource บน AWS (Region: Singapore)

---

## 1. การติดตั้ง (Installation)
* **Terraform:** [ดาวน์โหลดที่นี่](https://www.terraform.io/downloads) (แตกไฟล์ .exe ไปไว้ใน Path ของระบบ)
* **AWS CLI:** [ดาวน์โหลดที่นี่](https://aws.amazon.com/cli/) (ติดตั้งเพื่อใช้ยืนยันตัวตน)

## 2. วิธีการขอ Access Key และ Secret Key (IAM)
คุณต้องมี "กุญแจ" เพื่อให้ Terraform เข้าไปสั่งงาน AWS ได้:
1. เข้าไปที่ **AWS Management Console** -> ค้นหาบริการ **IAM**
2. เมนูด้านซ้ายเลือก **Users** -> คลิกชื่อ User ของคุณ (ต้องมีสิทธิ์ Administrator หรือเทียบเท่า)
3. คลิก Tab **Security credentials**
4. เลื่อนลงมาที่หัวข้อ **Access keys** -> กดปุ่ม **Create access key**
5. เลือกหัวข้อ **Command Line Interface (CLI)** -> ติ๊กถูกยอมรับเงื่อนไข -> กด Next
6. **สำคัญมาก:** คุณจะเห็น `Access Key ID` และ `Secret Access Key` ให้ก๊อปปี้เก็บไว้ หรือโหลดไฟล์ `.csv` ไว้ (เพราะ Secret Key จะดูได้แค่ครั้งเดียว)

## 3. การตั้งค่า AWS CLI (Configuration)
เปิด Terminal (CMD / PowerShell / Bash) แล้วพิมพ์คำสั่ง:
```bash
aws configure
```
ระบบจะให้เรากรอกข้อมูล 4 อย่าง (วางค่าที่ได้จากข้อ 2 ลงไป):
AWS Access Key ID: (วาง Access Key ของคุณ)
AWS Secret Access Key: (วาง Secret Key ของคุณ)
Default region name: ap-southeast-1
Default output format: json

## 4. เข้าสู่ พาธ การทำงานของ Terraform ด้วยคำสั่ง
```bash
cd terraform
```

## 5. คำสั่งการรัน (Execution)
รันคำสั่งตามลำดับในโฟลเดอร์ที่มีไฟล์ main.tf:
```terraform
terraform init
terraform plan
terraform apply
```