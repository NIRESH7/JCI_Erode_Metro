# Mobile App — Deploy Report (JCI Erode Metro)

## Project
`JCI---frontend-main` — Flutter app (Android / iOS)

## Live URLs
| Item | Value |
|------|--------|
| API | `https://api.jcierodemetro.com` |
| Website | `https://jcierodemetro.com` |
| Admin | `https://adminpanel.jcierodemetro.com` |
| Package (Android) | `com.nutz.jci.metro` |

## Env
| File | Purpose |
|------|--------|
| `.env` | Debug / local runs → live API |
| `.env.production` | Release / Play Store builds |
| `.env.example` / `.env.production.example` | Templates for Git |

Both point to:
```
URL=https://api.jcierodemetro.com
```

## Run
```bash
flutter pub get
flutter run
```

## Release build
```bash
flutter build appbundle   # Android
flutter build apk
flutter build ipa         # iOS (macOS)
```

## Git — ignored
- `.env`, `.env.*` (except `*.example`)
- `build/`, `.dart_tool/`
- signing: `*.jks`, `*.keystore`, `android/key.properties`
- IDE/OS junk, `Untitled`, logs

## Notes
- App never holds DB username/password — only the API URL.
- Signing keys and `key.properties` must stay off Git.
- Rebuild the app after changing `.env` / `.env.production`.
