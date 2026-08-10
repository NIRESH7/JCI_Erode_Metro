# Backend — Deploy Report (JCI Erode Metro)

## Project
`JCI_Adminpanel_Backend-main_11111` — Node.js API

## Live URLs / hosting
| Item | Value |
|------|--------|
| API URL | `https://api.jcierodemetro.com` |
| Port | `3029` |
| DB name | `api_jcierodemetro` |
| DB user | `jcierodemetro` |
| DB host | `localhost` (on server) |
| Site | `https://jcierodemetro.com` |
| Admin | `https://adminpanel.jcierodemetro.com` |

## Env (one file only)
- Use **only** `.env` (committed to this private repo).
- `.env.example` is not used / not pushed.

Proxy `api.jcierodemetro.com` → `http://127.0.0.1:3029`.

## Git — what is ignored
- `node_modules/`
- `.env.example` (not used)
- `*.log` / `*.err.log` / `*.out.log`
- `*.zip`, OS/IDE junk, temp uploads

## Git — what to commit
- Source (`src/`, `config/`, `app.js`, `sql database/`)
- `package.json` / `package-lock.json`
- `.env` (live config)
- `.gitignore`
- `README.md` / this report

## Default admin (after SQL import)
- Email: `admin@jci.local`
- Password: `Admin@12345`
- Change after first login.

## Before push checklist
1. Confirm `.env` **is** staged (`git status`)
2. Confirm `.env.example` is **not** in the repo
3. Remove any old log files if already tracked: `git rm --cached *.log`
4. Push this folder’s repo when ready
