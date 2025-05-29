@echo off
setlocal EnableDelayedExpansion

:: Kiểm tra quyền Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ===== MENU BACKUP/RESTORE =====
echo 1. Backup Drivers
echo 2. Restore Drivers
echo 3. Thoat
echo ==============================
set /p choice="Nhap lua chon (1-3): "

if "%choice%"=="3" (
    echo Da thoat chuong trinh.
    pause
    exit
)

if not "%choice%"=="1" if not "%choice%"=="2" (
    echo Lua chon khong hop le! Vui long chon 1, 2 hoac 3.
    pause
    goto menu
)

set /p path="Nhap duong dan (vi du: D:\Backup): "

:: Kiểm tra đường dẫn tồn tại
if not exist "%path%\" (
    echo Duong dan %path% khong ton tai!
    pause
    goto menu
)

:: Thực hiện Backup hoặc Restore
if "%choice%"=="1" (
    echo Dang thuc hien backup drivers...
    dism /online /export-driver /destination:%path%
    if !errorlevel! equ 0 (
        echo Backup hoan tat!
    ) else (
        echo Loi khi backup drivers!
    )
) else (
    echo Dang thuc hien restore drivers...
    pnputil /add-driver "%path%\*.inf" /subdirs
    if !errorlevel! equ 0 (
        echo Restore hoan tat!
    ) else (
        echo Loi khi restore drivers! Kiem tra log tai C:\Windows\Logs\DISM\dism.log hoac duong dan driver.
    )
)

:: Hỏi tiếp tục
set /p continue="Tiep tuc? (y/n): "
if /i "%continue%"=="y" goto menu
echo Da thoat chuong trinh.
pause
exit