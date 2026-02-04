# PescoEncoder 🔐📦
**The .env file must be added to .gitignore and should never be committed to version control. In production environments, sensitive configuration values should be managed using AWS Secrets Manager or AWS Systems Manager Parameter Store, which are standard practices for production-grade applications. Any .env file present in the repository is included for reference purposes only and must not contain real secrets**  

**PescoEncoder is a Dockerized Flask-based web application that converts:**

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
|
v
[Nginx :80]
|
v
[Flask App :5000] (Docker)
|
v
[PostgreSQL :5432] (Docker)
|
v
[S3 Backups via Cron + IAM Role]

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



⚠️ Problems Faced & Final Solutions (Summary)
1️⃣ Hardcoded Secrets in Code & Docker Configs

Problem

Database credentials and session secrets were hardcoded.

.env risked being committed to GitHub.

Final Solution

Moved all secrets to .env

Added .env to .gitignore

Used AWS IAM Role (instead of AWS keys) for S3 backups

Planned migration to AWS Secrets Manager / SSM Parameter Store for production

2️⃣ Database Cost Concern (RDS Too Expensive)

Problem

AWS RDS was costly for early-stage / low-traffic usage.

Final Solution

Used PostgreSQL Docker container on EC2

Ensured:

Private Docker network

No exposed DB port

Automated backups to S3

3️⃣ Unable to SSH into EC2 (CGNAT Issue)

Problem

ISP CGNAT blocked inbound SSH access.

Final Solution

Used AWS SSM Session Manager

Removed port 22 from Security Group

Gained:

Zero SSH exposure

Audited, encrypted access

No additional cost

4️⃣ Application Broke After Adding Nginx

Problem

App worked without Nginx

After adding Nginx:

502 Bad Gateway

Unexpected token '<' errors

Caused by incorrect proxy paths

Final Solution

Updated nginx.conf to match actual Flask routes

Ensured:

Correct proxy_pass

No hardcoded /api assumptions

Verified app + DB worked end-to-end

5️⃣ Docker Compose Failing (ContainerConfig Error)

Problem

docker-compose up failed with:

No such image: sha256

'ContainerConfig' KeyError

Caused by:

Old Docker Compose v1

Removed image references

Final Solution

Switched to Docker Compose v2 plugin

Cleaned old containers/images

Re-pulled correct image tag

Used:

docker compose up -d

6️⃣ Application Not Accessible After Security Hardening

Problem

Removing port 5000 from EC2 Security Group broke access.

Flask runs on port 5000 internally.

Final Solution

Exposed only port 80

Used Nginx as reverse proxy

Flask port 5000 remained:

Internal only

Docker network scoped

7️⃣ Database Backup Script Failed

Problem

Backup script couldn’t find postgres container.

Cron execution behaved differently from manual runs.

Final Solution

Used:

Absolute paths

Correct container name

Root crontab

Logged output to /var/log/db-backup.log

Confirmed backups uploaded to S3

8️⃣ AWS CLI Installation Issues

Problem

awscli package not found via apt.

Final Solution

Installed AWS CLI v2 using official installer

Used IAM Role instead of access keys

Verified S3 access using:

aws s3 ls

9️⃣ S3 Security & IAM Confusion

Problem

Errors in bucket policy principal ARN

Uncertainty about role vs user

Final Solution

Created IAM Role

Attached role to EC2

Used correct ARN format

Locked down bucket with:

No public access

Least-privilege policy

🔟 Need for Automated, Verifiable Backups

Problem

Needed low-cost, reliable DB backups.

Final Solution

Implemented:

pg_dump → gzip → S3

Cron-based automation

IAM Role authentication

Verified:

Local backup creation

Successful S3 uploads

Restore-ready .sql.gz files

✅ Final Outcome

✔ Secure Dockerized Flask app
✔ Private PostgreSQL database
✔ No exposed SSH or DB ports
✔ Reverse-proxied via Nginx
✔ Automated S3 backups
✔ Production-aligned security practices
✔ Low-cost AWS setup suitable for early-stage apps
