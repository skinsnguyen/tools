#!/bin/bash
# Nam-Nguyen
# 01-11-2025
@echo off
REM ========================================
REM    BATCH FILE TAO USER TU DONG
REM ========================================
REM Yeu cau: Chay voi quyen Administrator
REM Tao boi: User Manager Tool
REM ========================================

echo ========================================
echo    WINDOWS USER MANAGEMENT TOOL
echo ========================================
echo.

REM Che do tuong tac - nhap thong tin
:menu
cls
echo ========================================
echo    WINDOWS USER MANAGEMENT TOOL
echo ========================================
echo.
echo [1] Tao user moi
echo [2] Hien thi danh sach user
echo [3] Xoa user hien co
echo [4] Thoat
echo.
set /p choice="Chon tuy chon (1-4): "
echo.

if "%choice%"=="1" goto createuser
if "%choice%"=="2" goto listusers
if "%choice%"=="3" goto deleteuser
if "%choice%"=="4" goto end
echo Tuy chon khong hop le!
timeout /t 2 >nul
goto menu

:createuser
cls
echo ========================================
echo       NHAP THONG TIN USER MOI
echo ========================================
echo.
set /p username="Nhap ten user: "
echo.
echo LUU Y: Mat khau se hien thi khi nhap!
echo Hay dam bao khong co ai nhin man hinh.
echo.
set /p password="Nhap mat khau: "
echo.
set /p confirmpass="Xac nhan lai mat khau: "
echo.

if not "%password%"=="%confirmpass%" (
    echo [ERROR] Mat khau khong khop! Vui long thu lai.
    timeout /t 3 >nul
    goto createuser
)

REM Tao user moi
echo [1/7] Dang tao user...
net user "%username%" "%password%" /add /passwordchg:no /expires:never
if %errorlevel% neq 0 (
    echo [ERROR] Khong the tao user!
    pause
    exit /b 1
)
echo [OK] User da duoc tao thanh cong!
echo.

REM Them user vao nhom Administrators
echo [2/7] Dang them vao nhom Administrators...
net localgroup administrators "%username%" /add
if %errorlevel% neq 0 (
    echo [WARNING] Khong the them vao nhom Administrators
) else (
    echo [OK] Da them vao nhom Administrators!
)
echo.

REM Them user vao nhom Print Operators
echo [3/7] Dang them vao nhom Print Operators...
net localgroup "Print Operators" "%username%" /add 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Nhom Print Operators khong ton tai (binh thuong tren workstation)
    echo [INFO] User da co quyen may in day du tu nhom Administrators
) else (
    echo [OK] Da them vao nhom Print Operators!
)
echo.

REM Them user vao nhom Network Configuration Operators
echo [4/7] Dang them vao nhom Network Configuration Operators...
net localgroup "Network Configuration Operators" "%username%" /add
if %errorlevel% neq 0 (
    echo [WARNING] Khong the them vao nhom Network Configuration Operators
) else (
    echo [OK] Da them vao nhom Network Configuration Operators!
)
echo.

REM Them user vao nhom Power Users (neu co)
echo [5/7] Dang them vao nhom Power Users...
net localgroup "Power Users" "%username%" /add 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Nhom Power Users khong ton tai (binh thuong tren Windows 10/11)
) else (
    echo [OK] Da them vao nhom Power Users!
)
echo.

REM Cau hinh mat khau khong het han
echo [6/7] Dang cau hinh mat khau...
wmic useraccount where "name='%username%'" set passwordexpires=false
echo [OK] Mat khau duoc cau hinh khong het han!
echo.

REM An user khoi man hinh dang nhap
echo [7/7] Dang an user khoi man hinh login...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "%username%" /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 (
    echo [WARNING] Khong the an user khoi man hinh login
) else (
    echo [OK] User da duoc an khoi man hinh login!
)
echo.

echo ========================================
echo HOAN TAT!
echo ========================================
echo User: %username%
echo.
echo Quyen va Nhom:
echo   - Administrators (Full Control)
echo   - Print Operators (neu co)
echo   - Network Configuration Operators
echo   - Power Users (neu co)
echo.
echo Tinh nang:
echo   - Full quyền quan tri he thong
echo   - Full quyền may in: Print + Manage Documents + Manage Printers
echo   - Quyen tao, xoa, chia se may in
echo   - Quyen quan ly print queue va print jobs
echo   - Full quyền file sharing (Read/Change/Full Control)
echo   - Quyen thay doi cau hinh network
echo   - An khoi man hinh login
echo ========================================
echo.
echo Nhan phim bat ky de quay lai menu...
pause >nul
goto menu

