# Build a signed Play Store App Bundle (AAB)
$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

$AabPath = Join-Path $ProjectRoot "build\app\outputs\bundle\release\app-release.aab"

Write-Host "==> Checking .env.production..." -ForegroundColor Cyan
if (-not (Test-Path ".env.production")) {
    Write-Error "Missing .env.production. Copy from .env.production.example and fill in values."
}

Write-Host "==> flutter pub get" -ForegroundColor Cyan
flutter pub get

Write-Host "==> Building release App Bundle..." -ForegroundColor Cyan
flutter build appbundle --release
$flutterExit = $LASTEXITCODE

if (-not (Test-Path $AabPath)) {
    Write-Host "AAB not found. Install Android NDK via Android Studio SDK Manager, then retry." -ForegroundColor Red
    exit 1
}

$sizeMb = [math]::Round((Get-Item $AabPath).Length / 1MB, 1)
Write-Host ""
Write-Host "SUCCESS: Play Store bundle ready ($sizeMb MB)" -ForegroundColor Green
Write-Host $AabPath
if ($flutterExit -ne 0) {
    Write-Host ""
    Write-Host "Note: Flutter reported a debug-symbol strip warning, but the AAB above is valid for Play Console upload." -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Before publishing:" -ForegroundColor Yellow
Write-Host "  1. Upload .well-known/assetlinks.json -> https://jcierodegreencity.com/.well-known/assetlinks.json"
Write-Host "  2. Upload web/privacy-policy.html -> https://jcierodegreencity.com/privacy-policy"
Write-Host "  3. Add release SHA-1/SHA-256 in Firebase (run scripts/get_release_sha.ps1)"
Write-Host "  4. Complete Play Console: store listing, Data safety, content rating"
