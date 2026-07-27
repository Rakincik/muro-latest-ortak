/**
 * OKINAR LMS - Güncel ve Eksiksiz Video Kayıtları Çekici (Consol Scripti)
 * 
 * Bu script Okinar panelinde "Dersler" (dereceuzem.okinar.com/classroom/) sayfasındayken çalışır.
 * Görünmez bir iframe kullanarak her dersin "Kayıtlar" sayfasına girer, JavaScript ve AJAX 
 * isteklerinin tamamlanmasını bekler (3.5 saniye) ve ardından render edilmiş video listesini çeker.
 * 
 * Sürüm 3: Sayfalandırma (Pagination) desteklidir. Tüm sayfaları sırayla gezip indirir.
 * 
 * Kullanımı:
 * 1. Tarayıcıda dereceuzem.okinar.com/classroom/ sayfasına gidin.
 * 2. F12 tuşuna basıp Console (Konsol) sekmesini açın.
 * 3. Bu kodun tamamını yapıştırıp Enter'a basın.
 * 4. Tarama bitene kadar sekmeyi kapatmayın. Sonunda "dereceuzem_guncel_kayitlar.json" dosyası inecektir.
 */

(async () => {
    console.log("%c🚀 Okinar Güncel Kayıt Çekici (Sayfalandırmalı) Başlatıldı...", "color: #00ff00; font-size: 16px; font-weight: bold;");
    
    // Yardımcı bekleme fonksiyonu
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    // Belirli bir döküman içinde "Kayıtlar" butonlarını ve ders adlarını arar
    const getCoursesFromDoc = (doc) => {
        // Ana tabloyu bulmaya çalışarak aramayı sınırlandırıyoruz (böylece header/menülerdeki Kayıt Ol gibi butonları eliyoruz)
        const table = doc.querySelector('table#dtbl, table.table, table');
        const searchScope = table || doc;

        // Tüm olası link, buton ve tıklanabilir elemanları çek
        const els = Array.from(searchScope.querySelectorAll('a, button, [onclick], div.btn, span.btn'));
        
        // "Kayıtlar" butonlarını filtrele
        const kayitlarButtons = els.filter(el => {
            const text = el.innerText.trim().toLowerCase();
            const href = el.getAttribute('href') || '';
            const onclick = el.getAttribute('onclick') || '';
            const outerHTML = el.outerHTML || '';
            
            // "Kayıt Ol", "Giriş Yap" vb. butonları filtreleyip eliyoruz
            if (text.includes('kayıt ol') || text.includes('kayitol') || text.includes('register') || href.includes('register')) {
                return false;
            }
            
            const matchesText = text.includes('kayıt') || text.includes('kayit') || text.includes('record');
            const matchesAttr = href.includes('/classroom/video/') || 
                                onclick.includes('/classroom/video/') || 
                                outerHTML.includes('/classroom/video/') ||
                                onclick.includes('btn_recordings') ||
                                onclick.includes('recordings') ||
                                onclick.includes('kayitlar') ||
                                onclick.includes('kayit');
                                
            return matchesText || matchesAttr;
        });

        // Fallback: Doğrudan recordings linki barındıranlar
        if (kayitlarButtons.length === 0) {
            const fallbackButtons = els.filter(el => {
                const href = el.getAttribute('href') || '';
                const onclick = el.getAttribute('onclick') || '';
                const outerHTML = el.outerHTML || '';
                return href.includes('/classroom/video/') || 
                       onclick.includes('/classroom/video/') || 
                       outerHTML.includes('/classroom/video/') ||
                       onclick.includes('recordings(');
            });
            kayitlarButtons.push(...fallbackButtons);
        }

        // Benzersiz butonları ayıkla ve ders adlarıyla eşleştir
        const uniqueCourses = [];
        const seenIdentifiers = new Set();

        kayitlarButtons.forEach(btn => {
            const href = btn.getAttribute('href') || '';
            const onclick = btn.getAttribute('onclick') || '';
            const identifier = href + "||" + onclick;
            
            if (identifier && !seenIdentifiers.has(identifier)) {
                seenIdentifiers.add(identifier);
                
                // Ders ismini bul
                let courseName = "Bilinmeyen Ders";
                try {
                    let parent = btn.parentElement;
                    for (let depth = 0; depth < 5; depth++) {
                        if (!parent) break;
                        const header = parent.querySelector('h1, h2, h3, h4, h5, strong, .card-title, .title');
                        if (header && header.innerText.trim().length > 2) {
                            courseName = header.innerText.trim().split('\n')[0];
                            break;
                        }
                        const cells = Array.from(parent.querySelectorAll('td'));
                        if (cells.length > 0) {
                            let nameCandidate = "";
                            const firstCell = cells[0];
                            if (firstCell) {
                                const lines = firstCell.innerText.split('\n').map(l => l.trim()).filter(l => l.length > 0);
                                if (lines.length > 0) {
                                    nameCandidate = lines[0];
                                }
                            }
                            if (nameCandidate) {
                                courseName = nameCandidate;
                                break;
                            }
                        }
                        parent = parent.parentElement;
                    }
                    if (courseName === "Bilinmeyen Ders" || courseName.toLowerCase().includes("katıl") || courseName.toLowerCase().includes("kayıtlar")) {
                        let sibling = btn.parentElement;
                        while (sibling) {
                            const text = sibling.innerText.trim();
                            if (text && text !== btn.innerText.trim() && text.length > 3 && !text.includes('Katıl') && !text.includes('Kaynaklar')) {
                                let lines = text.split('\n').map(l => l.trim()).filter(l => l.length > 0);
                                let nameCandidate = lines[0] || "Bilinmeyen Ders";
                                const dateRegex = /^\d{4}[-.\/]\d{2}[-.\/]\d{2}|\d{2}[-.\/]\d{2}[-.\/]\d{4}/;
                                if (dateRegex.test(nameCandidate) && lines.length > 1) {
                                    nameCandidate = lines[1];
                                }
                                courseName = nameCandidate;
                                break;
                            }
                            sibling = sibling.previousElementSibling;
                        }
                    }
                } catch (e) {}

                uniqueCourses.push({
                    btn: btn,
                    courseName: courseName,
                    href: href,
                    onclick: onclick
                });
            }
        });

        return uniqueCourses;
    };

    // Tüm pencereleri (main ve same-origin iframes) tarayarak dersleri ve dökümanı döndürür
    const findCoursesInAllWindows = (doc = document) => {
        let found = getCoursesFromDoc(doc);
        let activeDoc = doc;

        if (found.length > 0) {
            return { courses: found, doc: activeDoc };
        }

        const iframes = doc.querySelectorAll('iframe');
        for (let i = 0; i < iframes.length; i++) {
            try {
                const iframe = iframes[i];
                const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
                if (iframeDoc) {
                    const result = findCoursesInAllWindows(iframeDoc);
                    if (result.courses.length > 0) {
                        return result;
                    }
                }
            } catch (e) {}
        }
        return { courses: [], doc: null };
    };

    // Sonraki Sayfa butonunu bulur
    const findNextButton = (doc) => {
        if (!doc) return null;
        // Datatables veya klasik bootstrap sonraki sayfa butonları
        return doc.querySelector('li.paginate_button.next:not(.disabled) a') || 
               doc.querySelector('#dtbl_next:not(.disabled)') || 
               doc.querySelector('a.next:not(.disabled)') ||
               Array.from(doc.querySelectorAll('a, button')).find(el => {
                   const text = el.innerText.trim().toLowerCase();
                   return (text === 'sonraki' || text === 'next' || text === '›' || text === '>>') && !el.closest('.disabled') && !el.classList.contains('disabled');
               });
    };

    // Arka planda çalışacak görünmez iframe'i oluştur
    let iframe = document.getElementById('okinarVideoScraperIframe');
    if (iframe) iframe.remove(); // Varsa eskiyi temizle

    iframe = document.createElement('iframe');
    iframe.id = 'okinarVideoScraperIframe';
    iframe.style.position = 'fixed';
    iframe.style.top = '-9999px';
    iframe.style.left = '-9999px';
    iframe.style.width = '1024px';
    iframe.style.height = '768px';
    iframe.style.zIndex = '-99999';
    document.body.appendChild(iframe);

    const results = [];
    let hasNextPage = true;
    let pageNum = 1;

    while (hasNextPage) {
        console.log(`\n%c📄 --- SAYFA ${pageNum} TARANIYOR ---`, "color: #007bff; font-weight: bold;");
        
        // 1. Mevcut sayfadaki dersleri bul
        const searchResult = findCoursesInAllWindows(document);
        const currentCourses = searchResult.courses;
        const currentDoc = searchResult.doc;

        if (currentCourses.length === 0) {
            console.warn(`⚠️ Sayfa ${pageNum} üzerinde ders/kayıt butonu bulunamadı.`);
            hasNextPage = false;
            break;
        }

        console.log(`🔍 Sayfa ${pageNum} üzerinde ${currentCourses.length} adet ders tespit edildi.`);

        // 2. Sayfadaki tüm derslerin kayıtlarını çek
        for (let i = 0; i < currentCourses.length; i++) {
            const course = currentCourses[i];
            
            // Linki çöz
            let link = course.href;
            if (course.onclick && course.onclick.includes('recordings(')) {
                const match = course.onclick.match(/recordings\(['"]([^'"]+)['"]\)/);
                if (match) {
                    link = `/classroom/video/${match[1]}`;
                }
            } else if (course.onclick && !link) {
                const match = course.onclick.match(/['"](.*\/classroom\/video\/[^'"]+)['"]/);
                if (match) {
                    link = match[1];
                } else {
                    const cleanOnclick = course.onclick.replace(/location\.href\s*=\s*/g, '').replace(/['"]/g, '').trim();
                    if (cleanOnclick.includes('/classroom/video/')) {
                        link = cleanOnclick;
                    }
                }
            }

            if (!link) {
                const slugMatch = (course.btn.outerHTML || '').match(/dereceuzem\d+/i);
                if (slugMatch) {
                    link = `/classroom/video/${slugMatch[0]}`;
                }
            }

            if (!link) {
                console.warn(`⚠️ [Sayfa ${pageNum}] [${i+1}/${currentCourses.length}] ${course.courseName} için Kayıtlar URL'i çözülemedi, geçiliyor.`);
                continue;
            }

            if (link.startsWith('/')) {
                link = window.location.origin + link;
            }

            console.log(`⏳ [Sayfa ${pageNum}] [${i+1}/${currentCourses.length}] "${course.courseName}" taranıyor...`);

            try {
                iframe.src = link;
                
                // Dinamik Bekleme: Sayfanın yüklenmesini veya AJAX isteklerinin tamamlanmasını izler
                let loaded = false;
                const bbbFolderRegex = /[a-f0-9]{40}-\d{13}/i;
                
                for (let attempt = 0; attempt < 20; attempt++) { // Maksimum 5 saniye (20 * 250ms)
                    await sleep(250);
                    const doc = iframe.contentDocument || iframe.contentWindow.document;
                    if (!doc || !doc.body) continue;
                    
                    const htmlText = doc.body.innerHTML;
                    const isStillLoading = htmlText.includes('yükleniyor') || htmlText.includes('Loading...');
                    const hasRecordings = htmlText.match(bbbFolderRegex);
                    const noRecordingsFound = htmlText.includes('Kayıt bulunamadı') || htmlText.includes('Kayıt Yok') || htmlText.includes('no recordings');
                    
                    if ((!isStillLoading && hasRecordings) || noRecordingsFound) {
                        loaded = true;
                        break;
                    }
                }
                
                // Fallback olarak ek 500ms daha bekletelim (tam render için)
                if (!loaded) {
                    await sleep(1000);
                } else {
                    await sleep(300);
                }

                const doc = iframe.contentDocument || iframe.contentWindow.document;
                const htmlText = doc.body.innerHTML;
                const recordings = [];

                // DOM'dan kayıtları bul
                const allElements = Array.from(doc.querySelectorAll('a, button, li, tr, [onclick], div, span'));
                allElements.forEach(el => {
                    const text = el.innerText.trim();
                    const elHref = el.getAttribute('href') || '';
                    const elOnclick = el.getAttribute('onclick') || '';
                    const combinedAttr = elHref + " " + elOnclick + " " + el.outerHTML;

                    const match = combinedAttr.match(bbbFolderRegex);
                    if (match) {
                        const recordID = match[0].trim();
                        let videoName = text.replace(/\s+/g, ' ').trim();
                        
                        videoName = videoName.replace(/izle/gi, '').replace(/oynat/gi, '').replace(/play/gi, '').trim();
                        if (!videoName || videoName.length < 2 || videoName.length > 200) {
                            videoName = `Video (${recordID.substring(0, 8)})`;
                        }

                        let server = "s4";
                        if (combinedAttr.includes('s7.okinar')) server = "s7";
                        else if (combinedAttr.includes('s4.okinar')) server = "s4";
                        else {
                            const sMatch = combinedAttr.match(/(s\d+)\.okinar\.com/i);
                            if (sMatch) server = sMatch[1].toLowerCase();
                        }

                        if (!recordings.some(r => r.recordID === recordID)) {
                            recordings.push({
                                videoName: videoName,
                                recordID: recordID,
                                server: server
                            });
                        }
                    }
                });

                // Fallback Regex ile bul
                if (recordings.length === 0) {
                    const rawMatches = htmlText.match(new RegExp(bbbFolderRegex.source, 'gi'));
                    if (rawMatches) {
                        const uniqueRawMatches = Array.from(new Set(rawMatches));
                        uniqueRawMatches.forEach((recordID, idx) => {
                            let server = "s4";
                            const idxInHtml = htmlText.indexOf(recordID);
                            if (idxInHtml !== -1) {
                                const surroundingText = htmlText.substring(Math.max(0, idxInHtml - 200), idxInHtml);
                                if (surroundingText.includes('s7.okinar')) server = "s7";
                                else if (surroundingText.includes('s4.okinar')) server = "s4";
                                else {
                                    const sMatch = surroundingText.match(/(s\d+)\.okinar\.com/i);
                                    if (sMatch) server = sMatch[1].toLowerCase();
                                }
                            }
                            recordings.push({
                                videoName: `ders-${idx + 1}`,
                                recordID: recordID,
                                server: server
                            });
                        });
                    }
                }

                console.log(`   ✅ "${course.courseName}" tamamlandı. Bulunan video sayısı: ${recordings.length}`);
                
                results.push({
                    courseName: course.courseName,
                    classroomLink: link,
                    videoCount: recordings.length,
                    recordings: recordings
                });

            } catch (err) {
                console.error(`❌ "${course.courseName}" taranırken hata:`, err);
            }
        }

        // 3. Sonraki sayfaya geçiş kontrolü
        const nextBtn = findNextButton(currentDoc);
        if (nextBtn) {
            console.log("%c➡️ Sonraki sayfaya geçiliyor...", "color: #ffc107; font-weight: bold;");
            nextBtn.click();
            pageNum++;
            await sleep(2500); // Yeni sayfa verilerinin yüklenmesini bekle
        } else {
            console.log("%c🏁 Son sayfaya ulaşıldı, tarama sonlandırılıyor.", "color: #28a745; font-weight: bold;");
            hasNextPage = false;
        }
    }

    // Temizlik
    iframe.remove();

    // Dosyayı indir
    const blob = new Blob([JSON.stringify(results, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    const domain = window.location.hostname;
    a.download = `${domain}_recordings.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    console.log("%c🎉 BÜTÜN TARAMA BAŞARIYLA TAMAMLANDI! DOSYA İNDİRİLDİ.", "color: #00ff00; font-size: 18px; font-weight: bold;");
    console.log("Tarama yapılan toplam ders sayısı:", results.length);
    console.log("Toplam video sayısı:", results.reduce((acc, curr) => acc + curr.videoCount, 0));
})();
