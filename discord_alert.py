import time
import requests
import re
import os

WEBHOOK_URL = os.environ.get("DISCORD_WEBHOOK_URL")
LOG_FILE = "/var/log/fail2ban.log"

if not WEBHOOK_URL:
    raise RuntimeError("DISCORD_WEBHOOK_URL environment variable is not set.")

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
                    {"name": "Target
