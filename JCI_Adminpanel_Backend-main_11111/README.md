# JCI Erode Metro — Backend API

Node.js API for mobile app and admin panel.

- **API:** `https://api.jcierodemetro.com`
- **Admin:** `https://adminpanel.jcierodemetro.com`
- **Site:** `https://jcierodemetro.com`
- **Port:** `3029` (behind nginx/apache reverse proxy)
- **DB:** `api_jcierodemetro` / user `jcierodemetro`

## Deploy

### 1. Database (once)

Import on MySQL:

```
sql database/jci_production_live_setup.sql
```

### 2. Start API

Use **one** env file only: `.env` (included in this repo)

```bash
npm install
npm start
```

Or with PM2: `pm2 start app.js --name jci-metro-api`

See `REPORT.md` for the full deploy checklist.

## Default admin (after SQL import)

- Email: `admin@jci.local`
- Password: `Admin@12345`
"# JCI_Metro_Backend" 