:listusers
cls
echo ====================================================================================================================================
echo                                          DANH SACH USER HIEN CO
echo ====================================================================================================================================
echo.

setlocal enabledelayedexpansion

REM Lay danh sach administrators
set "adminlist="
for /f "skip=4 tokens=*" %%a in ('net localgroup administrators 2^>nul') do (
    set "line=%%a"
    if not "!line!"=="" (
        if not "!line:~0,3!"=="The" (
            if not "!line:~0,3!"=="---" (
                set "adminlist=!adminlist! %%a "
            )
        )
    )
)

REM Tao header cho bang
echo ------------------------------------------------------------------------------------------------------------------------------------
echo STT   Ten User            SID                                              Het han          Admin   Nhom
echo ------------------------------------------------------------------------------------------------------------------------------------

REM Khoi tao bien dem
set index=0

REM Xu ly tung user - net user tra ve 3 users tren moi dong
for /f "skip=4 tokens=1-3" %%a in ('net user 2^>nul') do (
    REM Kiem tra dong cuoi cung
    if not "%%a"=="The" (
        call :processuser "%%a"
    )
    if not "%%b"=="" (
        if not "%%b"=="command" (
            call :processuser "%%b"
        )
    )
    if not "%%c"=="" (
        call :processuser "%%c"
    )
)

echo ------------------------------------------------------------------------------------------------------------------------------------
echo.
echo Tong so users: !index!
echo.

REM Kiem tra neu khong co user nao
if !index! equ 0 (
    echo [INFO] Khong co user nao trong he thong!
)

echo ====================================================================================================================================
echo.
echo Nhan phim bat ky de quay lai menu chinh...
pause >nul
endlocal
goto menu

REM Subroutine xu ly moi user
:processuser
setlocal enabledelayedexpansion
set "username=%~1"

REM Tang bien dem
for /f "tokens=*" %%x in ('set /a index+=1') do set index=%%x

REM Lay SID cua user
set "usersid="
for /f "tokens=*" %%s in ('wmic useraccount where "name='%username%'" get sid 2^>nul ^| findstr "S-"') do (
    set "usersid=%%s"
    REM Loai bo khoang trang thua
    set "usersid=!usersid: =!"
)

REM Lay thong tin Account expires
set "accountexpires=Never"
for /f "tokens=*" %%e in ('net user "%username%" 2^>nul ^| findstr /i /c:"Account expires"') do (
    set "expline=%%e"
    REM Loai bo phan "Account expires"
    set "expline=!expline:*expires=!"
    REM Loai bo khoang trang dau
    for /f "tokens=*" %%t in ("!expline!") do set "accountexpires=%%t"
)

REM Kiem tra xem user co phai Administrator khong
set "isadmin= No "
echo %adminlist% | findstr /i " %username% " >nul
if %errorlevel% equ 0 (
    set "isadmin= Yes"
)

REM Lay danh sach nhom
set "groups="
for /f "tokens=*" %%g in ('net user "%username%" 2^>nul ^| findstr /i "Local Group"') do (
    set "groupline=%%g"
    set "groupline=!groupline:*Local Group Memberships      =!"
    set "groups=!groupline!"
)

REM Padding cho ten user (20 ky tu)
set "padname=%username%                    "
set "padname=!padname:~0,20!"

REM Padding cho SID (48 ky tu)
set "padsid=!usersid!                                                "
set "padsid=!padsid:~0,48!"

REM Padding cho Account Expires (17 ky tu)
set "padexpires=!accountexpires!                 "
set "padexpires=!padexpires:~0,17!"

REM Hien thi dong thong tin
echo [!index!]   !padname!!padsid!!padexpires!!isadmin!   !groups!

endlocal & set index=%index%
goto :eof

:deleteuser
cls
echo ====================================================================================================================================
echo                                      XOA USER - DANH SACH USER HIEN CO
echo ====================================================================================================================================
echo.

setlocal enabledelayedexpansion

REM Lay danh sach administrators
set "adminlist="
for /f "skip=4 tokens=*" %%a in ('net localgroup administrators 2^>nul') do (
    set "line=%%a"
    if not "!line!"=="" (
        if not "!line:~0,3!"=="The" (
            if not "!line:~0,3!"=="---" (
                set "adminlist=!adminlist! %%a "
            )
        )
    )
)

