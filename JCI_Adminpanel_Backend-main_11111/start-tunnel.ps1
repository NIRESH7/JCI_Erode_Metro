# Exposes local backend (port 3002) to the internet via Cloudflare Tunnel.
# Keep this window open while your friend uses the app.
# Copy the https://xxxx.trycloudflare.com URL into JCI---frontend-main/.env as URL=

Write-Host "Starting tunnel to http://localhost:3002 ..." -ForegroundColor Cyan
Write-Host "Make sure backend is running (npm start) in another terminal." -ForegroundColor Yellow
Write-Host ""

npx --yes cloudflared tunnel --url http://localhost:3002
