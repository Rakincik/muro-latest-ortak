/**
 * AKADEMİK MASA (AKM) OKINAR - Sınav, Optik Cevap Anahtarı ve Kütüphane PDF Çekici Konsol Scriptleri
 * 
 * Bu dosya iki farklı sayfada çalıştırılacak iki fonksiyon barındırır.
 */

// =================================================================================
// FONKSİYON 1: SINAVLAR VE OPTİK CEVAP ANAHTARLARINI ÇEKMEK (Sınavlar Sayfasında Çalıştırın)
// =================================================================================
async function scrapeExamsAndAnswerKeys() {
    console.log("%c🚀 AKM Sınav ve Optik Cevap Anahtarı Scraper Başlatıldı...", "color: #ff5722; font-weight: bold; font-size: 14px;");

    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    // DataTable sayfa boyutunu 1000 yap (tüm sınavları yükle)
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
    console.log(`🔍 Toplam ${rows.length} sınav satırı bulundu.`);

    if (rows.length === 0) {
        console.error("❌ Hata: Sınav satırı bulunamadı! 'Sınavlar' listesi sayfasında olduğunuzdan emin olun.");
        return;
    }

    const examsToScrape = [];
    rows.forEach(row => {
        const cells = row.cells;
        if (!cells || cells.length < 5) return;

        const examName = cells[3]?.innerText.trim();
        const categoryId = cells[2]?.innerText.trim();
        const description = cells[4]?.innerText.trim();

        const sorularBtn = Array.from(row.querySelectorAll('a, button, [onclick]')).find(el => 
            el.textContent.includes('Sorular') || el.getAttribute('onclick')?.includes('questions')
        );

        let url = null;
        if (sorularBtn) {
            let href = sorularBtn.getAttribute('href') || '';
            let onclick = sorularBtn.getAttribute('onclick') || '';
            
            if (href && href !== '#' && !href.startsWith('javascript:')) {
                url = href.startsWith('http') ? href : `${window.location.origin}${href}`;
            } else if (onclick) {
                const match = onclick.match(/location\.href\s*=\s*['"]([^'"]+)['"]/);
                if (match) {
                    url = `${window.location.origin}${match[1]}`;
                } else {
                    const pathMatch = onclick.match(/['"]([^'"]*questions[^'"]*)['"]/);
                    if (pathMatch) {
                        url = `${window.location.origin}${pathMatch[1]}`;
                    }
                }
            }
        }

        if (examName && url) {
            examsToScrape.push({
                name: examName,
                categoryId: categoryId,
                description: description,
                url: url
            });
        }
    });

    console.log(`📥 Toplam ${examsToScrape.length} sınavın cevap anahtarı taranacak. İframe hazırlanıyor...`);
    
    // Geçici iframe oluştur
    let iframe = document.getElementById('akmScraperIframe');
    if (iframe) iframe.remove();
    iframe = document.createElement('iframe');
    iframe.id = 'akmScraperIframe';
    iframe.style.position = 'fixed';
    iframe.style.bottom = '10px';
    iframe.style.right = '10px';
    iframe.style.width = '800px';
    iframe.style.height = '600px';
    iframe.style.zIndex = '99999';
    iframe.style.border = '3px solid #ff5722';
    iframe.style.background = '#fff';
    document.body.appendChild(iframe);

    const results = [];
    let idx = 0;

    for (const exam of examsToScrape) {
        idx++;
        console.log(`[${idx}/${examsToScrape.length}] 📝 Sınav taranıyor: ${exam.name}`);
        
        iframe.src = exam.url;

        // Sayfa yüklenmesini bekle (Maksimum 10 sn)
        let loaded = false;
        for (let t = 0; t < 20; t++) {
            await sleep(500);
            try {
                const doc = iframe.contentDocument || iframe.contentWindow.document;
                if (doc && doc.readyState === 'complete' && doc.querySelector('table')) {
                    loaded = true;
                    break;
                }
            } catch (e) {}
        }

        if (!loaded) {
            console.warn(`   ⚠️ Yükleme zaman aşımı veya erişim hatası: ${exam.name}`);
            continue;
        }

        await sleep(1000); // Stabilizasyon beklemesi

        try {
            const innerWin = iframe.contentWindow;
            const innerDoc = iframe.contentDocument || innerWin.document;

            // İframe içindeki DataTable'ı 1000 yap (bütün sorular tek sayfada gelsin)
            if (innerWin.$ && innerWin.$.fn.DataTable) {
                try {
                    innerWin.$('#dtbl').DataTable().page.len(1000).draw();
                    await sleep(1500);
                } catch (e) {}
            }

            const qRows = Array.from(innerDoc.querySelectorAll('table tbody tr'));
            const answerKey = {};
            let maxQuestion = 0;

            qRows.forEach(qRow => {
                const qCells = qRow.cells;
                if (qCells && qCells.length >= 4) {
                    const qNoStr = qCells[2].innerText.trim();
                    const answer = qCells[3].innerText.trim().toUpperCase();
                    
                    const qNo = parseInt(qNoStr);
                    if (!isNaN(qNo) && answer) {
                        answerKey[qNo.toString()] = answer;
                        if (qNo > maxQuestion) maxQuestion = qNo;
                    }
                }
            });

            console.log(`   └─ ✅ Eşleşti: ${maxQuestion} soru / Cevap anahtarı hazır.`);
            results.push({
                examName: exam.name,
                categoryId: exam.categoryId,
                description: exam.description,
                questionCount: maxQuestion,
                answerKey: answerKey
            });

        } catch (err) {
            console.error(`   ❌ Hata (${exam.name}):`, err);
        }
        
        await sleep(500);
    }

    iframe.remove();
    console.log("🎉 Tarama bitti! Dosya indiriliyor...");

    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(results, null, 2));
    const dlAnchor = document.createElement('a');
    dlAnchor.setAttribute("href", dataStr);
    dlAnchor.setAttribute("download", "akm_exams_with_answers.json");
    document.body.appendChild(dlAnchor);
    dlAnchor.click();
    dlAnchor.remove();
}

