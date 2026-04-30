@echo off
chcp 65001 >nul
title Loverseny GitHub Push
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -NoProfile -File "push_to_github.ps1"
pause
