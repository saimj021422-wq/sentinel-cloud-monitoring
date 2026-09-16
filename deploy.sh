#!/bin/bash
sudo dnf update -y
cat << 'HTML' | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <style>
        body { background-color: #0f172a; color: #f8fafc; font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background-color: #1e293b; padding: 2.5rem; border-radius: 12px; border: 1px solid #334155; text-align: center; }
        h1 { color: #38bdf8; margin-bottom: 0.5rem; }
        p { color: #94a3b8; font-size: 1.1rem; }
        .status { display: inline-block; background-color: #059669; color: white; padding: 0.25rem 0.75rem; border-radius: 9999px; font-size: 0.875rem; margin-top: 1rem; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Cloud Server v2.0</h1>
        <p>Automated deployment pipeline complete.</p>
        <span class="status">● System Operational</span>
    </div>
</body>
</html>
HTML
sudo systemctl restart httpd
