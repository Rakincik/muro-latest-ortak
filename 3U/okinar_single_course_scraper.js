// =========================================================================================
// OKINAR LMS - Tek Dersin Playlist Kayıtlarını Çekici Konsol Scripti
// =========================================================================================
// Bu scripti Okinar Video Oynatıcı sayfasındayken (sağ tarafta ders listesinin olduğu yer)
// F12 -> Console sekmesine yapıştırıp çalıştırabilirsiniz.
// =========================================================================================

(() => {
    console.log("%c🚀 Okinar Tek Ders Playlist Tarayıcı Başlatıldı...", "color: #00ff00; font-size: 16px; font-weight: bold;");
    
    // Ders adını sayfadaki başlıktan veya başlık etiketlerinden çekelim
    let courseName = "";
    const headerCandidates = [
        document.querySelector('h3.card-title'),
        document.querySelector('h1, h2, h3, h4'),
        document.querySelector('.page-header'),
        document.querySelector('.title'),
        document.querySelector('.breadcrumb .active')
    ];
    for (let el of headerCandidates) {
        if (el && el.innerText.trim().length > 3) {
            courseName = el.innerText.trim();
            break;
        }
    }
    if (!courseName) {
        courseName = prompt("Lütfen dersin adını girin (Örn: YENİ NESİL İKTİSAT KAMPI 2025):") || document.title;
    }
    
    // Temizleme işlemi
    courseName = courseName.replace(/Ders Kayıtları/gi, '').replace(/Ders Listesi/gi, '').trim();

    console.log(`📚 Ders Adı: "${courseName}"`);

    const bbbFolderRegex = /[a-f0-9]{40}-\d{13}/i;
    const recordings = [];

    // Sağ taraftaki çalma listesi elemanlarını bul
    // Genellikle a, li, tr, veya div'lerden oluşur
    const allElements = Array.from(document.querySelectorAll('a, li, tr, [onclick], div, span, button'));
    const seenIDs = new Set();

    allElements.forEach(el => {
        const text = el.innerText.trim();
        const href = el.getAttribute('href') || '';
        const onclick = el.getAttribute('onclick') || '';
        const combinedAttr = href + " " + onclick + " " + el.outerHTML;

        const match = combinedAttr.match(bbbFolderRegex);
        if (match) {
            const recordID = match[0].trim();
            if (!seenIDs.has(recordID)) {
                seenIDs.add(recordID);
                
                // Başlıktaki sayıları temizle (Örn: "33 Uluslararası İktisat 3" -> "Uluslararası İktisat 3")
                let videoName = text.replace(/\s+/g, ' ').replace(/izle/gi, '').replace(/oynat/gi, '').replace(/play/gi, '').trim();
                videoName = videoName.replace(/^\d+[\s.-]*/, '').trim(); // Başındaki sayıları sil

                if (!videoName || videoName.length < 2 || videoName.length > 200) {
                    videoName = `Ders Kaydı (${recordID.substring(0, 8)})`;
                }

                // Sunucu adını tespit et
                let server = "s4";
                if (combinedAttr.includes('s7.okinar')) server = "s7";
                else if (combinedAttr.includes('s4.okinar')) server = "s4";
                else {
                    const sMatch = combinedAttr.match(/(s\d+)\.okinar\.com/i);
                    if (sMatch) server = sMatch[1].toLowerCase();
                }

                recordings.push({
                    videoName: videoName,
                    recordID: recordID,
                    server: server
                });
            }
        }
    });

    if (recordings.length === 0) {
        // Fallback: tüm sayfayı regex ile tara
        const bodyHtml = document.body.innerHTML;
        const rawMatches = bodyHtml.match(new RegExp(bbbFolderRegex.source, 'gi'));
        if (rawMatches) {
            const uniqueRawMatches = Array.from(new Set(rawMatches));
            uniqueRawMatches.forEach((recordID, idx) => {
                recordings.push({
                    videoName: `Ders Kaydı ${idx + 1}`,
                    recordID: recordID,
                    server: "s4"
                });
            });
        }
    }

    if (recordings.length > 0) {
        // Sıralamayı tersine çevir (Okinar genellikle tersten listeler, 38, 37, 36...)
        // Biz veritabanına eklerken 1, 2, 3 diye gitsin diye reverse ediyoruz
        recordings.reverse();

        console.log(`✅ Toplam ${recordings.length} adet video kaydı tespit edildi.`);
        
        const result = [{
            courseName: courseName,
            classroomLink: window.location.href,
            videoCount: recordings.length,
            recordings: recordings
        }];

        // JSON olarak indir
        const blob = new Blob([JSON.stringify(result, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `okinar_${courseName.toLowerCase().replace(/\s+/g, '_')}_kayitlari.json`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        console.log(`💾 Dosya indirildi: okinar_${courseName.toLowerCase().replace(/\s+/g, '_')}_kayitlari.json`);
    } else {
        console.error("❌ Sayfada hiçbir video kaydı (BBB Meeting ID) bulunamadı!");
    }
})();
