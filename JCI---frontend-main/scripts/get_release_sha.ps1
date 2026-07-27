# Print release keystore SHA-1 and SHA-256 for Firebase + assetlinks.json
$ErrorActionPreference = "Stop"
$AndroidDir = Join-Path (Split-Path -Parent $PSScriptRoot) "android"
$PropsFile = Join-Path $AndroidDir "key.properties"

if (-not (Test-Path $PropsFile)) {
    Write-Error "android/key.properties not found."
}

$props = @{}
Get-Content $PropsFile | ForEach-Object {
    if ($_ -match '^([^#=]+)=(.*)$') { $props[$matches[1].Trim()] = $matches[2].Trim() }
}

$storePath = if ($props['storeFile'] -match '^[/\\]|^[A-Za-z]:') {
    $props['storeFile']
} else {
    Join-Path $AndroidDir $props['storeFile']
}
$storePath = (Resolve-Path $storePath).Path

$keytool = "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
if (-not (Test-Path $keytool)) {
    Write-Error "keytool not found. Install Android Studio or set JAVA_HOME."
}

Write-Host "Release keystore: $storePath" -ForegroundColor Cyan
Write-Host ""
& $keytool -list -v -keystore $storePath -alias $props['keyAlias'] -storepass $props['storePassword'] |
    Select-String -Pattern "SHA1:|SHA256:"
Write-Host ""
Write-Host "Add both fingerprints in Firebase Console -> Project settings -> Android app (com.nutz.jci)" -ForegroundColor Yellow
