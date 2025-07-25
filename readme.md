# Cloud Monitoring and Auto-Scaling for Web Application

This project demonstrates how to monitor a web application and automatically scale infrastructure using AWS services. It includes infrastructure provisioning with **Terraform**, configuration management via **Ansible**, and monitoring/scaling through **CloudWatch** and **Auto Scaling Groups**.

---

## Tech Stack

- **AWS EC2** – Virtual machines for hosting the application
- **AWS CloudWatch** – Monitoring and alarm service
- **Auto Scaling Group** – Automatically adjusts capacity
- **Terraform** – Infrastructure as Code
- **Ansible** – Configuration management
- **Apache Benchmark (ab)** – Load testing tool

---

## Project Structure

.
│ ├── main.tf # AWS infrastructure setup
│ ├── variables.tf # Input variable declarations
│ └── outputs.tf # Output definitions
├── ansible/
│ └── deploy.yml # Application deployment playbook
├── screenshots/ # Monitoring and scaling screenshots
├── report.pdf # Monitoring and scaling report
└── README.md # This file


## Deployment Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/cloud-monitoring-autoscaling.git

```

### 2.Set Up Infrastructure with Terraform

```bash 
terraform init
terraform plan
terraform apply
```

### 4. Create inventory.ini file

```bash
[web]
<your ec2 public ip> ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3.8
```

### 3. Configure and install the Server with Ansible
```bash
sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install ansible
ansible-playbook ansible/deploy.yml -i ansible/inventory.ini
```

### 4. Stimulate load testing

This will trigger scaling for your ec2 instances

```bash
ab -n 10000 -c 100 http://<EC2_PUBLIC_IP>/
```
