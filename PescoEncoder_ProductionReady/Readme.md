# PescoEncoder 🔐📦
**The .env file must be added to .gitignore and should never be committed to version control. In production environments, sensitive configuration values should be managed using AWS Secrets Manager or AWS Systems Manager Parameter Store, which are standard practices for production-grade applications. Any .env file present in the repository is included for reference purposes only and must not contain real secrets**
PescoEncoder is a Dockerized Flask-based web application that converts:

- **TXT → ZIP (with encoded images)**
- **ZIP → TXT (decoded back)**

All conversions are logged into a **PostgreSQL database**, and the database is **automatically backed up to Amazon S3** using a secure cron-based backup mechanism.

This project is designed to be:
- Cost-effective 💰
- Secure 🔒
- Easy to deploy on AWS EC2 🖥️
- Production-ready with Docker & Nginx 🚀

---

## 🏗️ Architecture Overview

# PescoEncoder 🔐📦

PescoEncoder is a Dockerized Flask-based web application that converts:

- **TXT → ZIP (with encoded images)**
- **ZIP → TXT (decoded back)**

All conversions are logged into a **PostgreSQL database**, and the database is **automatically backed up to Amazon S3** using a secure cron-based backup mechanism.

This project is designed to be:
- Cost-effective 💰
- Secure 🔒
- Easy to deploy on AWS EC2 🖥️
- Production-ready with Docker & Nginx 🚀

---

## 🏗️ Architecture Overview
User
↓
[Nginx :80]
↓
[Flask App :5000] ← Docker
↓
[PostgreSQL :5432] ← Docker
↓
[S3 Backups via Cron + IAM Role]


---

## 🧰 Tech Stack

- **Backend:** Flask (Python 3.11)
- **Database:** PostgreSQL (Dockerized)
- **ORM:** SQLAlchemy
- **Reverse Proxy:** Nginx
- **Containerization:** Docker & Docker Compose
- **Cloud:** AWS EC2, S3, IAM
- **Automation:** Cron jobs
- **Security:** IAM Roles, environment variables, private DB

---

## 📁 Project Structure

├── app.py
├── extract_images.py
├── templates/
│ └── index.html
├── uploads/
├── nginx.conf
├── Dockerfile
├── docker-compose.yml
├── .env
└── README.md
