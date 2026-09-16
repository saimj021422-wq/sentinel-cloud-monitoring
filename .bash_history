docker-compose up -d
docker-compose ps
docker-compose down
docker-compose up -d
nano setup_server.sh
./setup_server.sh
chmod +x setup_server.sh
./setup_server.sh
sudo systemctl stop httpd
sudo systemctl disable httpd
sudo dnf install nginx -y
sudo nano /etc/nginx/nginx.conf
cat << 'EOF' | sudo tee /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen       80;
        server_name  _;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF

sudo nginx -t
sudo systemctl restart nginx
sudo dnf install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
nano docker-compose.yml
[200~docker-compose down
docker-compose up -d~
docker-compose down
docker-compose up -d
sudo systemctl restart docker
docker-compose up -d
cat docker-compose.yml
curl -I http://127.0.0.1:8080
curl -I http://13.222.134.43:8080
sudo dnf install -y certbot python3-certbot-nginx
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo certbot --nginx -d YOURDOMAIN.duckdns.org
sudo certbot --nginx -d YOURACTUALSUBDOMAIN.duckdns.org
sudo certbot --nginx -d sai-cloud-lab.duckdns.org
cat << 'EOF' | sudo tee /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen       80;
        server_name  sai-cloud-lab.duckdns.org;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx
sudo certbot install --cert-name sai-cloud-lab.duckdns.org
cd ~/my-custom-app
cat << 'EOF' > docker-compose.yml
version: '3.8'

services:
  web-app:
    build: .
    ports:
      - "127.0.0.1:8080:80"
    restart: always

  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    ports:
      - "127.0.0.1:9000:9000"

  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    hostname: ec2-cloud-server
    ports:
      - "127.0.0.1:19999:19999"
    restart: always
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    volumes:
      - netdatabit:/etc/netdata
      - netdatahostlib:/var/lib/netdata
      - netdatahostcache:/var/cache/netdata
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro

volumes:
  portainer_data:
  netdatabit:
  netdatahostlib:
  netdatahostcache:
EOF

docker compose up -d
docker ps
cat << 'EOF' | sudo tee /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen       80;
        server_name  sai-cloud-lab.duckdns.org;
        return 301 https://$host$request_uri;
    }

    server {
        listen       443 ssl;
        server_name  sai-cloud-lab.duckdns.org;

        ssl_certificate /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/privkey.pem;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /portainer/ {
            proxy_pass http://127.0.0.1:9000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Connection "";
            proxy_http_version 1.1;
        }
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx
docker ps
docker compose up -d
docker ps
cd ~/my-custom-app
docker compose up -d
docker ps
docker run -d -p 127.0.0.1:9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
docker ps
docker logs portainer 2>&1 | grep -i "token"
cat << 'EOF' | sudo tee /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    server {
        listen       80;
        server_name  sai-cloud-lab.duckdns.org;
        return 301 https://$host$request_uri;
    }

    server {
        listen       443 ssl;
        server_name  sai-cloud-lab.duckdns.org;

        ssl_certificate /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/privkey.pem;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /portainer/ {
            proxy_pass http://127.0.0.1:9000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx
docker stop portainer
docker rm portainer
docker run -d -p 127.0.0.1:9000:9000   --name portainer   --restart=always   -v /var/run/docker.sock:/var/run/docker.sock   -v portainer_data:/data   portainer/portainer-ce:latest
nano setup_server.sh
chmod +x setup_server.sh
./setup_server.sh
echo "$(date '+%Y-%m-%d %H:%M:%S,000') fail2ban.actions [1234]: NOTICE [sshd] Ban 203.0.113.199" | sudo tee -a /var/log/fail2ban.log
nohup sudo python3 ~/discord_alert.py > ~/sentinel.log 2>&1 &
sudo nano /etc/systemd/system/sentinel.service
sudo systemctl daemon-reload
sudo systemctl enable sentinel.service
sudo systemctl start sentinel.service
sudo systemctl status sentinel.service
nano ~/discord_alert.py
cat << 'EOF' > ~/discord_alert.py
import time
import requests
import re
import os

WEBHOOK_URL = "https://discord.com/api/webhooks/1533339547667009546/K5HecKdTV9LTqDNB3b8q3rfou3ATihLNkeNcTu51FwdaYdL5Yn3MFezesBgUoRbzEqIv"
LOG_FILE = "/var/log/fail2ban.log"

def get_geoip_data(ip):
    # Check for private or test IPs
    if ip.startswith(("10.", "172.16.", "192.168.", "127.", "203.0.113.")):
        return {"country": "Simulated/Private", "city": "Lab Environment", "flag": "🏴‍☠️"}
    
    try:
        response = requests.get(f"http://ip-api.com/json/{ip}", timeout=3)
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "success":
                country = data.get("country", "Unknown")
                city = data.get("city", "Unknown")
                country_code = data.get("countryCode", "")
                
                # Convert country code to flag emoji
                flag = "".join(chr(127397 + ord(c)) for c in country_code.upper()) if len(country_code) == 2 else "🌐"
                return {"country": country, "city": city, "flag": flag}
    except Exception as e:
        print(f"GeoIP Lookup error: {e}")
    
    return {"country": "Unknown", "city": "Unknown", "flag": "🌐"}

def send_discord_alert(ip, jail):
    geo = get_geoip_data(ip)
    
    payload = {
        "embeds": [
            {
                "title": "🚨 SECURITY ALERT: Intrusion Blocked",
                "color": 15158332,
                "fields": [
                    {"name": "Attacker IP", "value": f"`{ip}`", "inline": True},
                    {"name": "Target Service", "value": f"`{jail}`", "inline": True},
                    {"name": "Location", "value": f"{geo['flag']} {geo['city']}, {geo['country']}", "inline": False},
                    {"name": "Action Taken", "value": "IP Banned via Fail2ban", "inline": False},
                    {"name": "Server Host", "value": "`sai-cloud-lab.duckdns.org`", "inline": False}
                ],
                "footer": {"text": "EC2 Cloud Security Sentinel"}
            }
        ]
    }
    try:
        requests.post(WEBHOOK_URL, json=payload, timeout=5)
    except Exception as e:
        print(f"Failed to send alert: {e}")

def watch_logs():
    if not os.path.exists(LOG_FILE):
        print(f"Log file {LOG_FILE} not found. Ensure fail2ban is running.")
        return

    with open(LOG_FILE, "r") as file:
        file.seek(0, 2)
        print("🛡️ EC2 Sentinel Monitoring Live Logs with GeoIP...")
        
        while True:
            line = file.readline()
            if not line:
                time.sleep(1)
                continue
            
            if "Ban" in line:
                match = re.search(r"\[(\w+)\] Ban (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", line)
                if match:
                    jail = match.group(1)
                    ip = match.group(2)
                    print(f"[!] Ban detected: {ip} in {jail}")
                    send_discord_alert(ip, jail)

if __name__ == "__main__":
    watch_logs()
EOF

sudo systemctl restart sentinel.service
echo "$(date '+%Y-%m-%d %H:%M:%S,000') fail2ban.actions [1234]: NOTICE [sshd] Ban 185.220.101.5" | sudo tee -a /var/log/fail2ban.log
mkdir -p ~/monitoring && cd ~/monitoring
cat << 'EOF' > ~/monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "127.0.0.1:9090:9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    ports:
      - "127.0.0.1:9100:9100"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "127.0.0.1:3000:3000"
EOF

cat << 'EOF' > ~/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
EOF

sudo docker compose up -d
sudo docker ps
sudo nano /etc/nginx/conf.d/sai-cloud-lab.conf
ls -la /etc/nginx/conf.d/
sudo nano /etc/nginx/conf.d/<YOUR_CONFIG_FILE_NAME>.conf
sudo nano /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
sudo nano /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
cat << 'EOF' > ~/monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "127.0.0.1:9090:9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    ports:
      - "127.0.0.1:9100:9100"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    environment:
      - GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/
      - GF_SERVER_SERVE_FROM_SUB_PATH=true
    ports:
      - "127.0.0.1:3000:3000"
EOF

cat << 'EOF' > ~/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
EOF

cd ~/monitoring && sudo docker compose up -d
sudo docker ps
cat << 'EOF' > ~/monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "127.0.0.1:9090:9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    ports:
      - "127.0.0.1:9100:9100"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    environment:
      - GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/
      - GF_SERVER_SERVE_FROM_SUB_PATH=true
    ports:
      - "127.0.0.1:3000:3000"
EOF

cat << 'EOF' > ~/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
EOF

cd ~/monitoring && sudo docker compose up -d
sudo docker ps
cat << 'EOF' > ~/monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "127.0.0.1:9090:9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    ports:
      - "127.0.0.1:9100:9100"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    environment:
      - GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/
      - GF_SERVER_SERVE_FROM_SUB_PATH=true
    ports:
      - "127.0.0.1:3000:3000"
EOF

cat << 'EOF' > ~/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
EOF

cd ~/monitoring && sudo docker compose up -d
[200~sudo docker ps~
sudo docker ps
cat << 'EOF' > ~/monitoring/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "127.0.0.1:9090:9090"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    ports:
      - "127.0.0.1:9100:9100"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    environment:
      - GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/
      - GF_SERVER_SERVE_FROM_SUB_PATH=true
    ports:
      - "127.0.0.1:3000:3000"
EOF

cat << 'EOF' > ~/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
EOF

cd ~/monitoring && sudo docker compose up -d
sudo docker ps
nano ~/monitoring/docker-compose.yml
nano ~/monitoring/prometheus.yml
cd ~/monitoring && sudo docker compose up -d
sudo docker ps
history
[200~cat ~/.bash_history~
cat ~/.bash_history
cat ~/.bash_history > ~/cloud-lab-backup/master_command_history.txt
less ~/cloud-lab-backup/master_command_history.txt
q
[200~mkdir -p ~/cloud-lab-backup
cat ~/.bash_history > ~/cloud-lab-backup/master_command_history.txt
cat ~/cloud-lab-backup/master_command_history.txt~
mkdir -p ~/cloud-lab-backup
cat ~/.bash_history > ~/cloud-lab-backup/master_command_history.txt
cat ~/cloud-lab-backup/master_command_history.txt
mkdir -p ~/cloud-lab-backup
cat ~/.bash_history > ~/cloud-lab-backup/master_command_history.txt
cat ~/cloud-lab-backup/master_command_history.txt
nano ~/discord_alert.py
cat << 'EOF' > ~/discord_alert.py
import time
import requests
import re
import os

# Set your Discord Webhook URL below
WEBHOOK_URL = "YOUR_DISCORD_WEBHOOK_URL_HERE"
LOG_FILE = "/var/log/fail2ban.log"

def send_discord_alert(ip, jail):
    payload = {
        "embeds": [
            {
                "title": "🚨 SECURITY ALERT: Intrusion Blocked",
                "color": 15158332,
                "fields": [
                    {"name": "Attacker IP", "value": f"`{ip}`", "inline": True},
                    {"name": "Target Service", "value": f"`{jail}`", "inline": True},
                    {"name": "Action Taken", "value": "IP Banned via Fail2ban", "inline": False},
                    {"name": "Server Host", "value": "`sai-cloud-lab.duckdns.org`", "inline": False}
                ],
                "footer": {"text": "EC2 Cloud Security Sentinel"}
            }
        ]
    }
    try:
        requests.post(WEBHOOK_URL, json=payload, timeout=5)
    except Exception as e:
        print(f"Failed to send alert: {e}")

def watch_logs():
    if not os.path.exists(LOG_FILE):
        print(f"Log file {LOG_FILE} not found. Ensure fail2ban is running.")
        return

    with open(LOG_FILE, "r") as file:
        file.seek(0, 2)
        print("🛡️ EC2 Sentinel Monitoring Live Logs...")
        
        while True:
            line = file.readline()
            if not line:
                time.sleep(1)
                continue
            
            if "Ban" in line:
                match = re.search(r"\[(\w+)\] Ban (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", line)
                if match:
                    jail = match.group(1)
                    ip = match.group(2)
                    print(f"[!] Ban detected: {ip} in {jail}")
                    send_discord_alert(ip, jail)

if __name__ == "__main__":
    watch_logs()
EOF

nano ~/discord_alert.py
sudo python3 ~/discord_alert.py
sudo docker ps -a
cd ~/monitoring
sudo docker compose up -d
sudo docker ps
ls -la ~/monitoring
sudo docker compose up -d
sudo docker ps
sudo docker run -d --name prometheus --restart unless-stopped -p 127.0.0.1:9090:9090 prom/prometheus:latest
sudo docker run -d --name node-exporter --restart unless-stopped prom/node-exporter:latest
sudo docker run -d --name grafana --restart unless-stopped -e GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/ -e GF_SERVER_SERVE_FROM_SUB_PATH=true -p 127.0.0.1:3000:3000 grafana/grafana:latest
sudo docker ps
sudo nano /etc/nginx/nginx.conf
sudo bash -c 'cat << "EOF" > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name sai-cloud-lab.duckdns.org;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name sai-cloud-lab.duckdns.org;

        ssl_certificate /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/privkey.pem;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /portainer/ {
            proxy_pass http://127.0.0.1:9000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /grafana/ {
            proxy_pass http://127.0.0.1:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF'
sudo nginx -t && sudo systemctl reload nginx
sudo docker rm -f grafana
sudo docker run -d   --name grafana   --restart unless-stopped   -e "GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/"   -e "GF_SERVER_SERVE_FROM_SUB_PATH=true"   -p 127.0.0.1:3000:3000   grafana/grafana:latest
sudo bash -c 'cat << "EOF" > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name sai-cloud-lab.duckdns.org;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name sai-cloud-lab.duckdns.org;

        ssl_certificate /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/privkey.pem;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /portainer/ {
            proxy_pass http://127.0.0.1:9000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /grafana/ {
            proxy_pass http://127.0.0.1:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF'
sudo nginx -t && sudo systemctl reload nginx
sudo docker rm -f grafana
sudo docker run -d   --name grafana   --restart unless-stopped   -e "GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/"   -e "GF_SERVER_SERVE_FROM_SUB_PATH=true"   -p 127.0.0.1:3000:3000   grafana/grafana:latest
sudo bash -c 'cat << "EOF" > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name sai-cloud-lab.duckdns.org;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name sai-cloud-lab.duckdns.org;

        ssl_certificate /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sai-cloud-lab.duckdns.org/privkey.pem;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }

        location /app/ {
            proxy_pass http://127.0.0.1:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /portainer/ {
            proxy_pass http://127.0.0.1:9000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /grafana/ {
            proxy_pass http://127.0.0.1:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF'
sudo nginx -t && sudo systemctl reload nginx
sudo docker network create monitoring
sudo docker network connect monitoring prometheus
sudo docker network connect monitoring grafana
sudo docker run -d   --name node-exporter   --restart unless-stopped   --net="host"   --pid="host"   -v "/:/host:ro,rslave"   quay.io/prometheus/node-exporter:latest   --path.rootfs=/host
sudo docker rm -f node-exporter
sudo docker run -d   --name node-exporter   --restart unless-stopped   --net="host"   --pid="host"   -v "/:/host:ro,rslave"   quay.io/prometheus/node-exporter:latest   --path.rootfs=/host
sudo mkdir -p /etc/prometheus
sudo bash -c 'cat << "EOF" > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["172.17.0.1:9100"]
EOF'
sudo docker rm -f prometheus
sudo docker run -d   --name prometheus   --restart unless-stopped   -p 127.0.0.1:9090:9090   -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml   prom/prometheus:latest
sudo docker network connect monitoring prometheus
sudo nano /etc/nginx/sites-available/sai-cloud-lab
sudo nano /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
sudo systemctl status nginx
curl checkip.amazonaws.com
sudo docker ps
curl -kI https://localhost/grafana/
ssh -i "D:\Downloads\my-cloud-key.pem" ec2-user@13.222.134.43
sudo docker stop grafana 2>/dev/null; sudo docker rm grafana 2>/dev/null
sudo docker run -d   --name=grafana   --restart=always   -p 127.0.0.1:3000:3000   -e "GF_SERVER_DOMAIN=sai-cloud-lab.duckdns.org"   -e "GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/"   -e "GF_SERVER_SERVE_FROM_SUB_PATH=true"   grafana/grafana:latest
sudo systemctl start nginx
https://gemini.google.com/u/2/app/de10355ed6fb26e7?pageId=none#:~:text=Bash-,sudo%20systemctl%20status%20nginx,-Step%202%3A%20Recreate
sudo systemctl status nginx
sudo docker exec -it grafana grafana-cli admin reset-admin-password admin
sudo docker exec -it grafana grafana cli admin reset-admin-password admin
sudo docker stop grafana && sudo docker rm grafana
sudo docker run -d   --name=grafana   --restart=always   -p 127.0.0.1:3000:3000   -e "GF_SECURITY_ADMIN_PASSWORD=admin"   -e "GF_SERVER_DOMAIN=sai-cloud-lab.duckdns.org"   -e "GF_SERVER_ROOT_URL=https://sai-cloud-lab.duckdns.org/grafana/"   -e "GF_SERVER_SERVE_FROM_SUB_PATH=true"   grafana/grafana:latest
sudo docker ps
sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' prometheus
sudo amazon-linux-extras install testing -y 2>/dev/null; sudo yum install stress -y
stress --cpu 2 --timeout 150s
stress --cpu 2 --timeout 120s
stress --cpu 2 --timeout 240s
docker ps --all
mkdir -p ~/loki-stack && cd ~/loki-stack
nano loki-config.yaml
nano promtail-config.yaml
nano docker-compose.yaml
docker compose up -d
sudo docker compose up -d
docker ps
docker compose up -d
sudo docker compose up -d
sudo docker-compose up -d
sudo docker ps
sudo docker stop grafana && sudo docker rm grafana
sudo docker run -d -p 3000:3000 --name=grafana --restart=unless-stopped grafana/grafana:latest
sudo docker psssdssdsdsdssudo doc
sudo fail2ban-client unban --all
sudo docker ps
sudo systemctl status httpd
sudo systemctl status nginx
docker ps
sudo ss -tulpn | grep -E ':80|:443'
docker exec -it my-custom-app-web-1 sh -c "ps aux"
import time
import requests
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
DISCORD_WEBHOOK_URL = "YOUR_DISCORD_WEBHOOK_URL_HERE"
LOG_FILE_PATH = "/var/log/auth.log"  # Update to your target log path (e.g., Fail2ban or auth logs)
class LogHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path == LOG_FILE_PATH:;             with open(LOG_FILE_PATH, "r") as f:
                lines = f.readlines()
                if lines:;                     latest_line = lines[-1].strip()
                    # Trigger alert on keywords like Failed or Ban
                    if any(keyword in latest_line for keyword in ["Failed", "Ban", "Invalid"]):
                        payload = {"content": f"🚨 **Sentinel Alert:**\n`{latest_line}`"}
                        try:
                            requests.post(DISCORD_WEBHOOK_URL, json=payload)
                        except Exception as e:
                            print(f"Webhook error: {e}")
if __name__ == "__main__":;     event_handler = LogHandler()
    observer = Observer()
    observer.schedule(event_handler, path="/var/log/", recursive=False)
    observer.start()     print(f"[*] Sentinel daemon watching {LOG_FILE_PATH}...")
    try:
        while True:;             time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()     observer.join()
