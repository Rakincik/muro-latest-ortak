// =========================================================================================
// OKINAR LMS - Grup Hiyerarşisi, Tanımlı Dersler ve Öğrenci Listesi Scraper Scripti
// =========================================================================================
// Bu scripti Okinar Yönetim Panelinde "Gruplar" sayfasındayken 
// F12 -> Console sekmesine yapıştırıp çalıştırabilirsiniz.
// =========================================================================================

(async () => {
    console.log("%c🚀 Okinar Grup Hiyerarşisi & Ders Eşleşmeleri Tarayıcı Başlatıldı...", "color: #00ff00; font-size: 16px; font-weight: bold;");
    
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

    // Jstree düğümünün üst hiyerarşi zincirini bulur
    const getParentChain = (anchor) => {
        let chain = [];
        let current = anchor.closest('li.jstree-node');
        while (current) {
            let parentLi = current.parentElement.closest('li.jstree-node');
            if (parentLi) {
                let parentAnchor = parentLi.querySelector(':scope > a.jstree-anchor');
                if (parentAnchor) {
                    let parentName = parentAnchor.textContent.trim().replace(/^\d+\s+/, '').trim();
                    if (parentName && parentName !== "Gruplar" && parentName !== "Grup Düzeni") {
                        chain.unshift(parentName);
                    }
                }
            }
            current = parentLi;
        }
        return chain;
    };

    // Belirli bir tablo içindeki satır verilerini çeker
    const scrapeTableData = async (tabSelector, isStudentTable) => {
        const tabPane = queryInAllWindows(tabSelector, true);
        if (!tabPane) {
            console.warn(`⚠️ ${tabSelector} sekme paneli bulunamadı.`);
            return [];
        }

        const table = tabPane.querySelector('table');
        if (!table) {
            return [];
        }

        // Sayfa boyutunu 100 yapalım (sayfa geçişlerini azaltmak için)
        const lengthSelect = tabPane.querySelector('select[name*="_length"], select.form-control');
        if (lengthSelect && lengthSelect.value !== "100") {
            lengthSelect.value = "100";
            lengthSelect.dispatchEvent(new Event('change'));
            await sleep(1500); // Sayfa boyutunun değişmesini bekle
        }

        // ⏳ TABLONUN YÜKLENMESİNİ BEKLE (AJAX YÜKLEMESİ İÇİN KRİTİK)
        let loaded = false;
        for (let attempt = 0; attempt < 25; attempt++) {
            const firstRow = table.querySelector('tbody tr');
            if (firstRow) {
                const text = firstRow.innerText.toLowerCase();
                // Veri yoksa veya yükleme bittiyse beklemeden çık
                if (text.includes("veri yok") || text.includes("no data available") || text.includes("eşleşen kayıt bulunamadı")) {
                    loaded = true;
                    break;
                }
                if (!text.includes("yükleniyor") && !text.includes("loading") && !text.includes("processing") && text.trim() !== "") {
                    loaded = true;
                    break;
                }
            }
            await sleep(250);
        }

        const headers = Array.from(table.querySelectorAll('thead th')).map(th => th.innerText.trim().toLowerCase());
        
        let cols = {};
        if (isStudentTable) {
            cols = {
                nameIdx: headers.findIndex(h => h.includes('ad soyad') || h.includes('adı') || h.includes('soyad') || h.includes('ad') || h.includes('isim')),
                phoneIdx: headers.findIndex(h => h.includes('telefon') || h.includes('tel')),
                emailIdx: headers.findIndex(h => h.includes('email') || h.includes('eposta') || h.includes('mail')),
            };
            
            // AKILLI EŞLEŞME FALLBACKS
            if (cols.nameIdx === -1) {
                cols.nameIdx = 4; // Genellikle 5. kolon isimdir
                console.log("   [i] Ad Soyad kolonu varsayılan olarak 4 seçildi.");
            }
            if (cols.phoneIdx === -1) {
                cols.phoneIdx = 5; // Genellikle 6. kolon telefondur
            }
        } else {
            cols = {
                nameIdx: headers.findIndex(h => h.includes('ders') || h.includes('name') || h.includes('başlık')),
                modeIdx: headers.findIndex(h => h.includes('mod') || h.includes('tip') || h.includes('durum'))
            };
            if (cols.nameIdx === -1) cols.nameIdx = 1;
            if (cols.modeIdx === -1) cols.modeIdx = 2;
        }

        let hasNextPage = true;
        let pageCount = 1;
        const items = [];

        while (hasNextPage) {
            const rows = Array.from(table.querySelectorAll('tbody tr'));
            rows.forEach(row => {
                if (row.cells.length >= Math.max(cols.nameIdx + 1, 2)) {
                    const name = row.cells[cols.nameIdx] ? row.cells[cols.nameIdx].innerText.trim() : "";
                    
                    if (name && !name.includes("veri yok") && !name.toLowerCase().includes("loading") && !name.includes("Satır")) {
                        if (isStudentTable) {
                            let phone = row.cells[cols.phoneIdx] ? row.cells[cols.phoneIdx].innerText.trim() : "";
                            
                            // Akıllı Telefon Bulucu (Eğer kolondan okunamadıysa)
                            if (!phone || phone.replace(/\D/g, '').length < 10) {
                                const phoneCell = Array.from(row.cells).find(cell => {
                                    const digits = cell.innerText.replace(/\D/g, '');
                                    return digits.length === 10 && digits.startsWith('5');
                                });
                                if (phoneCell) phone = phoneCell.innerText.trim();
                            }

                            // Akıllı E-posta Bulucu (İçinde @ geçen ilk hücreyi veya mailto linkini al)
                            let email = "";
                            const emailCell = Array.from(row.cells).find(cell => cell.innerText.includes('@'));
                            if (emailCell) {
                                email = emailCell.innerText.trim();
                            } else {
                                const mailLink = row.querySelector('a[href^="mailto:"]');
                                if (mailLink) {
                                    email = mailLink.getAttribute('href').replace('mailto:', '').trim();
                                }
                            }

                            items.push({ name, phone, email });
                        } else {
                            const mode = row.cells[cols.modeIdx] ? row.cells[cols.modeIdx].innerText.trim() : "";
                            items.push({ courseName: name, mode: mode });
                        }
                    }
                }
            });

            // Sonraki sayfa butonunu bul
            const nextBtn = tabPane.querySelector('li.paginate_button.next:not(.disabled) a, #dtbl_next:not(.disabled), a.next:not(.disabled)');
            if (nextBtn && !nextBtn.closest('.disabled') && !nextBtn.classList.contains('disabled')) {
                const firstRow = table.querySelector('tbody tr');
                const prevRowText = firstRow ? firstRow.innerText.trim() : '';

                nextBtn.click();
                pageCount++;
                
                // Sayfa geçişini bekle
                let waitRetries = 15;
                while (waitRetries > 0) {
                    await sleep(200);
                    const currentFirstRow = table.querySelector('tbody tr');
                    const newRowText = currentFirstRow ? currentFirstRow.innerText.trim() : '';
                    if (newRowText !== prevRowText) break;
                    waitRetries--;
                }
                await sleep(300);
            } else {
                hasNextPage = false;
            }
        }
        return items;
    };

    // Sol taraftaki jstree düğümlerini bul
    const nodes = queryInAllWindows('a.jstree-anchor, #tree a, .treeview a, ul.nav-list a, .jstree-node a');
    if (nodes.length === 0) {
        console.error("❌ Sol taraftaki grup ağacı düğmeleri bulunamadı!");
        return;
    }
    
    console.log(`🔍 Toplam ${nodes.length} adet ağaç düğümü bulundu. Analiz başlıyor...`);
    const scrapedGroups = [];
    
    for (let i = 0; i < nodes.length; i++) {
        const node = nodes[i];
        const rawGroupName = node.textContent.trim();
        
        // Kök düğümleri atla
        if (rawGroupName === "Gruplar" || rawGroupName === "Grup Düzeni" || rawGroupName === "") {
            continue;
        }
        
        const parentChain = getParentChain(node);
        const groupName = rawGroupName.replace(/^\d+\s+/, '').trim();
        
        console.log(`------------------------------------------------------------`);
        console.log(`📁 [${i+1}/${nodes.length}] Düğüm: "${groupName}" seçiliyor...`);
        if (parentChain.length > 0) {
            console.log(`   └─ Hiyerarşi Yolu: ${parentChain.join(' -> ')} -> ${groupName}`);
        }
        
        // Gruba tıkla
        node.click();
        await sleep(2000); // Sağ tarafın dolmasını bekle

        // 1. Grup Dersleri Sekmesini Seç ve Dersleri Oku
        let courses = [];
        const tab3Btn = queryInAllWindows('a[href="#tab_3"]', true);
        if (tab3Btn) {
            tab3Btn.click();
            await sleep(600);
            courses = await scrapeTableData('#tab_3', false);
            console.log(`   📚 Atanmış Ders Sayısı: ${courses.length}`);
        }

        // 2. Grup Kullanıcıları Sekmesini Seç ve Öğrencileri Oku
        let students = [];
        const tab4Btn = queryInAllWindows('a[href="#tab_4"]', true);
        if (tab4Btn) {
            tab4Btn.click();
            await sleep(600);
            students = await scrapeTableData('#tab_4', true);
            console.log(`   👤 Öğrenci Sayısı: ${students.length}`);
        }

        scrapedGroups.push({
            groupName: groupName,
            parentChain: parentChain,
            courses: courses,
            students: students
        });
        
        await sleep(1000);
    }
    
    // JSON dosyası olarak indir
    if (scrapedGroups.length > 0) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(scrapedGroups, null, 2));
        const downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "okinar_grup_hiyerarsi_ve_dersler.json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        console.log("============================================================");
        console.log("🎉 Tarama tamamlandı! 'okinar_grup_hiyerarsi_ve_dersler.json' indirildi.");
        console.log(`   - Toplam taranan grup sayısı: ${scrapedGroups.length}`);
    } else {
        console.warn("⚠️ Hiçbir grup verisi çekilemedi!");
    }
})();
