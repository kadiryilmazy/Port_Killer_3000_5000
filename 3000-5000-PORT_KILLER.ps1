$ports = Read-Host "Kontrol edilecek portları virgülle ayrılmış olarak girin (örneğin: 3000,5000)"
$portList = $ports -split ',' | ForEach-Object { $_.Trim() }

foreach ($port in $portList) {
    if ($port -notmatch '^\d+$') {
        Write-Warning "$port geçerli bir port numarası değil. Atlanıyor."
        continue
    }

    Write-Host "$port portu kontrol ediliyor..."
    $connections = Get-NetTCPConnection -LocalPort $port

    if ($connections) {
        foreach ($connection in $connections) {
            $process = Get-Process -Id $connection.OwningProcess -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "PID: $($process.Id) ($port) işlemi sonlandırılıyor..."
                try {
                    Stop-Process -Id $process.Id -Force
                    Write-Host "PID $($process.Id) başarıyla sonlandırıldı."
                }
                catch {
                    Write-Warning "PID $($process.Id) sonlandırılırken bir hata oluştu: $($_.Exception.Message)"
                }
            } else {
                Write-Warning "$port portunu dinleyen PID bulunamadı."
            }
        }
    } else {
        Write-Host "$port portunda dinleyen bir bağlantı bulunamadı."
    }
}

Write-Host "İşlem tamamlandı."
Pause