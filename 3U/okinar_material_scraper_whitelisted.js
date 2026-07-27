/**
 * DERECEUZEM / ÖMÜR HOCA LMS - Kurs Dokümanları Filtreli Çekici Konsol Scripti
 * 
 * Bu script, sadece veritabanında tanımlı olan derslerin dokümanlarını Okinar'dan çeker.
 * Böylece gereksiz ve silinmiş derslerin dokümanlarını tarayarak zaman ve veri kaybı yaşamazsınız.
 */
(async () => {
    console.log("%c🚀 Filtreli Okinar Doküman Scraper Başlatıldı...", "color: #007bff; font-weight: bold; font-size: 14px;");

    // ==========================================
    // ⚠️ ADIM 1: VERİTABANINDAN ALDIĞINIZ DERS LİSTESİNİ BURAYA YAPIŞTIRIN:
    // ==========================================
    const whitelist = [
        // get_omr_courses.py çıktısı buraya yapıştırılacak
    ];

    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    const normalize = (s) => {
        if (!s) return '';
        s = s.toLowerCase().trim();
        const charMap = {
            'ı': 'i', 'İ': 'i', 'I': 'i',
            'ş': 's', 'Ş': 's',
            'ğ': 'g', 'Ğ': 'g',
            'ü': 'u', 'Ü': 'u',
            'ö': 'o', 'Ö': 'o',
            'ç': 'c', 'Ç': 'c'
        };
        for (let tr in charMap) {
            s = s.replaceAll(tr, charMap[tr]);
        }
        return s.replace(/[^a-z0-9]/g, '');
    };

    const normalizedWhitelist = new Set(whitelist.map(normalize));
    console.log(`[INFO] Filtre listesinde ${whitelist.length} ders tanımlı (${normalizedWhitelist.size} benzersiz normalize anahtar).`);

    if (typeof $ !== 'undefined' && $.fn.DataTable && $.fn.DataTable.isDataTable('#dtbl')) {
        try {
            console.log("📊 DataTable sayfa boyutu 1000 yapılıyor...");
            $('#dtbl').DataTable().page.len(1000).draw();
            await sleep(2000);
        } catch (e) {
            console.warn("⚠️ Sayfa boyutu artırılamadı:", e);
        }
    }

    const rows = Array.from(document.querySelectorAll('table#dtbl tbody tr, table.table tbody tr'));
    console.log(`🔍 Sayfada toplam ${rows.length} ders satırı bulundu. Filtreleniyor...`);

    if (rows.length === 0) {
        console.error("❌ Hata: Ders satırı bulunamadı!");
        return;
    }

    const coursesToScrape = [];
    let skippedCount = 0;

    rows.forEach((row) => {
        const cells = row.cells;
        if (!cells || cells.length < 1) return;

        const clickables = Array.from(row.querySelectorAll('a, button, [onclick], .btn, [class*="btn"]'));

        let courseName = "";
        if (cells.length >= 2) {
            courseName = cells[1].textContent.trim();
        } else {
            const joinBtn = clickables.find(el => el.getAttribute('onclick')?.includes('isRoomReady'));
            if (joinBtn) {
                const match = joinBtn.getAttribute('onclick').match(/isRoomReady\([^,]+,\s*['"]([^'"]+)['"]/);
                if (match) courseName = match[1];
            }
            if (!courseName) courseName = cells[0].textContent.trim().split('\n')[0].trim();
        }

        // Filtre kontrolü
        const normName = normalize(courseName);
        if (whitelist.length > 0 && !normalizedWhitelist.has(normName)) {
            skippedCount++;
            return; // Filtre listesinde yoksa bu dersi es geç!
        }
        
        let filesLink = clickables.find(el => {
            const text = el.textContent.trim().toLowerCase();
            const href = el.getAttribute('href') || '';
            const onclick = el.getAttribute('onclick') || '';
            
            return text.includes('dosya') || text.includes('doküman') || text.includes('kaynak') ||
                   href.includes('/files') || href.includes('/dosya') || href.includes('/material') ||
                   onclick.includes('files') || onclick.includes('dosya') || onclick.includes('material');
        });

        let mid = null;
        if (filesLink) {
            let href = filesLink.getAttribute('href') || '';
            let onclick = filesLink.getAttribute('onclick') || '';
            
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
                    if (idMatch) mid = idMatch[0];
                }
            }
        }

        if (mid) {
            coursesToScrape.push({
                courseName: courseName,
                mid: mid
            });
        }
    });

    console.log(`[FILTER] ${skippedCount} ders filtre dışında kaldığı için atlandı.`);
    console.log(`📥 Eşleşen ${coursesToScrape.length} derste doküman taraması yapılacak. Başlıyor...`);

    const result = [];
    let processedCount = 0;

    for (const course of coursesToScrape) {
        processedCount++;
        console.log(`[${processedCount}/${coursesToScrape.length}] 📂 Ders taranıyor: ${course.courseName}`);
        
        try {
            const apiUrl = `${window.location.origin}/documents/get_documents_detail/${course.mid}`;
            const response = await fetch(apiUrl);
            if (!response.ok) {
                console.warn(`⚠️ API hatası (${response.status}): ${course.courseName}`);
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
            if (files.length > 0) {
                result.push({
                    courseName: course.courseName,
                    files: files
                });
            }

        } catch (error) {
            console.error(`❌ Hata (${course.courseName}):`, error);
        }

        await sleep(150);
    }

    if (result.length > 0) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(result, null, 2));
        const downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "okinar_materials.json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        console.log("%c🎉 Tarama tamamlandı! okinar_materials.json başarıyla indirildi.", "color: #28a745; font-weight: bold; font-size: 14px;");
    } else {
        console.warn("⚠️ Taranan derslerde hiç doküman bulunamadı!");
    }
})();
