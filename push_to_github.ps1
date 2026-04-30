# =============================================================================
# Loverseny -> GitHub Pages push script
# 3 percenkent atmasolja a C:\loverseny\loverseny.md tartalmat ebbe a repo-ba
# es git push-olja. GH Pages automatikusan kiszolgalja.
# =============================================================================

# --- KONFIG -----------------------------------------------------------------
$SOURCE_FILE  = "C:\loverseny\loverseny.md"
$INTERVAL_SEC = 180   # 3 perc
# ----------------------------------------------------------------------------

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"

# A script futtatasi mappaja = a repo gyoker
$REPO_DIR = $PSScriptRoot
$TARGET_FILE = Join-Path $REPO_DIR "loverseny.md"
$META_FILE   = Join-Path $REPO_DIR "meta.json"

function Log($msg, $color = "White") {
    $ts = Get-Date -Format "HH:mm:ss"
    Write-Host "[$ts] " -NoNewline -ForegroundColor DarkGray
    Write-Host $msg -ForegroundColor $color
}

Set-Location $REPO_DIR

Log "=== Loverseny GitHub push script indul ===" "Cyan"
Log "Forras:    $SOURCE_FILE" "Gray"
Log "Repo:      $REPO_DIR" "Gray"
Log "Interval:  $INTERVAL_SEC mp" "Gray"
Log ""

$lastHash = ""

while ($true) {
    if (Test-Path $SOURCE_FILE) {
        try {
            $hash = (Get-FileHash -Path $SOURCE_FILE -Algorithm MD5).Hash

            if ($hash -eq $lastHash) {
                Log "valtozatlan, skip" "DarkGray"
            } else {
                $content = Get-Content -Path $SOURCE_FILE -Raw -Encoding UTF8
                if ($null -eq $content) { $content = "" }

                # 1) atmasoljuk a repo-ba
                [System.IO.File]::WriteAllText($TARGET_FILE, $content, [System.Text.UTF8Encoding]::new($false))

                # 2) meta.json frissites
                $meta = @{
                    updated_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                    bytes      = $content.Length
                } | ConvertTo-Json -Compress
                [System.IO.File]::WriteAllText($META_FILE, $meta, [System.Text.UTF8Encoding]::new($false))

                # 3) git commit + push
                $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                & git add loverseny.md meta.json 2>&1 | Out-Null
                & git commit -m "update: $stamp" 2>&1 | Out-Null
                $pushOut = & git push 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Log "OK pushed ($([math]::Round($content.Length / 1024, 1)) KB)" "Green"
                    $lastHash = $hash
                } else {
                    Log "git push HIBA: $pushOut" "Red"
                }
            }
        } catch {
            Log "HIBA: $($_.Exception.Message)" "Red"
        }
    } else {
        Log "Forras file nem letezik: $SOURCE_FILE" "Yellow"
    }

    Start-Sleep -Seconds $INTERVAL_SEC
}