// =================================================================================
// FONKSİYON 2: KÜTÜPHANE PDF LİNKLERİNİ ÇEKMEK (Kütüphane Sayfasında Çalıştırın)
// =================================================================================
async function scrapeLibraryPDFs() {
    console.log("%c🚀 AKM Kütüphane PDF Scraper Başlatıldı...", "color: #00bcd4; font-weight: bold; font-size: 14px;");
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    if (typeof $ !== 'undefined' && $.fn.DataTable && $.fn.DataTable.isDataTable('#dtbl')) {
        try {
            console.log("📊 DataTable sayfa boyutu 1000 yapılıyor...");
            $('#dtbl').DataTable().page.len(1000).draw();
            await sleep(2000);
        } catch (e) {}
    }

    const rows = Array.from(document.querySelectorAll('table#dtbl tbody tr, table.table tbody tr'));
    console.log(`🔍 Kütüphanede ${rows.length} dosya satırı bulundu.`);

    const pdfList = [];
    rows.forEach(row => {
        const cells = row.cells;
        if (!cells || cells.length < 2) return;

        const dateStr = cells[0].innerText.trim();
        const fileLink = cells[1].querySelector('a');
        
        if (fileLink) {
            const fileName = fileLink.innerText.trim();
            const href = fileLink.getAttribute('href') || '';
            const downloadUrl = href.startsWith('http') ? href : `${window.location.origin}${href}`;
            
            pdfList.push({
                title: fileName,
                date: dateStr,
                downloadUrl: downloadUrl
            });
        }
    });

    console.log(`✅ ${pdfList.length} adet PDF dökümanı listelendi. İndiriliyor...`);
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(pdfList, null, 2));
    const dlAnchor = document.createElement('a');
    dlAnchor.setAttribute("href", dataStr);
    dlAnchor.setAttribute("download", "akm_library_pdfs.json");
    document.body.appendChild(dlAnchor);
    dlAnchor.click();
    dlAnchor.remove();
}
