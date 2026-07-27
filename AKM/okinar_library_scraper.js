/**
 * OKINAR LMS - Kütüphane / Dosyalar Çekici Konsol Scripti
 * 
 * Bu script, Okinar tabanlı LMS sitelerinden "Kütüphane" veya "Dosyalar" 
 * sayfasındaki PDF ve diğer dosyaları listeler, indirme bağlantılarını çıkarır
 * ve hem JSON olarak kaydeder hem de sunucuda toplu indirmek için wget komutları üretir.
 * 
 * Hızlı Kullanım:
 * 1. Tarayıcınızda "Kütüphane" veya "Dosyalar" sayfasına gidin.
 * 2. Tablonun altında gösterim sayısını en yüksek yapın (örn: 100).
 * 3. F12 -> Console sekmesine bu kodun tamamını yapıştırıp Enter'a basın.
 */

(() => {
    console.log("🚀 Kütüphane tarayıcı başlatılıyor...");

    // Gösterim sayısını 100 yapmayı dene
    try {
        const lengthSelect = document.querySelector('select[name$="_length"], select.custom-select, select.form-control-sm');
        if (lengthSelect && lengthSelect.value !== '100') {
            lengthSelect.value = '100';
            lengthSelect.dispatchEvent(new Event('change'));
            console.log("⏳ Tablo satır sayısı 100 yapıldı, yüklenmesi bekleniyor...");
        }
    } catch (e) {}

    setTimeout(() => {
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        if (rows.length === 0) {
            console.error("❌ Tabloda dosya bulunamadı! Doğru sayfada olduğunuzdan emin olun.");
            return;
        }

        const files = [];
        let wgetCommands = "#!/bin/bash\nmkdir -p /opt/akm/library_downloads\ncd /opt/akm/library_downloads\n\n";

        rows.forEach((row, index) => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 2) {
                // 1. Tarih
                const dateText = cells[0].innerText.trim();

                // 2. Dosya adı ve linki
                const fileLink = cells[1].querySelector('a');
                if (fileLink) {
                    const title = fileLink.innerText.trim();
                    const relativeUrl = fileLink.getAttribute('href');
                    
                    // Mutlak URL oluştur
                    let absoluteUrl = relativeUrl;
                    if (relativeUrl && !relativeUrl.startsWith('http')) {
                        absoluteUrl = window.location.origin + (relativeUrl.startsWith('/') ? '' : '/') + relativeUrl;
                    }

                    // Dosya uzantısını belirle (genelde link veya başlıkta olur, varsayılan .pdf)
                    let fileId = relativeUrl.split('/').pop();
                    if (!fileId.includes('.')) {
                        fileId += ".pdf";
                    }

                    files.push({
                        id: index + 1,
                        date: dateText,
                        title: title,
                        originalUrl: absoluteUrl,
                        filename: fileId
                    });

                    wgetCommands += `wget -O "${fileId}" "${absoluteUrl}"\n`;
                }
            }
        });

        console.log(`📊 Toplam ${files.length} dosya bulundu.`);

        // 1. JSON dosyasını indir
        const jsonBlob = new Blob([JSON.stringify(files, null, 2)], { type: 'application/json' });
        const jsonUrl = URL.createObjectURL(jsonBlob);
        const jsonA = document.createElement('a');
        jsonA.href = jsonUrl;
        jsonA.download = `${window.location.hostname}_kutuphane_dosyalari.json`;
        document.body.appendChild(jsonA);
        jsonA.click();
        jsonA.remove();
        URL.revokeObjectURL(jsonUrl);

        // 2. Wget script dosyasını indir
        const shBlob = new Blob([wgetCommands], { type: 'text/plain' });
        const shUrl = URL.createObjectURL(shBlob);
        const shA = document.createElement('a');
        shA.href = shUrl;
        shA.download = `download_library.sh`;
        document.body.appendChild(shA);
        shA.click();
        shA.remove();
        URL.revokeObjectURL(shUrl);

        console.log("✅ JSON listesi ve toplu indirme scripti (download_library.sh) başarıyla indirildi!");
        console.log("💡 Yapmanız gerekenler:");
        console.log("1. 'download_library.sh' dosyasını panel sunucusuna yükleyin.");
        console.log("2. 'chmod +x download_library.sh && ./download_library.sh' komutuyla tüm dosyaları sunucuya tek hamlede indirin.");
    }, 1500);
})();
