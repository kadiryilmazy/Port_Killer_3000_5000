﻿# Port_Killer_3000_5000

Birbirleriyle ilişki içerisinde olan api ve localhost port servis sunucularının, ilgili portlarının(3000,5000) kullanımda olması yüzünden verimli çalışamaması sonucu ilgili portları sonlandırmak için yazılmıştır.

Bu PowerShell betiği, belirtilen TCP portlarını dinleyen işlemleri kontrol eder ve isteğe bağlı olarak bu işlemleri sonlandırır.

## Amaç

Bu araç, belirli portlar üzerinde çalışan ve potansiyel olarak sorunlara neden olan (örneğin, geliştirme ortamında çakışan uygulamalar) işlemleri hızlı bir şekilde bulmak ve durdurmak için tasarlanmıştır.

## Nasıl Çalışır?

Betik aşağıdaki adımları izler:

1.  **Portları Tanımlar:** `$ports` değişkeninde tanımlanan port listesini (varsayılan olarak 3000 ve 5000) alır.
2.  **Her Portu Kontrol Eder:** Tanımlanan her port için aşağıdaki işlemleri gerçekleştirir:
    * Konsola hangi portun kontrol edildiğine dair bir mesaj yazdırır.
    * `Get-NetTCPConnection` komutunu kullanarak o port üzerindeki aktif TCP bağlantılarını listeler.
    * **Eğer bağlantı bulunursa:**
        * Her bağlantı için, bağlantıyı oluşturan işlemin PID'sini (`OwningProcess` özelliği) alır.
        * `Get-Process` komutunu kullanarak bu PID'ye sahip işlemi bulmaya çalışır. Eğer işlem bulunamazsa (örneğin, bağlantı kurulduktan sonra işlem sonlanmış olabilir), bir uyarı mesajı gösterir.
        * **Eğer işlem bulunursa:**
            * Konsola işlemin PID'sini ve sonlandırılmaya çalışıldığını belirten bir mesaj yazdırır.
            * Bir `try-catch` bloğu içinde `Stop-Process` komutunu kullanarak işlemi `-Force` parametresiyle sonlandırmaya çalışır.
            * İşlem başarıyla sonlandırılırsa, bir başarı mesajı gösterir.
            * İşlem sonlandırılırken bir hata oluşursa (örneğin, yetki sorunları), bir uyarı mesajı ve hata detayı gösterilir.
    * **Eğer bağlantı bulunamazsa:**
        * Konsola o portta dinleyen bir bağlantı bulunamadığına dair bir mesaj yazdırır.
3.  **İşlemi Tamamlar:** Tüm portlar kontrol edildikten sonra, konsola "İşlem tamamlandı." mesajını yazdırır.
4.  **Pencereyi Açar:** `Pause` komutu ile PowerShell penceresinin açık kalmasını sağlar, böylece kullanıcı çıktıları görebilir.

## Kullanım

1.  Bu kodu bir `.ps1` dosyası olarak kaydedin (örneğin, `port_kontrol.ps1`).
2.  PowerShell'i yönetici ayrıcalıklarıyla açın (bazı işlemleri sonlandırmak için yönetici yetkileri gerekebilir).
3.  Betik dosyasının bulunduğu dizine gidin.
4.  Betik dosyasını aşağıdaki komutla çalıştırın:
    ```powershell
    .\port_kontrol.ps1
    ```
5.  Betik çalışacak ve belirtilen portlardaki işlemleri kontrol edip sonuçları ekranda gösterecektir. İşlem tamamlandıktan sonra pencereyi kapatmak için herhangi bir tuşa basın.

## Yapılandırma

* **Kontrol Edilecek Portlar:** Kontrol etmek istediğiniz portları `$ports = @(3000, 5000)` satırındaki diziye ekleyerek veya mevcut portları değiştirerek düzenleyebilirsiniz. Örneğin, 8080 ve 9000 portlarını kontrol etmek için satırı şu şekilde değiştirebilirsiniz:
    ```powershell
    $ports = @(8080, 9000)
    ```

## Gereksinimler

* Windows işletim sistemi
* PowerShell 3.0 veya üzeri (gerekli cmdlet'ler bu sürümlerde bulunmaktadır)
* İşlemleri sonlandırmak için yeterli kullanıcı yetkileri (yönetici ayrıcalıkları önerilir)

## Uyarılar

* Bu betik, belirtilen portları dinleyen işlemleri **zorla** sonlandırmaya çalışır (`-Force` parametresi kullanılır). Bu, veri kaybına veya uygulamaların beklenmedik şekilde kapanmasına neden olabilir. Bu betiği kullanmadan önce ne yaptığınızdan emin olun.
* Üretim ortamlarında bu tür betiklerin dikkatli kullanılması ve potansiyel etkilerinin değerlendirilmesi önemlidir.
