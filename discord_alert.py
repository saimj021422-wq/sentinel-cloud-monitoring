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
