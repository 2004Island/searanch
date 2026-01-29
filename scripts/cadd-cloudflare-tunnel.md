 Static Website Hosting with Caddy + Cloudflare Tunnel

A complete guide to hosting a static website on Ubuntu 24.04 using Caddy as the web server and Cloudflare Tunnel for secure, zero-port-exposure delivery.

---

## Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         HOW IT WORKS                                │
│                                                                     │
│   User                Cloudflare              Your Server           │
│    │                     │                        │                 │
│    │  https://site.com   │                        │                 │
│    │ ─────────────────►  │                        │                 │
│    │                     │   Tunnel (encrypted)   │                 │
│    │                     │ ─────────────────────► │                 │
│    │                     │                        │  Caddy (:80)    │
│    │                     │                        │  serves files   │
│    │                     │  ◄───────────────────  │                 │
│    │  ◄─────────────────  │                        │                 │
│    │                     │                        │                 │
└─────────────────────────────────────────────────────────────────────┘
```

**Benefits of this setup:**
- No ports exposed to the internet (no firewall holes)
- No public IP required (works behind NAT/home router)
- Free automatic HTTPS via Cloudflare
- DDoS protection included
- Simple to maintain

---

## Prerequisites

- Ubuntu 24.04 server (can be a VM, Raspberry Pi, cloud instance, etc.)
- A domain name with DNS managed by Cloudflare
- Cloudflare account (free tier works)
- Your static website files (HTML, CSS, JS, images)

---

## High-Level Steps

1. **Install Caddy** — lightweight web server
2. **Deploy your site files** — copy HTML/CSS/JS to server
3. **Configure Caddy** — point it at your files
4. **Install cloudflared** — Cloudflare's tunnel client
5. **Authenticate with Cloudflare** — link to your account
6. **Create tunnel** — establish the secure connection
7. **Configure tunnel** — map your domain to localhost
8. **Add DNS routes** — point domain to tunnel
9. **Install as service** — run on boot automatically

---

## Detailed Instructions

### Step 1: Install Caddy

```bash
# Add Caddy's official repository
sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update
sudo apt install caddy
```

Verify installation:
```bash
caddy version
```

---

### Step 2: Create Site Directory and Deploy Files

```bash
# Create the web root directory
sudo mkdir -p /var/www/mysite
sudo chown $USER:$USER /var/www/mysite

# Copy your site files (example using scp from another machine)
# scp -r ./my-site-files/* user@server:/var/www/mysite/

# Or unzip if you have a zip file
cd /var/www/mysite
unzip /path/to/your-site.zip

# Verify files are in place
ls -la /var/www/mysite
```

You should see at least an `index.html` file.

---

### Step 3: Configure Caddy

Create the Caddy configuration:

```bash
sudo tee /etc/caddy/Caddyfile > /dev/null << 'EOF'
:80 {
    root * /var/www/mysite
    file_server
    encode gzip

    header {
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
    }

    @static {
        path *.jpg *.jpeg *.png *.webp *.css *.js *.html *.svg *.gif *.ico
    }
    header @static Cache-Control "public, max-age=31536000"
}
EOF
```

**Note:** Replace `/var/www/mysite` with your actual site directory.

Validate and start Caddy:

```bash
# Check config syntax
sudo caddy validate --config /etc/caddy/Caddyfile

# Format the config file (optional, cleans up whitespace)
sudo caddy fmt --overwrite /etc/caddy/Caddyfile

# Enable and start Caddy
sudo systemctl enable caddy
sudo systemctl restart caddy
sudo systemctl status caddy
```

Test locally:
```bash
curl -I http://localhost
```

You should see `HTTP/1.1 200 OK`.

---

### Step 4: Install cloudflared

```bash
# Add Cloudflare's package repository
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

sudo apt update
sudo apt install cloudflared
```

Verify installation:
```bash
cloudflared version
```

---

### Step 5: Authenticate with Cloudflare

```bash
cloudflared tunnel login
```

This will output a URL like:
```
Please open the following URL and log in with your Cloudflare account:
https://dash.cloudflare.com/argotunnel?callback=...
```

1. Open that URL in a browser
2. Log into your Cloudflare account
3. Select the domain you want to use (e.g., `yourdomain.com`)
4. Click "Authorize"

A certificate is saved to `~/.cloudflared/cert.pem`.

---

### Step 6: Create the Tunnel

```bash
cloudflared tunnel create mysite
```

**Replace `mysite`** with a name for your tunnel (e.g., your site name).

Output will look like:
```
Tunnel credentials written to /home/youruser/.cloudflared/79f32f7e-90ab-4e48-8e0b-347fb97ad599.json
Created tunnel mysite with id 79f32f7e-90ab-4e48-8e0b-347fb97ad599
```

**Save the tunnel ID** (the UUID) — you'll need it next.

Verify:
```bash
ls -la ~/.cloudflared/
```

You should see:
- `cert.pem` — your account certificate
- `<tunnel-id>.json` — tunnel credentials

---

### Step 7: Configure the Tunnel

Create the config file:

```bash
cat > ~/.cloudflared/config.yml << 'EOF'
tunnel: YOUR_TUNNEL_NAME_OR_ID
credentials-file: /home/YOUR_USERNAME/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: yourdomain.com
    service: http://localhost:80
  - hostname: www.yourdomain.com
    service: http://localhost:80
  - service: http_status:404
