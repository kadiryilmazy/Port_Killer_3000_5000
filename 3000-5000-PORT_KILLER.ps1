$ports = @(3000, 5000)

foreach ($port in $ports) {
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