REM Tao header cho bang
echo ------------------------------------------------------------------------------------------------------------------------------------
echo STT   Ten User            SID                                              Het han          Admin   Nhom
echo ------------------------------------------------------------------------------------------------------------------------------------

REM Khoi tao bien dem
set index=0

REM Xu ly tung user - net user tra ve 3 users tren moi dong
for /f "skip=4 tokens=1-3" %%a in ('net user 2^>nul') do (
    REM Kiem tra dong cuoi cung
    if not "%%a"=="The" (
        set /a index+=1
        set "user!index!=%%a"
        
        REM Lay SID
        set "usersid="
        for /f "tokens=*" %%s in ('wmic useraccount where "name='%%a'" get sid 2^>nul ^| findstr "S-"') do (
            set "usersid=%%s"
            set "usersid=!usersid: =!"
        )
        
        REM Lay Account expires
        set "accountexpires=Never"
        for /f "tokens=*" %%e in ('net user "%%a" 2^>nul ^| findstr /i /c:"Account expires"') do (
            set "expline=%%e"
            set "expline=!expline:*expires=!"
            for /f "tokens=*" %%t in ("!expline!") do set "accountexpires=%%t"
        )
        
        REM Kiem tra admin
        set "isadmin= No "
        echo !adminlist! | findstr /i " %%a " >nul
        if !errorlevel! equ 0 set "isadmin= Yes"
        
        REM Lay nhom
        set "groups="
        for /f "tokens=*" %%g in ('net user "%%a" 2^>nul ^| findstr /i "Local Group"') do (
            set "groupline=%%g"
            set "groupline=!groupline:*Local Group Memberships      =!"
            set "groups=!groupline!"
        )
        
        REM Padding
        set "padname=%%a                    "
        set "padname=!padname:~0,20!"
        set "padsid=!usersid!                                                "
        set "padsid=!padsid:~0,48!"
        set "padexpires=!accountexpires!                 "
        set "padexpires=!padexpires:~0,17!"
        
        echo [!index!]   !padname!!padsid!!padexpires!!isadmin!   !groups!
    )
    
    if not "%%b"=="" (
        if not "%%b"=="command" (
            set /a index+=1
            set "user!index!=%%b"
            
            REM Lay SID
            set "usersid="
            for /f "tokens=*" %%s in ('wmic useraccount where "name='%%b'" get sid 2^>nul ^| findstr "S-"') do (
                set "usersid=%%s"
                set "usersid=!usersid: =!"
            )
            
            REM Lay Account expires
            set "accountexpires=Never"
            for /f "tokens=*" %%e in ('net user "%%b" 2^>nul ^| findstr /i /c:"Account expires"') do (
                set "expline=%%e"
                set "expline=!expline:*expires=!"
                for /f "tokens=*" %%t in ("!expline!") do set "accountexpires=%%t"
            )
            
            REM Kiem tra admin
            set "isadmin= No "
            echo !adminlist! | findstr /i " %%b " >nul
            if !errorlevel! equ 0 set "isadmin= Yes"
            
            REM Lay nhom
            set "groups="
            for /f "tokens=*" %%g in ('net user "%%b" 2^>nul ^| findstr /i "Local Group"') do (
                set "groupline=%%g"
                set "groupline=!groupline:*Local Group Memberships      =!"
                set "groups=!groupline!"
            )
            
            REM Padding
            set "padname=%%b                    "
            set "padname=!padname:~0,20!"
            set "padsid=!usersid!                                                "
            set "padsid=!padsid:~0,48!"
            set "padexpires=!accountexpires!                 "
            set "padexpires=!padexpires:~0,17!"
            
            echo [!index!]   !padname!!padsid!!padexpires!!isadmin!   !groups!
        )
    )
    
    if not "%%c"=="" (
        set /a index+=1
        set "user!index!=%%c"
        
        REM Lay SID
        set "usersid="
        for /f "tokens=*" %%s in ('wmic useraccount where "name='%%c'" get sid 2^>nul ^| findstr "S-"') do (
            set "usersid=%%s"
            set "usersid=!usersid: =!"
        )
        
        REM Lay Account expires
        set "accountexpires=Never"
        for /f "tokens=*" %%e in ('net user "%%c" 2^>nul ^| findstr /i /c:"Account expires"') do (
            set "expline=%%e"
            set "expline=!expline:*expires=!"
            for /f "tokens=*" %%t in ("!expline!") do set "accountexpires=%%t"
        )
        
        REM Kiem tra admin
        set "isadmin= No "
        echo !adminlist! | findstr /i " %%c " >nul
        if !errorlevel! equ 0 set "isadmin= Yes"
        
        REM Lay nhom
        set "groups="
        for /f "tokens=*" %%g in ('net user "%%c" 2^>nul ^| findstr /i "Local Group"') do (
            set "groupline=%%g"
            set "groupline=!groupline:*Local Group Memberships      =!"
            set "groups=!groupline!"
        )
        
        REM Padding
        set "padname=%%c                    "
        set "padname=!padname:~0,20!"
        set "padsid=!usersid!                                                "
        set "padsid=!padsid:~0,48!"
        set "padexpires=!accountexpires!                 "
        set "padexpires=!padexpires:~0,17!"
        
        echo [!index!]   !padname!!padsid!!padexpires!!isadmin!   !groups!
    )
)

