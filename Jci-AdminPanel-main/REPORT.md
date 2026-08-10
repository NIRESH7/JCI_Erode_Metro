# Admin Panel — Deploy Report (JCI Erode Metro)

## Project
`Jci-AdminPanel-main` — React admin web app

## Live URLs
| Item | Value |
|------|--------|
| Admin URL | `https://adminpanel.jcierodemetro.com` |
| API used | `https://api.jcierodemetro.com` |
| Main site | `https://jcierodemetro.com` |

## Env
- File: `.env`
- Key: `REACT_APP_URL_ADMIN=https://api.jcierodemetro.com`
- Template: `.env.example` (same value — no DB secrets here)

## Build & deploy
```bash
npm install
npm run build
# upload / serve the build/ folder on adminpanel.jcierodemetro.com
```

Local run:
```bash
npm start
```

## Login
- Email: `admin@jci.local`
- Password: `Admin@12345`

## Git — ignored
- `node_modules/`, `build/`, `*.zip`
- `.env` / `.env*.local`
- logs, `.eslintcache`, IDE/OS junk

## Notes
- Admin panel only talks to the API; DB credentials stay on the backend only.
- After changing `.env`, rebuild before deploying (`npm run build`).
