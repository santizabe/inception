# Inception

A system administration project focused on containerization using Docker and Docker Compose. This project involves setting up a complete web infrastructure with multiple services running in dedicated containers.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Services](#services)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Bonus Services](#bonus-services)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project creates a small infrastructure composed of different services following strict Docker best practices. Each service runs in its own container, built from custom Dockerfiles based on Alpine or Debian.

### Key Features

- Custom Docker images (no pre-built images from DockerHub)
- Secure NGINX reverse proxy with TLS 1.2/1.3
- WordPress with PHP-FPM
- MariaDB database
- Persistent data volumes
- Automatic container restart on failure
- Environment-based configuration

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         NGINX (Port 443 - TLS)          │
│         (Reverse Proxy/Gateway)          │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴────────┐
       │                │
┌──────▼──────┐  ┌─────▼──────┐
│  WordPress  │  │  MariaDB   │
│  (PHP-FPM)  │◄─┤ (Database) │
└─────────────┘  └────────────┘
       │                │
   ┌───▼────┐      ┌───▼────┐
   │WP Files│      │DB Data │
   │ Volume │      │ Volume │
   └────────┘      └────────┘

Bonus Services:
├─ Redis (Cache)
├─ FTP Server
├─ Adminer (DB Management)
├─ Static Website
└─ Prometheus (Monitoring)
```

## ✅ Prerequisites

- Virtual Machine (VM)
- Docker Engine
- Docker Compose
- Make
- Root or sudo access
- At least 2GB RAM
- 10GB free disk space

## 📁 Project Structure

```
.
├── Makefile
└── srcs/
    ├── .env
    ├── dotenv_example
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── conf/
        │       └── db.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   ├── nginx.conf
        │   │   └── bonus.conf
        │   └── tools/
        │       └── script.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        │       └── script.sh
        └── bonus/
            ├── docker-compose.yml
            ├── docker-compose.bonus.yml
            ├── adminer/
            │   └── Dockerfile
            ├── redis/
            │   ├── Dockerfile
            │   └── conf/
            │       └── redis.conf
            ├── ftp/
            │   ├── Dockerfile
            │   ├── conf/
            │   │   └── vsftpd.conf
            │   └── tools/
            │       └── script.sh
            ├── prometheus/
            │   ├── Dockerfile
            │   └── conf/
            │       └── prometheus.yml
            └── web/
                ├── Dockerfile
                ├── conf/
                │   └── nginx.conf
                └── tools/
                    ├── index.html
                    ├── script.js
                    ├── styles.css
                    └── public/
                        ├── alura.svg
                        └── challenge_01.png
```

## 🐳 Services

### Mandatory Services

#### NGINX
- **Purpose**: Reverse proxy and SSL/TLS termination
- **Base Image**: Alpine/Debian
- **Port**: 443 (HTTPS only)
- **Protocol**: TLSv1.2 or TLSv1.3
- **Configuration**: Custom nginx.conf with SSL certificates

#### WordPress
- **Purpose**: Content Management System
- **Base Image**: Alpine/Debian
- **Components**: PHP-FPM (no nginx)
- **Database**: MariaDB backend
- **Volume**: WordPress files mounted at `/var/www/html`

#### MariaDB
- **Purpose**: Relational database
- **Base Image**: Alpine/Debian
- **Users**: 
  - Root user
  - WordPress user
  - Admin user (username must NOT contain 'admin')
- **Volume**: Database data for persistence

### Bonus Services

#### Redis
- **Purpose**: WordPress cache management
- **Benefit**: Improved performance and reduced database queries

#### FTP Server
- **Purpose**: File transfer to WordPress volume
- **Access**: Direct connection to WordPress files

#### Adminer
- **Purpose**: Database management interface
- **Access**: Web-based GUI for MariaDB administration

#### Static Website
- **Purpose**: Simple showcase/resume site
- **Language**: Non-PHP (HTML/CSS/JavaScript)

#### Prometheus
- **Purpose**: Monitoring and metrics collection
- **Features**: 
  - Container metrics
  - Service health monitoring
  - Performance tracking
  - Alerting capabilities

## 🚀 Installation

### 1. Clone and Setup

```bash
git clone <repository-url>
cd inception
```

### 2. Configure Domain Name

Add your domain to `/etc/hosts`:

```bash
sudo echo "127.0.0.1 <your-login>.42.fr" >> /etc/hosts
```

### 3. Create Data Directories

```bash
sudo mkdir -p /home/<your-login>/data/wordpress
sudo mkdir -p /home/<your-login>/data/mariadb
```

### 4. Configure Environment Variables

Copy and edit the `.env` file in `srcs/`:

```bash
cd srcs
cp dotenv_example .env
vim .env
```

### 5. Build and Launch

```bash
make
```

## ⚙️ Configuration

### Environment Variables (.env)

Create your `.env` file from the provided example:

```bash
cp srcs/dotenv_example srcs/.env
```

Edit `srcs/.env` with your configuration:

```env
# Database Configuration
DB_NAME=wordpress_db
DB_USER=wp_user
DB_PASS=secure_db_password

# Domain Configuration
DOMAIN_NAME=<your-login>.42.fr

# WordPress Admin Configuration
ADMIN_NAME=wpadmin
ADMIN_PWD=secure_admin_password
ADMIN_EMAIL=admin@example.com

# WordPress User Configuration
USER_NAME=wpuser
USER_PWD=secure_user_password

# FTP Configuration
FTP_USER=ftpuser
FTP_PASS=secure_ftp_password
```

**Important Notes:**
- Replace `<your-login>` with your 42 login
- Use strong, unique passwords for all services
- Admin username must NOT contain 'admin', 'Admin', or 'administrator'
- Never commit the `.env` file to version control

### SSL Certificates

SSL certificates are automatically generated during the build process via the NGINX setup script (`srcs/requirements/nginx/tools/script.sh`).

If you need to manually regenerate certificates:

```bash
cd srcs/requirements/nginx/tools
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx.key \
  -out nginx.crt \
  -subj "/C=ES/ST=Andalusia/L=Arcos/O=42/CN=<your-login>.42.fr"
```

## 💻 Usage

### Basic Commands

```bash
# Build and start all services
make

# Stop all services
make down

# Rebuild all images
make re

# View logs
make logs

# Clean everything (containers, images, volumes)
make fclean
```

### Access Services

- **WordPress**: https://<your-login>.42.fr
- **Adminer**: https://<your-login>.42.fr:8080
- **Static Website**: https://<your-login>.42.fr:8081
- **Prometheus**: https://<your-login>.42.fr:9090
- **FTP**: ftp://<your-login>.42.fr:21

Replace `<your-login>` with your actual 42 login.

### Docker Commands

```bash
# Check container status
docker ps

# View specific service logs
docker logs inception-nginx
docker logs inception-wordpress
docker logs inception-mariadb

# Execute commands in containers
docker exec -it inception-wordpress bash
docker exec -it inception-mariadb mysql -u root -p

# Inspect volumes
docker volume ls
docker volume inspect inception_wordpress
docker volume inspect inception_mariadb
```

## 🎁 Bonus Services

### Redis Cache

Improves WordPress performance by caching database queries and objects.

**Benefits:**
- Faster page load times
- Reduced database load
- Better scalability

### FTP Server

Provides easy file transfer access to WordPress files.

**Usage:**
```bash
ftp <your-login>.42.fr
# Enter credentials from .env
```

### Adminer

Lightweight database management alternative to phpMyAdmin.

**Features:**
- User-friendly interface
- Execute SQL queries
- Import/Export databases
- Manage users and privileges

### Prometheus

Monitoring and alerting system for tracking infrastructure health.

**Metrics Available:**
- Container resource usage (CPU, memory, disk)
- Service uptime and availability
- Request rates and response times
- Custom application metrics

**Configuration:**
Edit `prometheus.yml` to add custom scrape targets and alerting rules.

## 🔒 Security Considerations

1. **No Passwords in Code**: All sensitive data stored in `.env` file
2. **Git Ignore**: `.env` file must be excluded from version control
3. **TLS Encryption**: All traffic encrypted via NGINX SSL/TLS
4. **Container Isolation**: Each service runs in isolated container
5. **Non-root Users**: Services run as unprivileged users where possible
6. **Admin Username**: Must not contain 'admin' or 'administrator'
7. **Port Exposure**: Only NGINX exposed on 443, internal services isolated

### Important Notes

⚠️ **Never commit:**
- `.env` file (use `dotenv_example` as template only)
- SSL private keys
- Any files containing passwords or API keys

⚠️ **Production Considerations:**
- Use proper SSL certificates (Let's Encrypt)
- Implement proper backup strategy
- Set up monitoring and alerting
- Use strong, unique passwords
- Regular security updates

## 🐛 Troubleshooting

### Common Issues

**Containers won't start:**
```bash
# Check logs
docker-compose -f srcs/docker-compose.yml logs

# Verify volumes
ls -la /home/<your-login>/data/
```

**Permission denied errors:**
```bash
# Fix volume permissions
sudo chown -R $USER:$USER /home/<your-login>/data/
```

**Domain not resolving:**
```bash
# Check /etc/hosts
cat /etc/hosts | grep 42.fr

# Test connectivity
ping <your-login>.42.fr
```

**Database connection issues:**
```bash
# Check MariaDB is running
docker exec -it inception-mariadb mysql -u root -p

# Verify credentials in .env match WordPress configuration
```

**SSL certificate errors:**
```bash
# Regenerate certificates
cd srcs/requirements/nginx/tools/
./generate-ssl.sh
```

### Debug Mode

Enable verbose logging:

```bash
# WordPress debug mode
# Add to wp-config.php:
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);

# NGINX debug mode
# Add to nginx.conf:
error_log /var/log/nginx/error.log debug;
```

## 📚 Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Codex](https://codex.wordpress.org/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [Prometheus Documentation](https://prometheus.io/docs/)

## 📝 License

This project is part of the 42 School curriculum.

## 👤 Author

**Santiago Zapata Bedoya** - `szapata-`

---

**Note**: Replace `<your-login>` with your actual 42 login throughout the configuration files and commands.