echo ------------------------------------------------------------------------------------------------------------------------------------

REM Luu tong so users
set totalusers=!index!

echo.
echo Tong so users: !totalusers!
echo.

REM Kiem tra neu khong co user nao
if !totalusers! equ 0 (
    echo [INFO] Khong co user nao trong he thong!
    echo.
    echo Nhan phim bat ky de quay lai menu...
    pause >nul
    endlocal
    goto menu
)

echo ====================================================================================================================================
echo.
echo [0] Quay lai menu chinh
echo.
set /p selection="Nhap so thu tu hoac ten user muon xoa: "
echo.

REM Neu chon 0, quay lai menu
if "!selection!"=="0" (
    endlocal
    goto menu
)

REM Kiem tra xem nhap vao la so hay chu
set "deleteuser="
set /a "testnum=!selection!" 2>nul

REM Neu la so hop le, lay ten user tu array
if !errorlevel! equ 0 (
    if !selection! geq 1 if !selection! leq !totalusers! (
        set "deleteuser=!user%selection%!"
    ) else (
        echo [ERROR] So thu tu khong hop le! Vui long chon tu 1 den !totalusers!
        echo.
        pause
        endlocal
        goto deleteuser
    )
) else (
    REM Neu khong phai so, coi nhu nhap ten truc tiep
    set "deleteuser=!selection!"
)

REM Kiem tra user co ton tai khong
net user "!deleteuser!" >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] User "!deleteuser!" khong ton tai!
    timeout /t 3 >nul
    endlocal
    goto deleteuser
)

REM Hien thi thong tin chi tiet cua user sap xoa
echo ====================================================================================================================================
echo                                        THONG TIN USER SAP XOA
echo ====================================================================================================================================
echo.
echo Ten User: !deleteuser!
echo.

REM Lay SID
echo SID:
for /f "tokens=*" %%s in ('wmic useraccount where "name='!deleteuser!'" get sid 2^>nul ^| findstr "S-"') do (
    echo   %%s
)
echo.

REM Hien thi thong tin day du tu net user
echo Thong tin chi tiet:
net user "!deleteuser!" | findstr /v "The command"
echo.

echo ====================================================================================================================================
echo [CANH BAO] Ban sap xoa user: !deleteuser!
echo ====================================================================================================================================
echo.
set /p confirm="Ban co chac chan muon xoa user nay? (Y/N): "

if /i not "!confirm!"=="Y" (
    echo.
    echo [CANCELLED] Da huy thao tac xoa user.
    timeout /t 2 >nul
    endlocal
    goto deleteuser
)

REM Xoa user
echo.
echo [1/3] Dang xoa user...
net user "!deleteuser!" /delete
if !errorlevel! neq 0 (
    echo [ERROR] Khong the xoa user!
    pause
    endlocal
    goto deleteuser
)
echo [OK] Da xoa user thanh cong!
echo.

REM Xoa registry entry (neu co)
echo [2/3] Dang xoa thong tin registry...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v "!deleteuser!" /f >nul 2>&1
echo [OK] Da xoa thong tin registry!
echo.

REM Thong bao xoa profile folder (tuy chon)
echo [3/3] Luu y ve profile folder...
echo Profile folder co the van ton tai tai: C:\Users\!deleteuser!
echo Ban co the xoa thu cong neu can.
echo.

echo ====================================================================================================================================
echo HOAN TAT!
echo ====================================================================================================================================
echo User "!deleteuser!" da duoc xoa thanh cong!
echo ====================================================================================================================================
echo.
echo Nhan phim bat ky de quay lai menu...
pause >nul
endlocal
goto menu

:end
echo.
echo Tam biet!
timeout /t 2 >nul
exit
