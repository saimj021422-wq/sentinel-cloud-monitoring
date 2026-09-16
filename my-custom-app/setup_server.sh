#!/bin/bash

# 1. Update & Install Packages
sudo dnf update -y
sudo dnf install httpd -y

# 2. Start & Enable Apache Service
sudo systemctl start httpd
sudo systemctl enable httpd

# 3. Create a Dynamic Status Page with HTML/CSS
cat << 'EOF' | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Cloud Server Dashboard</title>
    <style>
        body { font-family: monospace; background-color: #0f172a; color: #38bdf8; padding: 40px; }
        .card { background: #1e293b; border-radius: 8px; padding: 20px; border: 1px solid #334155; }
        h1 { color: #f8fafc; margin-top: 0; }
        .stat { margin: 10px 0; font-size: 1.1em; color: #cbd5e1; }
        .highlight { color: #4ade80; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>⚡ Server Status Dashboard</h1>
        <p class="stat">Status: <span class="highlight">ONLINE</span></p>
        <p class="stat">Host: <span class="highlight">AWS EC2 (Amazon Linux 2023)</span></p>
        <p class="stat">Operator: <span class="highlight">Sai</span></p>
        <hr style="border-color: #334155;">
        <h3>System Metrics</h3>
EOF

# Append live system stats to the HTML page
echo "<p class=\"stat\">Uptime: $(uptime -p)</p>" | sudo tee -a /var/www/html/index.html
echo "<p class=\"stat\">Memory Usage: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')</p>" | sudo tee -a /var/www/html/index.html
echo "<p class=\"stat\">Active HTTP Connections: $(ss -ant | grep :80 | wc -l)</p>" | sudo tee -a /var/www/html/index.html

cat << 'EOF' | sudo tee -a /var/www/html/index.html
    </div>
</body>
</html>
EOF
