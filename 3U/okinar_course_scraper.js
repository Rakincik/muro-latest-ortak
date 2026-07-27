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

    // Tek bir sayfadaki kullanıcıları sırayla tarayan fonksiyon
    const scrapePageUsers = async () => {
        // Kullanıcılar tablosundaki satırları seç
        const rows = document.querySelectorAll('table#dtbl tbody tr');
        console.log(`🔍 Bu sayfada ${rows.length} kullanıcı satırı bulundu. Tarama başlıyor...`);
        
        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            
            // Boş satırları veya "Gösterilecek veri yok" satırını atla
            if (row.innerText.includes("veri yok") || row.cells.length < 5) {
                continue;
            }
            
            // Kullanıcı bilgilerini sütunlardan al
            const cellsText = Array.from(row.cells).map(c => c.innerText.trim());
            
            // Okinar tablosunda genellikle:
            // 5. sütun (index 4) veya 3. sütun (index 2) Ad Soyad olur.
            // Satırdaki tüm metinleri alıp benzersizleştirmek için kullanacağız.
            const name = cellsText.find(txt => txt && txt.split(' ').length >= 2 && !txt.includes('@') && isNaN(txt)) || cellsText[4] || "Bilinmeyen Kullanıcı";
            const phone = cellsText.find(txt => txt && txt.length >= 10 && !isNaN(txt.replace(/\s+/g, ''))) || "";
            const email = cellsText.find(txt => txt && txt.includes('@')) || "";
            
            console.log(`👤 [${i+1}/${rows.length}] ${name} taranıyor...`);
            
            // "Dersler" butonunu bul (btn_meeting_modal tetikleyen buton)
            const dersBtn = row.querySelector('button[onclick*="btn_meeting_modal"]');
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
        
        // "Sonraki" (Next) butonunu bul
        const nextBtn = document.querySelector('li.paginate_button.next:not(.disabled) a') || 
                          document.querySelector('#dtbl_next:not(.disabled)') || 
                          document.querySelector('a.next:not(.disabled)');
                          
        if (nextBtn && !nextBtn.closest('.disabled') && !nextBtn.classList.contains('disabled')) {
            console.log("➡️ Sonraki sayfaya geçiliyor...");
            nextBtn.click();
            pageCount++;
            await sleep(1500); // Sayfa geçişi ve tablonun yenilenmesi için bekle
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
