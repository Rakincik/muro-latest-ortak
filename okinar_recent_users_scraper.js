// =========================================================================
// OKINAR LMS - 28.06 Sonrası Kaydolanlar, Gruplar ve Tek Dersler Çekici Betik
// =========================================================================
// Bu betiği Okinar Yönetim Panelinde "Kullanıcılar" sayfasındayken 
// F12 -> Console sekmesine yapıştırıp çalıştırabilirsiniz.
// =========================================================================

(async () => {
    console.log("🚀 Okinar Güncel Kullanıcı ve Atama Tarayıcı Başlatıldı...");
    
    let scrapedData = [];
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    
    // Sınır Tarihi: 28.06.2026
    const limitDate = new Date(2026, 5, 28); 
    let reachedLimit = false;

    // Aktif / Açık olan modalı bulur
    const getActiveModal = () => {
        return Array.from(document.querySelectorAll('.modal')).find(modal => {
            const style = window.getComputedStyle(modal);
            return modal.classList.contains('show') || (style.display !== 'none' && style.visibility !== 'hidden');
        });
    };

    // Modalın yüklenmesini bekler
    const waitForModalToOpen = async (maxAttempts = 15) => {
        for (let attempt = 0; attempt < maxAttempts; attempt++) {
            await sleep(300);
            const modal = getActiveModal();
            if (modal) {
                const body = modal.querySelector('.modal-body');
                if (body && !body.innerText.includes("yükleniyor") && !body.innerText.toLowerCase().includes("loading")) {
                    return modal;
                }
            }
        }
        return getActiveModal();
    };

    // Modalı kapatır
    const closeModal = (modal) => {
        if (!modal) return;
        try {
            if (typeof $ !== 'undefined' && $(modal).modal) {
                $(modal).modal('hide');
            } else {
                const closeBtn = modal.querySelector('.close') || 
                                 modal.querySelector('[data-dismiss="modal"]') ||
                                 modal.querySelector('[data-bs-dismiss="modal"]') ||
                                 Array.from(modal.querySelectorAll('button, a')).find(btn => {
                                     const text = btn.innerText.trim();
                                     return text === '×' || text.includes('Vazgeç') || text.includes('Kapat') || text.includes('İptal');
                                 });
                if (closeBtn) closeBtn.click();
            }
        } catch (e) {
            console.error("Modal kapatılamadı:", e);
        }
    };

    // Modal içinden grupları çeker
    const parseGroupsFromModal = (modal) => {
        let groups = [];
        if (!modal) return groups;

        // 1. Durum: "Kayıtlı Gruplar" başlığının altındaki (#users_groups) butonlar
        const headings = Array.from(modal.querySelectorAll('h1, h2, h3, h4, h5, h6, label, p, span, div')).filter(el => {
            if (el.querySelector('h1, h2, h3, h4, h5, h6, label, div, p')) {
                return false;
            }
            const t = el.innerText.trim();
            return t === 'Kayıtlı Gruplar' || t.startsWith('Kayıtlı Gruplar');
        });

        if (headings.length > 0) {
            const heading = headings[0];
            const container = heading.parentElement.querySelector('#users_groups') || heading.nextElementSibling;
            if (container) {
                const buttons = container.querySelectorAll('button, .btn, span');
                buttons.forEach(b => {
                    const text = b.innerText.trim();
                    if (text && text.length > 2 && text !== 'Aktifleştir' && text !== 'Dondur' && text !== 'Aktif' && text !== 'Pasif' && text !== 'Aktifleşti' && text !== 'Donduruldu') {
                        if (!groups.includes(text)) {
                            groups.push(text);
                        }
                    }
                });
            }
        }

        // 2. Durum: Eğer üstteki yöntemle bulunamazsa, "Dondur" butonlarının yanındaki grup adlarını bul (Yedek)
        if (groups.length === 0) {
            const dondurBtns = Array.from(modal.querySelectorAll('button, a, span')).filter(el => el.innerText.trim() === 'Dondur');
            dondurBtns.forEach(btn => {
                const parent = btn.closest('div, li, td, tr');
                if (parent) {
                    const buttons = parent.querySelectorAll('button, .btn, span, a');
                    buttons.forEach(b => {
                        const text = b.innerText.trim();
                        if (text && text.length > 2 && text !== 'Aktifleştir' && text !== 'Dondur' && text !== 'Aktif' && text !== 'Pasif' && text !== 'Aktifleşti' && text !== 'Donduruldu' && text !== 'Ekle' && text !== 'Çıkar' && text !== 'Vazgeç') {
                            if (!groups.includes(text)) {
                                groups.push(text);
                            }
                        }
                    });
                }
            });
        }

        // 2. Durum: Eğer üstteki yöntemle bulunamazsa, yeşil renkli öğeleri filtrele (Yedek)
        if (groups.length === 0) {
            const greenElements = Array.from(modal.querySelectorAll('.btn-success, .badge-success, .label-success, [class*="success"], [class*="green"], .btn, badge, span, a')).filter(el => {
                const text = el.innerText.trim();
                if (text === 'Aktifleştir' || text === 'Dondur' || text === 'Aktif' || text === 'Pasif' || text === 'Kapat' || text === 'Vazgeç') {
                    return false;
                }
                const className = el.className.toLowerCase();
                if (className.includes('success') || className.includes('green')) {
                    return true;
                }
                try {
                    const style = window.getComputedStyle(el);
                    const bg = style.backgroundColor;
                    if (bg.includes('rgb') || bg.includes('rgba')) {
                        const match = bg.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
                        if (match) {
                            const r = parseInt(match[1]);
                            const g = parseInt(match[2]);
                            const b = parseInt(match[3]);
                            if (g > 120 && g > r && g > b) return true;
                        }
                    }
                } catch (e) {}
                return false;
            });

            greenElements.forEach(el => {
                const name = el.innerText.trim();
                if (name && name.length > 2 && !groups.includes(name)) {
                    groups.push(name);
                }
            });
        }

        // 3. Durum: Checkbox listesi ise
        if (groups.length === 0) {
            const checkedBoxes = modal.querySelectorAll('input[type="checkbox"]:checked');
            if (checkedBoxes.length > 0) {
                checkedBoxes.forEach(cb => {
                    let name = "";
                    if (cb.id) {
                        const label = modal.querySelector(`label[for="${cb.id}"]`);
                        if (label) name = label.innerText.trim();
                    }
                    if (!name) {
                        const container = cb.closest('div.form-check, label, li, tr');
                        if (container) {
                            const clone = container.cloneNode(true);
                            const inp = clone.querySelector('input');
                            if (inp) inp.remove();
                            name = clone.innerText.trim();
                        }
                    }
                    if (name && !groups.includes(name)) {
                        groups.push(name);
                    }
                });
            }
        }

        // 4. Durum: Tablo listesi ise
        if (groups.length === 0) {
            const tables = modal.querySelectorAll('table');
            if (tables.length > 0) {
                tables.forEach(t => {
                    const headers = Array.from(t.querySelectorAll('thead th')).map(th => th.innerText.toLowerCase().trim());
                    if (!headers.includes('ders') && !headers.includes('on/off')) {
                        const rows = t.querySelectorAll('tbody tr');
                        rows.forEach(row => {
                            const text = row.innerText.trim();
                            if (text && !text.includes("veri yok") && !text.includes("yükleniyor") && !text.toLowerCase().includes("loading")) {
                                const name = row.cells[0] ? row.cells[0].innerText.trim() : text;
                                if (name && !groups.includes(name)) {
                                    groups.push(name);
                                }
                            }
                        });
                    }
                });
            }
        }

        return groups.map(g => g.replace(/^\d+\s+/, '').trim());
    };

    // Modal içinden tek dersleri çeker
    const parseCoursesFromModal = (modal) => {
        const courses = [];
        if (!modal) return courses;

        const tables = Array.from(modal.querySelectorAll('table'));
        let targetTable = null;

        for (const t of tables) {
            const headers = Array.from(t.querySelectorAll('thead th')).map(th => th.innerText.toLowerCase().trim());
            if (headers.some(h => h.includes('ders') || h.includes('on/off') || h.includes('durum') || h.includes('stat'))) {
                targetTable = t;
                break;
            }
        }

        if (!targetTable && tables.length > 0) {
            targetTable = tables[tables.length - 1];
        }

        if (targetTable) {
            const rows = targetTable.querySelectorAll('tbody tr');
            rows.forEach(r => {
                if (r.cells.length >= 1) {
                    const cName = r.cells[0].innerText.trim();
                    if (cName && !cName.includes("veri yok") && !cName.includes("Satır") && !cName.includes("yükleniyor") && !cName.toLowerCase().includes("loading")) {
                        const statusCellText = r.cells[1] ? r.cells[1].innerText.trim().toUpperCase() : "";
                        const isOnline = statusCellText.includes("ON") || r.innerHTML.includes("checked");
                        courses.push({
                            courseName: cName,
                            status: isOnline ? "online" : "offline"
                        });
                    }
                }
            });
        }
        return courses;
    };

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

    const parseDateStr = (str) => {
        if (!str) return null;
        if (str.includes('.')) {
            const parts = str.split(' ')[0].split('.');
            if (parts.length === 3) return new Date(parts[2], parts[1] - 1, parts[0]);
        }
        if (str.includes('-')) {
            const parts = str.split(' ')[0].split('-');
            if (parts.length === 3) return new Date(parts[0], parts[1] - 1, parts[2]);
        }
        return null;
    };

    const findMainTable = () => {
        let table = document.querySelector('table#dtbl');
        if (table) return table;
        
        const tables = Array.from(document.querySelectorAll('table'));
        for (const t of tables) {
            const headers = Array.from(t.querySelectorAll('thead th')).map(th => cleanStr(th.innerText));
            if (headers.some(h => h.includes('ad soyad') || h.includes('adi') || h.includes('soyad') || h.includes('isim'))) {
                return t;
            }
        }
        return null;
    };

    const scrapePageUsers = async () => {
        const mainTable = findMainTable();
        if (!mainTable) {
            console.error("❌ Ana kullanıcı tablosu bulunamadı!");
            return;
        }

        const headers = Array.from(mainTable.querySelectorAll('thead th')).map(th => cleanStr(th.innerText));
        const cols = {
            nameIdx: headers.findIndex(h => h.includes('ad soyad') || h.includes('adi') || h.includes('soyad') || h.includes('isim')),
            phoneIdx: headers.findIndex(h => h.includes('telefon') || h.includes('tel')),
            emailIdx: headers.findIndex(h => h.includes('email') || h.includes('eposta') || h.includes('mail')),
            dateIdx: headers.findIndex(h => h.includes('tarih') || h.includes('kayit')),
            updateIdx: headers.findIndex(h => h.includes('guncelleme') || h.includes('guncel') || h.includes('duzenleme'))
        };

        const rows = mainTable.querySelectorAll('tbody tr');
        console.log(`🔍 Sayfada ${rows.length} satır bulundu. İnceleme başlıyor...`);

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            
            if (row.innerText.includes("veri yok") || row.cells.length < 4) {
                continue;
            }

            const name = cols.nameIdx !== -1 && row.cells[cols.nameIdx] ? row.cells[cols.nameIdx].innerText.trim() : "Bilinmeyen Kullanıcı";
            const phone = cols.phoneIdx !== -1 && row.cells[cols.phoneIdx] ? row.cells[cols.phoneIdx].innerText.trim() : "";
            const email = cols.emailIdx !== -1 && row.cells[cols.emailIdx] ? row.cells[cols.emailIdx].innerText.trim() : "";
            
            const dateText = cols.dateIdx !== -1 && row.cells[cols.dateIdx] ? row.cells[cols.dateIdx].innerText.trim() : "";
            const regDate = parseDateStr(dateText);

            const updateText = cols.updateIdx !== -1 && row.cells[cols.updateIdx] ? row.cells[cols.updateIdx].innerText.trim() : "";
            const updateDate = parseDateStr(updateText);

            const maxDate = (regDate && updateDate) ? (regDate > updateDate ? regDate : updateDate) : (regDate || updateDate);

            if (maxDate && maxDate < limitDate) {
                console.log(`🛑 Sınır Tarihine Ulaşıldı! Tarih: ${dateText || updateText} (< 28.06.2026). Tarama bu noktada durduruluyor.`);
                reachedLimit = true;
                break;
            }

            console.log(`👤 [${i+1}/${rows.length}] ${name} taranıyor...`);

            // 1. GRUPLARI SCRAPE ET
            const groupBtn = row.querySelector('button[onclick*="group"]') || 
                             row.querySelector('button[onclick*="grup"]') ||
                             row.querySelector('a[onclick*="group"]') ||
                             row.querySelector('a[onclick*="grup"]') ||
                             Array.from(row.querySelectorAll('button, a')).find(el => {
                                 const t = el.innerText.trim();
                                 const o = el.getAttribute('onclick') || '';
                                 return t.includes('Grup') || t.includes('grup') || o.includes('group') || o.includes('grup');
                             });

            let userGroups = [];
            if (groupBtn) {
                groupBtn.click();
                const modal = await waitForModalToOpen();
                if (modal) {
                    userGroups = parseGroupsFromModal(modal);
                    closeModal(modal);
                    await sleep(400); // Kapanma animasyonunu bekle
                }
            } else {
                console.warn(`   ⚠️ ${name} için Gruplar butonu bulunamadı.`);
            }

            scrapedData.push({
                name: name,
                phone: phone,
                email: email,
                registrationDate: dateText,
                updateDate: updateText,
                groups: userGroups
            });

            console.log(`   └─ Gruplar: ${JSON.stringify(userGroups)}`);
            await sleep(200);
        }
    };

    // Sayfalama döngüsü
    let hasNextPage = true;
    let pageCount = 1;

    while (hasNextPage) {
        console.log(`\n📄 --- YENİ SAYFA BAŞLADI (Sayfa: ${pageCount}) ---`);
        await scrapePageUsers();

        if (reachedLimit) {
            break;
        }

        const nextBtn = document.querySelector('li.paginate_button.next:not(.disabled) a') || 
                        document.querySelector('#dtbl_next:not(.disabled)') || 
                        document.querySelector('a.next:not(.disabled)');
                          
        if (nextBtn && !nextBtn.closest('.disabled') && !nextBtn.classList.contains('disabled')) {
            console.log("➡️ Sonraki sayfaya geçiliyor...");
            const mainTable = findMainTable();
            const firstRow = mainTable ? mainTable.querySelector('tbody tr') : null;
            const prevRowText = firstRow ? firstRow.innerText.trim() : '';

            nextBtn.click();
            pageCount++;
            
            // Yeni sayfanın yüklenmesini bekle
            let waitRetries = 25;
            while (waitRetries > 0) {
                await sleep(300);
                const currentMainTable = findMainTable();
                const currentFirstRow = currentMainTable ? currentMainTable.querySelector('tbody tr') : null;
                const newRowText = currentFirstRow ? currentFirstRow.innerText.trim() : '';
                if (newRowText !== prevRowText && !newRowText.includes('yükleniyor') && !newRowText.toLowerCase().includes('loading')) {
                    break;
                }
                waitRetries--;
            }
            await sleep(500);
        } else {
            console.log("🏁 Son sayfaya ulaşıldı.");
            hasNextPage = false;
        }
    }

    // JSON indir
    console.log(`\n🎉 Tarama Tamamlandı! Toplam ${scrapedData.length} güncel kullanıcı bilgisi ve ataması çekildi.`);
    
    if (scrapedData.length > 0) {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(scrapedData, null, 2));
        const downloadAnchor = document.createElement('a');
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", "okinar_recent_users.json");
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        console.log("💾 'okinar_recent_users.json' dosyası başarıyla indirildi.");
    } else {
        console.warn("⚠️ Filtreye uyan hiçbir yeni kullanıcı kaydı bulunamadı.");
    }
})();
