/**
 * OKINAR LMS - Kurs Dokümanları Çekici Konsol Scripti (Dinamik DOM Destekli API Sürümü)
 * 
 * Bu script, Okinar Yönetim Panelinde "Dersleri Yönet" sayfasındayken çalıştırılarak
 * tüm derslerdeki dokümanların (dosyaların) listesini ve indirme bağlantılarını çeker.
 * 
 * Nasıl Kullanılır:
 * 1. Okinar Yönetim Panelinde "Dersleri Yönet" veya "Dersler" sayfasına gidin.
 * 2. F12 tuşuna basıp "Console" (Konsol) sekmesini açın.
 * 3. Bu kodun tamamını kopyalayıp konsola yapıştırın ve Enter'a basın.
 * 4. Tarama tamamlandığında `okinar_materials.json` dosyası otomatik olarak inecektir.
 */

(async () => {
    console.log("%c🚀 Okinar Doküman Scraper DOM Destekli API Sürümü Başlatıldı...", "color: #28a745; font-weight: bold; font-size: 14px;");

    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    // Eğer DataTable aktifse, arka sayfadaki verilerin DOM'a yüklenmesi için sayfa boyutunu 1000 yapalım
    if (typeof $ !== 'undefined' && $.fn.DataTable && $.fn.DataTable.isDataTable('#dtbl')) {
        try {
            console.log("📊 DataTable tespit edildi. Tüm satırların DOM'a yüklenmesi için sayfa boyutu 1000 yapılıyor...");
            $('#dtbl').DataTable().page.len(1000).draw();
            // Tablonun yeniden çizilmesi ve render edilmesi için kısa bir süre bekleyelim
            await sleep(2000);
        } catch (e) {
            console.warn("⚠️ Sayfa boyutu otomatik artırılamadı, mevcut görünüm üzerinden devam ediliyor:", e);
        }
    }

    // Doğrudan DOM üzerinden (ekranda görünen) satırları çek
    const rows = Array.from(document.querySelectorAll('table#dtbl tbody tr, table.table tbody tr'));
    console.log(`🔍 DOM üzerinde toplam ${rows.length} ders satırı bulundu. Analiz ediliyor...`);

    if (rows.length === 0) {
        console.error("❌ Hata: Sayfada ders satırı bulunamadı! Doğru sayfada (Dersleri Yönet) olduğunuzdan emin olun.");
        return;
    }

    const coursesToScrape = [];
    const debugInfo = [];

    rows.forEach((row, idx) => {
        const cells = row.cells;
        if (!cells || cells.length < 1) return;

        // İşlemler kolonundaki butonlar ve linkler
        const clickables = Array.from(row.querySelectorAll('a, button, [onclick], .btn, [class*="btn"]'));

        // Ders Adını bul
        let courseName = "";
        if (cells.length >= 2) {
            courseName = cells[1].textContent.trim();
        } else {
            // Eğer tek hücre varsa (mobil/responsive mod), ders adını "Katıl" butonundaki onclick fonksiyonunun ikinci parametresinden çek
            const joinBtn = clickables.find(el => el.getAttribute('onclick')?.includes('isRoomReady'));
            if (joinBtn) {
                const match = joinBtn.getAttribute('onclick').match(/isRoomReady\([^,]+,\s*['"]([^'"]+)['"]/);
                if (match) {
                    courseName = match[1];
                }
            }
            if (!courseName) {
                // Alternatif olarak hücredeki ilk satır metnini al
                courseName = cells[0].textContent.trim().split('\n')[0].trim();
            }
        }
        
        // Buton adı "Kaynaklar" olarak tasarlanmış. "Kaynaklar" veya "Dosyalar" butonunu yakala.
        let filesLink = clickables.find(el => {
            const text = el.textContent.trim().toLowerCase();
            const href = el.getAttribute('href') || '';
            const onclick = el.getAttribute('onclick') || '';
            const className = el.className || '';
            
            return text.includes('dosya') || text.includes('doküman') || text.includes('document') || text.includes('kaynak') ||
                   href.includes('/files') || href.includes('/dosya') || href.includes('/material') || href.includes('/document') || href.includes('/sources') ||
                   onclick.includes('files') || onclick.includes('dosya') || onclick.includes('material') || onclick.includes('document') || onclick.includes('sources') ||
                   className.includes('file') || className.includes('folder') || className.includes('book');
        });

        let mid = null;
        if (filesLink) {
            let href = filesLink.getAttribute('href') || '';
            let onclick = filesLink.getAttribute('onclick') || '';
            
            // Onclick içerisinde documents('HASH') çağrısını ara
            const docMatch = onclick.match(/documents\(['"]([^'"]+)['"]\)/);
            if (docMatch) {
                mid = docMatch[1];
            } else if (href && href !== '#' && !href.startsWith('javascript:')) {
                const parts = href.split('/');
                mid = parts[parts.length - 1];
            } else if (onclick) {
                const locMatch = onclick.match(/(?:location\.href|location|window\.location|window\.open)\s*=\s*['"]([^'"]+)['"]/);
                if (locMatch) {
                    const parts = locMatch[1].split('/');
                    mid = parts[parts.length - 1];
                } else {
                    const idMatch = onclick.match(/[a-f0-9]{32,40}/i) || onclick.match(/\d+/);
                    if (idMatch) {
                        mid = idMatch[0];
                    }
                }
            }
        }

        if (idx < 5) {
            debugInfo.push({
                index: idx,
                courseName: courseName,
                foundButton: !!filesLink,
                tag: filesLink ? filesLink.tagName : null,
                text: filesLink ? filesLink.textContent.trim() : null,
                onclickVal: filesLink ? filesLink.getAttribute('onclick') : null,
                resolvedMid: mid
            });
        }

        if (mid) {
            coursesToScrape.push({
                courseName: courseName,
                mid: mid
            });
        }
    });

    if (coursesToScrape.length === 0) {
        console.warn("⚠️ Ders dosyası butonları çözümlenemedi! Teşhis tablosu:");
        console.table(debugInfo);
        return;
    }

    console.log(`📥 Toplam ${coursesToScrape.length} derste doküman taraması yapılacak. Başlıyor...`);

    const result = [];
    let processedCount = 0;

    for (const course of coursesToScrape) {
        processedCount++;
        console.log(`[${processedCount}/${coursesToScrape.length}] 📂 Ders taranıyor: ${course.courseName}`);
        
        try {
            // Okinar JSON API'sine istek at
            const apiUrl = `${window.location.origin}/documents/get_documents_detail/${course.mid}`;
            const response = await fetch(apiUrl);
            if (!response.ok) {
                console.warn("⚠️ API çağrısı başarısız oldu: " + course.courseName + " (" + response.status + ")");
                continue;
            }
            
            const data = await response.json();
            const files = [];

            if (data && data.details && Array.isArray(data.details)) {
                data.details.forEach(element => {
                    files.push({
                        title: element.description,
                        downloadUrl: `${window.location.origin}/files/${element.path}`,
                        createdAt: element.created_at
                    });
                });
            }

            console.log(`   └─ ✅ ${files.length} doküman bulundu.`);
            result.push({
                courseName: course.courseName,
                files: files
            });

        } catch (error) {
            console.error("❌ Hata oluştu (" + course.courseName + "):", error);
        }

        // Sunucuyu yormamak için kısa bekleme
        await sleep(100);
    }

    // JSON indir
    if (result.length > 0) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(result, null, 2));
        const downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "okinar_materials.json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        console.log("%c🎉 Tarama tamamlandı! okinar_materials.json dosyası indirildi.", "color: #28a745; font-weight: bold; font-size: 14px;");
    } else {
        console.warn("⚠️ Tarama bitti fakat hiçbir doküman bulunamadı!");
    }
})();
