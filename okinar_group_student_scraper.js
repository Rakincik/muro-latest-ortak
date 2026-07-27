// =========================================================================
// OKINAR LMS - Grup Öğrenci Listesi Çekici Konsol Scripti (Çoklu Tablo & Iframe Destekli)
// =========================================================================
// Bu scripti Okinar Yönetim Panelinde "Gruplar" sayfasındayken 
// F12 -> Console sekmesine yapıştırıp çalıştırabilirsiniz.
// =========================================================================

(async () => {
    console.log("🚀 Okinar Sayfalamalı Çoklu Tablo Destekli Grup Öğrenci Tarayıcı Başlatıldı...");
    
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    
    // Tüm pencere ve iframeler içinde arama yapan genel yardımcı fonksiyon
    const queryInAllWindows = (selector, single = false, doc = document) => {
        let els = single ? doc.querySelector(selector) : Array.from(doc.querySelectorAll(selector));
        if (single) {
            if (els) return els;
        } else {
            if (els.length > 0) return els;
        }
        const iframes = doc.querySelectorAll('iframe');
        for (let i = 0; i < iframes.length; i++) {
            try {
                const iframeDoc = iframes[i].contentDocument || iframes[i].contentWindow.document;
                if (iframeDoc) {
                    const res = queryInAllWindows(selector, single, iframeDoc);
                    if (res && (single || res.length > 0)) return res;
                }
            } catch (e) {}
        }
        return single ? null : [];
    };

    // Tüm pencereler içindeki "Öğrenci" tablosunu (ad soyad / rol barındıran tabloyu) arar
    const findStudentTable = (doc = document) => {
        const tables = Array.from(doc.querySelectorAll('table'));
        for (let table of tables) {
            const headers = Array.from(table.querySelectorAll('thead th')).map(th => th.innerText.trim().toLowerCase());
            if (headers.some(h => h.includes('ad soyad') || h.includes('adı') || h.includes('soyad') || h.includes('ad_soyad') || h.includes('ad') || h.includes('isim'))) {
                return { table, headers };
            }
        }
        const iframes = doc.querySelectorAll('iframe');
        for (let i = 0; i < iframes.length; i++) {
            try {
                const iframeDoc = iframes[i].contentDocument || iframes[i].contentWindow.document;
                if (iframeDoc) {
                    const res = findStudentTable(iframeDoc);
                    if (res) return res;
                }
            } catch (e) {}
        }
        return null;
    };

    // Sol taraftaki ağaç yapısındaki tüm grup linklerini bul
    const nodes = queryInAllWindows('a.jstree-anchor, #tree a, .treeview a, ul.nav-list a, .jstree-node a');
    if (nodes.length === 0) {
        console.error("❌ Sol taraftaki grup ağacı düğmeleri bulunamadı!");
        return;
    }
    
    const allGroups = [];
    
    for (let i = 0; i < nodes.length; i++) {
        const node = nodes[i];
        const rawGroupName = node.textContent.trim();
        
        // Ana "Gruplar" kök düğümünü atla
        if (rawGroupName === "Gruplar" || rawGroupName === "Grup Düzeni" || rawGroupName === "") {
            continue;
        }
        
        console.log(`📁 [${i+1}/${nodes.length}] "${rawGroupName}" grubu seçiliyor...`);
        node.click();
        
        // Sayfanın yüklenmesi ve tablonun gelmesi için bekle
        await sleep(2000);
        
        // Mümkünse sayfa boyutunu 100 yapalım (sayfa geçişlerini azaltmak için)
        const lengthSelect = queryInAllWindows('select[name*="_length"], select.form-control', true);
        if (lengthSelect) {
            lengthSelect.value = "100";
            lengthSelect.dispatchEvent(new Event('change'));
            await sleep(2500); // Sayfa boyutunun değişmesini bekle
        }
        
        let hasNextPage = true;
        let pageCount = 1;
        const students = [];
        
        while (hasNextPage) {
            console.log(`   └─ 📄 Sayfa ${pageCount} taranıyor...`);
            
            // Öğrenci tablosunu tespit et
            const searchResult = findStudentTable(document);
            if (!searchResult) {
                console.warn("   ⚠️ Öğrenci tablosu bulunamadı, bekleniyor...");
                await sleep(1000);
                continue;
            }

            const { table, headers } = searchResult;
            const cols = {
                nameIdx: headers.findIndex(h => h.includes('ad soyad') || h.includes('adı') || h.includes('soyad') || h.includes('ad_soyad') || h.includes('ad') || h.includes('isim')),
                phoneIdx: headers.findIndex(h => h.includes('telefon') || h.includes('tel')),
                emailIdx: headers.findIndex(h => h.includes('email') || h.includes('eposta') || h.includes('mail')),
                roleIdx: headers.findIndex(h => h.includes('rol'))
            };

            // Tablodaki satırları topla
            const rows = Array.from(table.querySelectorAll('tbody tr'));
            rows.forEach(row => {
                if (row.cells.length >= 1) {
                    const name = cols.nameIdx !== -1 && row.cells[cols.nameIdx] ? row.cells[cols.nameIdx].textContent.trim() : "";
                    const phone = cols.phoneIdx !== -1 && row.cells[cols.phoneIdx] ? row.cells[cols.phoneIdx].textContent.trim() : "";
                    const email = cols.emailIdx !== -1 && row.cells[cols.emailIdx] ? row.cells[cols.emailIdx].textContent.trim() : "";
                    const role = cols.roleIdx !== -1 && row.cells[cols.roleIdx] ? row.cells[cols.roleIdx].textContent.trim() : "Öğrenci";
                    
                    const roleLower = role.toLowerCase();
                    const isStudent = roleLower.includes("öğrenci") || roleLower.includes("ogrenci") || cols.roleIdx === -1;
                    
                    // Sadece Öğrenci olanları alalım, boş satırları ve yükleniyor yazılarını atlayalım
                    if (name && isStudent && !name.includes("veri yok") && !name.toLowerCase().includes("loading")) {
                        students.push({
                            name: name,
                            phone: phone,
                            email: email
                        });
                    }
                }
            });
            
            // "Sonraki" (Next) pagination butonunu bul (Sadece bu tabloya ait olanı)
            const wrapper = table.closest('.dataTables_wrapper') || table.parentElement;
            const nextBtn = wrapper.querySelector('li.paginate_button.next:not(.disabled) a, #dtbl_next:not(.disabled), a.next:not(.disabled)') || 
                            queryInAllWindows('li.paginate_button.next:not(.disabled) a, #dtbl_next:not(.disabled), a.next:not(.disabled)', true);
            
            if (nextBtn && !nextBtn.closest('.disabled') && !nextBtn.classList.contains('disabled')) {
                const firstRow = table.querySelector('tbody tr');
                const prevRowText = firstRow ? firstRow.innerText.trim() : '';

                nextBtn.click();
                pageCount++;
                
                // Sayfa geçişinin tamamlanmasını izle
                let waitRetries = 15;
                while (waitRetries > 0) {
                    await sleep(200);
                    const currentFirstRow = table.querySelector('tbody tr');
                    const newRowText = currentFirstRow ? currentFirstRow.innerText.trim() : '';
                    if (newRowText !== prevRowText) break;
                    waitRetries--;
                }
                await sleep(500);
            } else {
                hasNextPage = false;
            }
        }
        
        // Grup adının başındaki rakamları temizle (Örn: "32 2026 VİDEO" -> "2026 VİDEO")
        const groupName = rawGroupName.replace(/^\d+\s+/, '').trim();
        
        allGroups.push({
            groupName: groupName,
            students: students
        });
        
        console.log(`   ✅ "${groupName}" grubu için toplam ${students.length} öğrenci çekildi.`);
        await sleep(1000);
    }
    
    // JSON dosyası olarak indir
    if (allGroups.length > 0) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(allGroups, null, 2));
        const downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "okinar_grup_ogrencileri.json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        console.log("🎉 Tarama tamamlandı! 'okinar_grup_ogrencileri.json' dosyası indirildi.");
    } else {
        console.warn("⚠️ Hiçbir grup verisi çekilemedi!");
    }
})();
