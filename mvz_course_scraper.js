/**
 * OKINAR LMS - Bireysel Ders Tanımları ve ON/OFF Durumu Çekici Konsol Scripti
 * 
 * Bu script, Okinar Yönetim Panelinde "Kullanıcılar" sayfasındayken 
 * F12 -> Console sekmesine yapıştırıp çalıştırılabilir.
 */

(async () => {
    console.log("%c🚀 Okinar Bireysel Ders Scraper Başlatıldı...", "color: #007bff; font-weight: bold; font-size: 14px;");
    
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
                                 document.querySelector('#modal-meeting button:contains("Vazgeç")') ||
                                 Array.from(document.querySelectorAll('#modal-meeting button')).find(btn => btn.innerText.includes('Vazgeç') || btn.innerText.includes('Kapat'));
                if (closeBtn) closeBtn.click();
            }
        } catch (e) {
            console.error("Modal kapatılamadı:", e);
        }
    };

    // Dinamik olarak kolon indekslerini başlık satırından bulur
    const getColumnIndexes = () => {
        const headers = Array.from(document.querySelectorAll('table#dtbl thead th')).map(th => th.innerText.trim().toLowerCase());
        console.log("📊 Tespit edilen tablo başlıkları:", headers);
        
        return {
            nameIdx: headers.findIndex(h => h.includes('adı') || h.includes('soyad') || h.includes('ad soyad')),
            phoneIdx: headers.findIndex(h => h.includes('tel') || h.includes('telefon')),
            emailIdx: headers.findIndex(h => h.includes('eposta') || h.includes('e-posta') || h.includes('mail')),
            roleIdx: headers.findIndex(h => h.includes('rol'))
        };
    };

    // Modalın açılmasını ve verilerin yüklenmesini bekleyen fonksiyon
    const waitForModalAndData = async () => {
        let retries = 15; // Toplamda 4.5 saniye bekleyebilir
        while (retries > 0) {
            const modal = document.querySelector('#modal-meeting') || document.querySelector('.modal.show') || document.querySelector('.modal');
            if (modal && (modal.classList.contains('show') || window.getComputedStyle(modal).display !== 'none')) {
                const tables = Array.from(modal.querySelectorAll('table'));
                if (tables.length >= 2) {
                    // Sağdaki tabloyu bul (içinde İşlem veya Çıkar metni olan)
                    const rightTable = tables.find(t => t.innerText.includes('İşlem') || t.innerText.includes('Çıkar') || t.innerText.includes('çıkar')) || tables[1];
                    const courseRows = rightTable.querySelectorAll('tbody tr');
                    
                    if (courseRows.length > 0) {
                        const firstRowText = courseRows[0].innerText.toLowerCase();
                        if (!firstRowText.includes('yükleniyor') && !firstRowText.includes('loading')) {
                            const hasCourses = !firstRowText.includes('veri yok') && !firstRowText.includes('kayıt yok');
                            return { modal, rightTable, hasCourses };
                        }
                    }
                }
            }
            await sleep(300);
            retries--;
        }
        return null;
    };

    // Tablonun ilk satırının içeriğini alarak sayfa değişimini takip etmek için kullanılır
    const getFirstRowIdentifier = () => {
        const firstRow = document.querySelector('table#dtbl tbody tr');
        return firstRow ? firstRow.innerText.trim() : '';
    };

    // Tek bir sayfadaki kullanıcıları sırayla tarayan fonksiyon
    const scrapePageUsers = async () => {
        const cols = getColumnIndexes();
        const rows = document.querySelectorAll('table#dtbl tbody tr');
        console.log(`🔍 Bu sayfada ${rows.length} satır bulundu. Tarama başlıyor...`);
        
        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            
            // Boş satırları veya "veri yok" satırını atla
            if (row.innerText.includes("veri yok") || row.cells.length < 4) {
                continue;
            }
            
            const cells = row.cells;
            
            // Bilgileri dinamik olarak al
            const name = cols.nameIdx !== -1 ? cells[cols.nameIdx].innerText.trim() : "Bilinmeyen Kullanıcı";
            const phone = cols.phoneIdx !== -1 ? cells[cols.phoneIdx].innerText.trim() : "";
            const email = cols.emailIdx !== -1 ? cells[cols.emailIdx].innerText.trim() : "";
            const role = cols.roleIdx !== -1 ? cells[cols.roleIdx].innerText.trim() : "";
            
            console.log(`👤 [Kullanıcı] ${name} (${role}) | Tel: ${phone} | E-posta: ${email} taranıyor...`);
            
            // "Dersler" butonunu bul
            const dersBtn = row.querySelector('button[onclick*="btn_meeting_modal"]') || 
                            row.querySelector('button[onclick*="meeting"]') ||
                            Array.from(row.querySelectorAll('button, a')).find(el => el.textContent.includes('Dersler'));
                            
            if (!dersBtn) {
                console.log(`   ⚠️ ${name} için 'Dersler' butonu bulunamadı, geçiliyor.`);
                continue;
            }
            
            // Butona tıkla ve modalın açılmasını bekle
            dersBtn.click();
            
            const modalData = await waitForModalAndData();
            let courses = [];
            
            if (modalData && modalData.hasCourses) {
                const courseRows = modalData.rightTable.querySelectorAll('tbody tr');
                courseRows.forEach(cRow => {
                    if (cRow.cells.length >= 2) {
                        const cName = cRow.cells[0].innerText.trim();
                        // Boş ve geçersiz satırları filtrele
                        if (cName && !cName.includes("veri yok") && !cName.includes("Satır") && !cName.toLowerCase().includes("loading")) {
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
            }
            
            console.log(`   📚 Atanan Ders Sayısı: ${courses.length}`, courses);
            
            // Kullanıcı verisini listeye ekle
            scrapedData.push({
                name: name,
                phone: phone,
                email: email,
                role: role,
                courses: courses
            });
            
            // Modalı kapat ve bir sonraki kullanıcıya geçmeden önce bekle
            closeModal();
            await sleep(400);
        }
    };

    // Tüm sayfaları gezmek için döngü (Pagination desteği)
    let hasNextPage = true;
    let pageCount = 1;
    
    while (hasNextPage) {
        console.log(`\n%c📄 --- SAYFA ${pageCount} TARANIYOR ---`, "color: #28a745; font-weight: bold; font-size: 13px;");
        await scrapePageUsers();
        
        // "Sonraki" (Next) butonunu bul
        const nextBtn = document.querySelector('li.paginate_button.next:not(.disabled) a') || 
                        document.querySelector('#dtbl_next:not(.disabled) a') || 
                        document.querySelector('#dtbl_next:not(.disabled)') ||
                        Array.from(document.querySelectorAll('a')).find(a => a.innerText.includes('Sonraki') && !a.closest('.disabled'));
                          
        if (nextBtn) {
            const currentFirstRow = getFirstRowIdentifier();
            console.log("➡️ Sonraki sayfaya geçiliyor...");
            nextBtn.click();
            pageCount++;
            
            // Sayfanın yüklenmesini bekle (İlk satırın değişip değişmediğini kontrol et)
            let pageLoaded = false;
            let pageRetries = 20; // Max 10 saniye bekle
            while (!pageLoaded && pageRetries > 0) {
                await sleep(500);
                const newFirstRow = getFirstRowIdentifier();
                if (newFirstRow !== currentFirstRow && newFirstRow !== '') {
                    pageLoaded = true;
                }
                pageRetries--;
            }
            
            if (!pageLoaded) {
                console.log("⚠️ Sayfa değişimi tespit edilemedi (timeout), 1s daha bekleniyor...");
                await sleep(1000);
            }
        } else {
            console.log("🏁 Son sayfaya ulaşıldı veya sonraki sayfa butonu aktif değil.");
            hasNextPage = false;
        }
    }

    // Sonuçları JSON olarak indir
    console.log(`\n%c🎉 Tarama Bitti! Toplam ${scrapedData.length} kullanıcı taranarak dersleri çıkartıldı.`, "color: #28a745; font-weight: bold; font-size: 15px;");
    
    const blob = new Blob([JSON.stringify(scrapedData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const downloadAnchor = document.createElement('a');
    downloadAnchor.href = url;
    downloadAnchor.download = "okinar_bireysel_dersler.json";
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    document.body.removeChild(downloadAnchor);
    URL.revokeObjectURL(url);
    
    console.log("%c💾 'okinar_bireysel_dersler.json' dosyası indirildi!", "color: #17a2b8; font-weight: bold;");
})();
