(async () => {
    console.log("%c🚀 Okinar Ders İsimleri Hızlı Eşleştirici Başlatıldı...", "color: #00ff00; font-size: 16px; font-weight: bold;");
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    
    const results = [];
    let hasNextPage = true;
    let pageNum = 1;

    // Sonraki Sayfa butonunu bulur
    const findNextButton = (doc) => {
        if (!doc) return null;
        return doc.querySelector('li.paginate_button.next:not(.disabled) a') || 
               doc.querySelector('#dtbl_next:not(.disabled)') || 
               doc.querySelector('a.next:not(.disabled)') ||
               Array.from(doc.querySelectorAll('a, button')).find(el => {
                   const text = el.innerText.trim().toLowerCase();
                   return (text === 'sonraki' || text === 'next' || text === '›' || text === '>>') && !el.closest('.disabled') && !el.classList.contains('disabled');
               });
    };

    while (hasNextPage) {
        console.log(`\n%c📄 --- SAYFA ${pageNum} TARANIYOR ---`, "color: #007bff; font-weight: bold;");
        
        // Tablodaki satırları bul
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        
        if (rows.length === 0 || (rows.length === 1 && rows[0].innerText.includes('veri yok'))) {
            console.warn(`⚠️ Sayfa ${pageNum} üzerinde tablo bulunamadı.`);
            hasNextPage = false;
            break;
        }

        rows.forEach(row => {
            // İkinci sütun Ders adı
            const tdElements = row.querySelectorAll('td');
            if (tdElements.length >= 2) {
                let courseName = tdElements[1].innerText.trim().split('\n')[0];
                
                // Kayıtlar butonunu bul
                const kayitBtn = Array.from(row.querySelectorAll('a, button, [onclick]')).find(btn => {
                    const txt = btn.innerText.toLowerCase();
                    return txt.includes('kayıt') || txt.includes('kayit') || txt.includes('record');
                });

                let link = "";
                if (kayitBtn) {
                    const href = kayitBtn.getAttribute('href') || '';
                    const onclick = kayitBtn.getAttribute('onclick') || '';
                    if (onclick && onclick.includes('recordings(')) {
                        const match = onclick.match(/recordings\(['"]([^'"]+)['"]\)/);
                        if (match) link = `/classroom/video/${match[1]}`;
                    } else if (href && href.includes('/classroom/video/')) {
                        link = href;
                    }
                }
                
                if (link && !link.startsWith('http')) {
                    link = window.location.origin + link;
                }

                if (courseName && link) {
                    results.push({
                        courseName: courseName,
                        classroomLink: link
                    });
                }
            }
        });

        // Sonraki sayfaya geçiş
        const nextBtn = findNextButton(document);
        if (nextBtn) {
            nextBtn.click();
            pageNum++;
            await sleep(1500); // Sadece tablo yüklenmesi için 1.5 saniye bekle (iframe beklemesi yok!)
        } else {
            hasNextPage = false;
        }
    }

    // Dosyayı indir
    const blob = new Blob([JSON.stringify(results, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `akm_isim_eslestirme.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    console.log("%c🎉 İSİM EŞLEŞTİRME BAŞARIYLA TAMAMLANDI!", "color: #00ff00; font-size: 18px; font-weight: bold;");
    console.log("Bulunan Ders Sayısı:", results.length);
})();
