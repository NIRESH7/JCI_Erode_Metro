# JCI Erode Metro

Monorepo for JCI Erode GreenCity:

| Folder | Description |
|--------|-------------|
| `JCI---frontend-main` | Flutter mobile app (Android / iOS) |
| `JCI_Adminpanel_Backend-main_11111` | Node.js API / backend |
| `Jci-AdminPanel-main` | React admin panel (web) |

## Setup notes

- Copy `.env.example` / `.env.production.example` to local `.env` files — **do not commit secrets**.
- Backend: `npm install` then `npm start`
- Admin panel: `npm install` then `npm start`
- Mobile: `flutter pub get` then `flutter run`
