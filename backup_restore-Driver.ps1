#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass .\backup_restore.ps1

# Hàm kiểm tra quyền Administrator
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "Dang yeu cau quyen Administrator..." -ForegroundColor Yellow
        Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

# Hàm kiểm tra đường dẫn tồn tại
function Test-PathExists {
    param ([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Host "Duong dan $Path khong ton tai!" -ForegroundColor Red
        return $false
    }
    return $true
}

# Hàm hiển thị menu
function Show-Menu {
    Clear-Host
    Write-Host "===== MENU BACKUP/RESTORE ====="
    Write-Host "1. Backup Drivers"
    Write-Host "2. Restore Drivers"
    Write-Host "3. Thoat"
    Write-Host "=============================="
}

# Kiểm tra quyền Administrator
Test-Admin

# Vòng lặp chính
while ($true) {
    Show-Menu
    $choice = Read-Host "Nhap lua chon (1-3)"

    if ($choice -eq '3') {
        Write-Host "Da thoat chuong trinh." -ForegroundColor Yellow
        break
    }

    if ($choice -ne '1' -and $choice -ne '2') {
        Write-Host "Lua chon khong hop le! Vui long chon 1, 2 hoac 3." -ForegroundColor Red
        Start-Sleep -Seconds 2
        continue
    }

    # Nhập và kiểm tra đường dẫn
    $path = Read-Host "Nhap duong dan (vi du: D:\Backup)"
    
    if (-not (Test-PathExists $path)) {
        Write-Host "Vui long nhap lai duong dan hop le." -ForegroundColor Red
        Start-Sleep -Seconds 2
        continue
    }

    # Thực hiện Backup hoặc Restore
    if ($choice -eq '1') {
        Write-Host "Dang thuc hien backup drivers..." -ForegroundColor Green
        try {
            & dism /online /export-driver /destination:$path
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Backup hoan tat!" -ForegroundColor Green
            } else {
                Write-Host "Loi khi backup drivers! Kiem tra log tai C:\Windows\Logs\DISM\dism.log" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Loi khi backup: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Dang thuc hien restore drivers..." -ForegroundColor Green
        try {
            & pnputil /add-driver "$path\*.inf" /subdirs
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Restore hoan tat!" -ForegroundColor Green
            } else {
                Write-Host "Loi khi restore drivers! Kiem tra duong dan driver." -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Loi khi restore: $_" -ForegroundColor Red
        }
    }

    # Hỏi tiếp tục hay thoát
    $continue = Read-Host "Tiep tuc? (y/n)"
    if ($continue -notmatch '^[yY]$') {
        Write-Host "Da thoat chuong trinh." -ForegroundColor Yellow
        break
    }
}