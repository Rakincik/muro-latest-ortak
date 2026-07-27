// =========================================================================
// OKINAR LMS - Bireysel Ders Tanımları ve ON/OFF Durumu Çekici Konsol Scripti
// =========================================================================
// Bu scripti Okinar Yönetim Panelinde "Kullanıcılar" sayfasındayken 
// F12 -> Console sekmesine yapıştırıp çalıştırabilirsiniz.
// =========================================================================

(async () => {
    console.log("🚀 Okinar Bireysel Ders Scraper Başlatıldı...");
    
    // Sonuçların biriktirileceği dizi
    let scrapedData = [];
    
    // Yardımcı bekleme fonksiyonu (ms cinsinden)
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    
    // Modalı kapatma yardımcı fonksiyonu (Bootstrap/jQuery uyumlu)
    const closeModal = () => {
        try {
            if (typeof $ !== 'undefined' && $('#modal-meeting').length) {
                $('#modal-meeting').modal('hide');
            } else {
                const closeBtn = document.querySelector('#modal-meeting .close') || 
                                 document.querySelector('#modal-meeting [data-dismiss="modal"]') ||
                                 document.querySelector('#modal-meeting button:contains("Vazgeç")');
                if (closeBtn) closeBtn.click();
            }
        } catch (e) {
            console.error("Modal kapatılamadı:", e);
        }
    };

    // Limit Tarihi (28.06.2026) - Haziran ayı JS'de 5. indekstir (0-indexed)
    const limitDate = new Date(2026, 5, 28); 
    let reachedLimit = false;

    // String temizleme ve normalleştirme fonksiyonu
    const cleanStr = (str) => {
        if (!str) return "";
        return str.toLowerCase().trim()
            .replace(/ı/g, 'i')
            .replace(/ğ/g, 'g')
            .replace(/ü/g, 'u')
            .replace(/ş/g, 's')
            .replace(/ö/g, 'o')
            .replace(/ç/g, 'c');
    };

    // Tarih ayrıştırma yardımcı fonksiyonu
    const parseDateStr = (str) => {
        if (!str) return null;
        // Örn: 15.01.2026 veya 15.01.2026 10:00
        if (str.includes('.')) {
            const parts = str.split(' ')[0].split('.');
            if (parts.length === 3) return new Date(parts[2], parts[1] - 1, parts[0]);
        }
        // Örn: 2026-01-15 veya 2026-01-15 10:00
        if (str.includes('-')) {
            const parts = str.split(' ')[0].split('-');
            if (parts.length === 3) return new Date(parts[0], parts[1] - 1, parts[2]);
        }
        return null;
    };

    // Tek bir sayfadaki kullanıcıları sırayla tarayan fonksiyon
    const scrapePageUsers = async () => {
        // Tablo başlıklarından kolonları bul
        const getColIdxs = () => {
            const headers = Array.from(document.querySelectorAll('table#dtbl thead th')).map(th => cleanStr(th.innerText));
            return {
                nameIdx: headers.findIndex(h => h.includes('ad soyad') || h.includes('adi') || h.includes('soyad') || h.includes('isim')),
                phoneIdx: headers.findIndex(h => h.includes('telefon') || h.includes('tel')),
                emailIdx: headers.findIndex(h => h.includes('email') || h.includes('eposta') || h.includes('mail')),
                dateIdx: headers.findIndex(h => h.includes('tarih') || h.includes('kayit')),
                updateIdx: headers.findIndex(h => h.includes('guncelleme') || h.includes('guncel') || h.includes('duzenleme'))
            };
        };
        const cols = getColIdxs();

        const rows = document.querySelectorAll('table#dtbl tbody tr');
        console.log(`🔍 Bu sayfada ${rows.length} kullanıcı satırı bulundu. Tarama başlıyor...`);
        
        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            
            // Boş satırları veya "Gösterilecek veri yok" satırını atla
            if (row.innerText.includes("veri yok") || row.cells.length < 4) {
                continue;
            }
            
            // Kullanıcı bilgilerini dinamik sütunlardan al
            const name = cols.nameIdx !== -1 && row.cells[cols.nameIdx] ? row.cells[cols.nameIdx].innerText.trim() : "Bilinmeyen Kullanıcı";
            const phone = cols.phoneIdx !== -1 && row.cells[cols.phoneIdx] ? row.cells[cols.phoneIdx].innerText.trim() : "";
            const email = cols.emailIdx !== -1 && row.cells[cols.emailIdx] ? row.cells[cols.emailIdx].innerText.trim() : "";
            
            // Tarih kontrolü
            const dateText = cols.dateIdx !== -1 && row.cells[cols.dateIdx] ? row.cells[cols.dateIdx].innerText.trim() : "";
            const regDate = parseDateStr(dateText);

            const updateText = cols.updateIdx !== -1 && row.cells[cols.updateIdx] ? row.cells[cols.updateIdx].innerText.trim() : "";
            const updateDate = parseDateStr(updateText);

            // Kayıt veya güncelleme tarihlerinden en yeni olanı al
            const maxDate = (regDate && updateDate) ? (regDate > updateDate ? regDate : updateDate) : (regDate || updateDate);

            if (maxDate && maxDate < limitDate) {
                console.log(`🛑 Sınır Tarihine Ulaşıldı! En yeni tarih: ${dateText || updateText} (< 28.06.2026). Tarama durduruluyor.`);
                reachedLimit = true;
                break;
            }

            console.log(`👤 [${i+1}/${rows.length}] ${name} | Tel: ${phone} | E-posta: ${email} | Kayıt: ${dateText} | Güncelleme: ${updateText} taranıyor...`);
            
            // "Dersler" butonunu bul (btn_meeting_modal veya ders butonu)
            const dersBtn = row.querySelector('button[onclick*="btn_meeting_modal"]') || 
                            row.querySelector('button[onclick*="meeting"]') ||
                            Array.from(row.querySelectorAll('button')).find(btn => btn.innerText.includes('Dersler'));
            if (!dersBtn) {
                console.log(`   ⚠️ ${name} için Dersler butonu bulunamadı, geçiliyor.`);
                continue;
            }
            
            // Butona tıkla ve modalın açılmasını bekle
            dersBtn.click();
            
            // Modalın dolması ve açılması için bekle (AJAX yüklemesi yapılıyor)
            let loaded = false;
            let retries = 10;
            let courses = [];
            
            while (!loaded && retries > 0) {
                await sleep(400); // 400ms bekle
                
                // Modal içindeki sağ tabloyu seç (Seçilen/Atanan dersler tablosu)
                const modal = document.querySelector('#modal-meeting');
                if (modal && modal.classList.contains('show') || (modal && window.getComputedStyle(modal).display !== 'none')) {
                    // Modal içindeki ikinci tablo genellikle atanan dersler tablosudur
                    const tables = modal.querySelectorAll('table');
                    if (tables.length >= 2) {
                        const rightTable = tables[1]; // Sağdaki tablo
                        const courseRows = rightTable.querySelectorAll('tbody tr');
                        
                        // "Veri yok" veya "Gösterilecek ders yok" durumu değilse ve yükleme tamamlandıysa
                        if (courseRows.length > 0) {
                            const firstRowText = courseRows[0].innerText;
                            if (firstRowText.includes("yükleniyor") || firstRowText.includes("Loading")) {
                                // Hala yükleniyor, bekle
                                retries--;
                                continue;
                            }
                            
                            // Dersleri oku
                            courseRows.forEach(cRow => {
                                if (cRow.cells.length >= 2) {
                                    const cName = cRow.cells[0].innerText.trim();
                                    if (cName && !cName.includes("veri yok") && !cName.includes("Satır")) {
                                        // Durum butonunu veya metnini oku (ON/OFF)
                                        const statusText = cRow.cells[1].innerText.trim().toUpperCase();
                                        const isOnline = statusText.includes("ON");
                                        
                                        courses.push({
                                            courseName: cName,
                                            status: isOnline ? "online" : "offline"
                                        });
                                    }
                                }
                            });
                            loaded = true;
                        }
                    }
                }
                retries--;
            }
            
            console.log(`   📚 Bulunan Ders Sayısı: ${courses.length}`, courses);
            
            // Kullanıcı verisini kaydet
            scrapedData.push({
                name: name,
                phone: phone,
                email: email,
                courses: courses
            });
            
            // Modalı kapat ve bir sonraki kullanıcıya geçmeden önce bekle
            closeModal();
            await sleep(300);
        }
    };

    // Tüm sayfaları gezmek için döngü (Pagination desteği)
    let hasNextPage = true;
    let pageCount = 1;
    
    while (hasNextPage) {
        console.log(`\n📄 --- SAYFA ${pageCount} TARANIYOR ---`);
        await scrapePageUsers();
        
        if (reachedLimit) {
            console.log("🛑 Sınır Tarihine Ulaşıldığı İçin Sayfa Geçişi Durduruldu.");
            break;
        }
        
        // "Sonraki" (Next) butonunu bul
        const nextBtn = document.querySelector('li.paginate_button.next:not(.disabled) a') || 
                          document.querySelector('#dtbl_next:not(.disabled)') || 
                          document.querySelector('a.next:not(.disabled)');
                          
        if (nextBtn && !nextBtn.closest('.disabled') && !nextBtn.classList.contains('disabled')) {
            console.log("➡️ Sonraki sayfaya geçiliyor...");
            
            // İlk satırın değişmesini izlemek için içeriğini al
            const firstRow = document.querySelector('table#dtbl tbody tr');
            const prevRowText = firstRow ? firstRow.innerText.trim() : '';

            nextBtn.click();
            pageCount++;
            
            // Yeni sayfanın yüklendiğinden emin olana kadar bekle
            let waitRetries = 25;
            while (waitRetries > 0) {
                await sleep(300);
                const currentFirstRow = document.querySelector('table#dtbl tbody tr');
                const newRowText = currentFirstRow ? currentFirstRow.innerText.trim() : '';
                if (newRowText !== prevRowText && !newRowText.includes('yükleniyor') && !newRowText.toLowerCase().includes('loading')) {
                    break;
                }
                waitRetries--;
            }
            await sleep(500);
        } else {
            console.log("🏁 Son sayfaya ulaşıldı veya sonraki sayfa butonu aktif değil.");
            hasNextPage = false;
        }
    }

    // Sonuçları JSON olarak indir
    console.log(`\n🎉 Tarama Bitti! Toplam ${scrapedData.length} kullanıcı taranarak dersleri çıkartıldı.`);
    
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(scrapedData, null, 2));
    const downloadAnchor = document.createElement('a');
    downloadAnchor.setAttribute("href", dataStr);
    downloadAnchor.setAttribute("download", "okinar_bireysel_dersler.json");
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    downloadAnchor.remove();
    console.log("💾 'okinar_bireysel_dersler.json' dosyası indirildi!");
})();
