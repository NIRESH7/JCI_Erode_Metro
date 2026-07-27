# JCI Erode Greencity — Backend API

Node.js API for mobile app and admin panel.

- **API:** `https://api.jcierodegreencity.com`
- **Port:** `4026` (behind nginx/apache reverse proxy)

## Deploy

### 1. Database (once)

Import on MySQL:

```
sql database/jci_production_live_setup.sql
```

### 2. Start API

```bash
cp .env.production .env
npm install
npm run start:prod
```

Or with PM2: `pm2 start app.js --name jci-api`

## Default admin (after SQL import)

- Email: `admin@jci.local`
- Password: `Admin@12345`