EOF
```

**Replace:**
- `YOUR_TUNNEL_NAME_OR_ID` — the tunnel name (e.g., `mysite`) or UUID
- `YOUR_USERNAME` — your Linux username (run `whoami` to check)
- `YOUR_TUNNEL_ID` — the UUID from step 6
- `yourdomain.com` — your actual domain

**Example with real values:**
```bash
cat > ~/.cloudflared/config.yml << 'EOF'
tunnel: mysite
credentials-file: /home/ask/.cloudflared/79f32f7e-90ab-4e48-8e0b-347fb97ad599.json

ingress:
  - hostname: example.com
    service: http://localhost:80
  - hostname: www.example.com
    service: http://localhost:80
  - service: http_status:404
EOF
```

---

### Step 8: Add DNS Routes

This creates the DNS records in Cloudflare automatically:

```bash
cloudflared tunnel route dns YOUR_TUNNEL_NAME yourdomain.com
cloudflared tunnel route dns YOUR_TUNNEL_NAME www.yourdomain.com
```

**Example:**
```bash
cloudflared tunnel route dns mysite example.com
cloudflared tunnel route dns mysite www.example.com
```

You can verify in the Cloudflare dashboard under DNS — you'll see CNAME records pointing to `<tunnel-id>.cfargotunnel.com`.

---

### Step 9: Test the Tunnel Manually

Before installing as a service, test it:

```bash
cloudflared tunnel run YOUR_TUNNEL_NAME
```

Leave it running and open **https://yourdomain.com** in a browser.

If it works, press `Ctrl+C` to stop and proceed to install as a service.

---

### Step 10: Install as a System Service

Copy config to system location:

```bash
sudo mkdir -p /etc/cloudflared

sudo cp ~/.cloudflared/config.yml /etc/cloudflared/
sudo cp ~/.cloudflared/YOUR_TUNNEL_ID.json /etc/cloudflared/
```

Update the credentials path in the system config:

```bash
sudo sed -i "s|/home/$USER/.cloudflared/|/etc/cloudflared/|g" /etc/cloudflared/config.yml
```

Verify:
```bash
cat /etc/cloudflared/config.yml
```

The `credentials-file` should now point to `/etc/cloudflared/...`.

Install and start the service:

```bash
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared
```

Check logs if needed:
```bash
sudo journalctl -u cloudflared -n 50
```

---

## Verification Checklist

```bash
# Check Caddy is running
sudo systemctl status caddy

# Check cloudflared is running
sudo systemctl status cloudflared

# Check Caddy is serving locally
curl -I http://localhost

# Check tunnel is connected
sudo journalctl -u cloudflared -n 10 | grep -i "registered"
```

Then visit **https://yourdomain.com** — you should see your site with a valid SSL certificate!

---

## Updating Your Site

When you have new files to deploy:

```bash
# Stop services (optional but safe)
sudo systemctl stop caddy

# Check no files are in use
sudo lsof +D /var/www/mysite

# Backup old version (optional)
mkdir -p /var/www/mysite-backup
cp -r /var/www/mysite/* /var/www/mysite-backup/

# Deploy new files
cd /var/www/mysite
rm -rf *
unzip /path/to/new-site.zip
# If files are in a subdirectory:
mv new-site-folder/* .
rm -rf new-site-folder

# Restart Caddy
sudo systemctl start caddy
```

No need to restart cloudflared — it just proxies to Caddy.

---

## Troubleshooting

### Caddy won't start
```bash
# Check config syntax
sudo caddy validate --config /etc/caddy/Caddyfile

# Check logs
sudo journalctl -xeu caddy.service --no-pager -n 50

# Check if port 80 is in use
sudo lsof -i :80
```

### cloudflared won't start
```bash
# Check config exists
cat /etc/cloudflared/config.yml

# Check credentials file exists
ls -la /etc/cloudflared/*.json

# Check logs
sudo journalctl -u cloudflared -n 50
```

### Site not loading
```bash
# Test Caddy locally
curl http://localhost

# Test tunnel manually
cloudflared tunnel run YOUR_TUNNEL_NAME

# Check DNS in Cloudflare dashboard
# Should see CNAME records for your domain
```

### SSL errors
- Ensure you're using `https://` not `http://`
- Check Cloudflare SSL/TLS settings → should be "Full" or "Full (strict)"
- Wait a few minutes for DNS propagation

---

## Quick Reference Commands

```bash
# Caddy
sudo systemctl start caddy
sudo systemctl stop caddy
sudo systemctl restart caddy
sudo systemctl status caddy

# cloudflared
sudo systemctl start cloudflared
sudo systemctl stop cloudflared
sudo systemctl restart cloudflared
sudo systemctl status cloudflared

# View logs
sudo journalctl -u caddy -f        # Follow Caddy logs
sudo journalctl -u cloudflared -f  # Follow tunnel logs

# List tunnels
cloudflared tunnel list

# Delete a tunnel (if needed)
cloudflared tunnel delete TUNNEL_NAME
```

---

## Security Notes

- Caddy only listens on localhost:80 — not exposed to internet
- All traffic goes through Cloudflare's encrypted tunnel
- No firewall ports need to be opened
- Cloudflare provides DDoS protection automatically
- Free SSL certificates managed by Cloudflare

---

## File Structure Reference

```
/var/www/mysite/              # Your website files
├── index.html
├── styles.css
├── script.js
└── images/
    └── hero.jpg

/etc/caddy/
└── Caddyfile                 # Caddy configuration

/etc/cloudflared/
├── config.yml                # Tunnel configuration
└── <tunnel-id>.json          # Tunnel credentials

~/.cloudflared/               # User-level cloudflared files
├── cert.pem                  # Account certificate
├── config.yml                # User config (copied to /etc/)
└── <tunnel-id>.json          # Credentials (copied to /etc/)
```

---

*Guide created January 2026. Tested on Ubuntu 24.04 LTS.*
