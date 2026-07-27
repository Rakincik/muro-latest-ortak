/**
 * OKINAR LMS - Sınav ve Soru Çekici Konsol Scripti (Otomatik Başlayan Sürüm)
 * 
 * Bu script, omurhoca.okinar.com ve benzeri okinar tabanlı LMS sitelerinden
 * sınav listelerini, soruları ve cevap şıklarını çekerek JSON formatında kaydeder.
 * 
 * Hızlı Kullanım:
 * 1. Tarayıcınızda "Sınavlar" veya "Sınav Soruları" sayfasına gidin.
 * 2. F12 tuşuna basıp "Console" (Konsol) sekmesini açın.
 * 3. Bu kodun tamamını kopyalayıp konsola yapıştırın ve Enter'a basın.
 *    (Script hangi sayfada olduğunu otomatik algılayıp doğrudan taramaya başlayacaktır!)
 */

const consoleScraper = (() => {
    // Yardımcı Gecikme Fonksiyonu (milisaniye cinsinden bekler)
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

    // Dosya İndirme Fonksiyonu
    const downloadJSON = (data, filename) => {
        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        console.log(`✅ ${filename} başarıyla indirildi!`);
    };

    // Buton ve linkleri güvenli tıklayan fonksiyon (jQuery/Native click bir arada)
    const clickElement = (win, el) => {
        if (!el) return;
        try {
            if (win.$ && win.$(el).trigger) {
                win.$(el).trigger('click');
                return;
            }
        } catch (e) {}
        try {
            el.click();
        } catch (e) {}
        try {
            const ev = new win.MouseEvent('click', {
                bubbles: true,
                cancelable: true,
                view: win
            });
            el.dispatchEvent(ev);
        } catch (e) {}
    };

    // Modal içerisindeki Aktif Sorunun Detaylarını Çeken Fonksiyon
    const parseQuestionFromModal = (doc, modal) => {
        const modalBody = modal.querySelector('.modal-body');
        if (!modalBody) return null;

        // Soru Başlığı (Örn: "Soru 1")
        const titleEl = modal.querySelector('.modal-title, h1, h2, h3, h4, h5, h6, .modal-header');
        let titleText = titleEl ? titleEl.innerText.trim() : 'Soru';
        // Kapatma butonu metni (× veya x) ve yeni satırları temizle
        titleText = titleText.split('\n')[0].replace(/×/g, '').replace(/\bx\b/gi, '').trim();

        // Şıkları Bul
        const options = {};
        const optionLetters = ['A', 'B', 'C', 'D', 'E'];
        
        // Modal içindeki tüm olası div, p, span ve list elemanlarını tara
        const allElements = Array.from(modalBody.querySelectorAll('div, p, span, li, td, .card'));

        optionLetters.forEach(letter => {
            // Şık harfiyle başlayan en derin elemanları filtrele
            const candidates = allElements.filter(el => {
                const text = el.innerText.trim();
                // "A\nSeçenek", "A Seçenek", "A: Seçenek", "A. Seçenek" durumlarını kapsar
                return text.startsWith(letter + '\n') || 
                       text.startsWith(letter + '\t') || 
                       text.startsWith(letter + ' ') || 
                       text.startsWith(letter + ':') || 
                       text.startsWith(letter + '.') || 
                       text === letter;
            });

            if (candidates.length > 0) {
                // Sadece harf barındıran (boş seçenek gibi) adayları elemek için, 
                // harfin yanında ekstra içerik barındıran en kısa adayı seçelim.
                const contentCandidates = candidates.filter(el => {
                    const cleanText = el.innerText.trim().replace(new RegExp('^' + letter + '[\\s\\.:\\n]*', 'i'), '');
                    return cleanText.length > 0;
                });
                
                const finalCandidates = contentCandidates.length > 0 ? contentCandidates : candidates;
                finalCandidates.sort((a, b) => a.innerText.length - b.innerText.length);
                const bestMatch = finalCandidates[0];
                let text = bestMatch.innerText.trim();
                
                // Şık harfini metinden temizle
                if (text.startsWith(letter)) {
                    text = text.substring(1).trim();
                    if (text.startsWith(':') || text.startsWith('.') || text.startsWith('\n')) {
                        text = text.substring(1).trim();
                    }
                }
                options[letter] = text;
            }
        });

        // Soru Metnini Bul
        let questionText = '';
        const firstChild = modalBody.firstElementChild;

        // İlk eleman şık değilse, soru metni odur
        if (firstChild && !optionLetters.some(letter => firstChild.innerText.trim().startsWith(letter))) {
            questionText = firstChild.innerText.trim();
        } else {
            // Alternatif: Modal body metninden şıkları çıkartarak soru metnini bul
            let bodyText = modalBody.innerText;
            optionLetters.forEach(letter => {
                if (options[letter]) {
                    bodyText = bodyText.replace(letter, '').replace(options[letter], '');
                }
            });
            // Ekstra buton metinlerini temizle
            bodyText = bodyText.replace(/Vazgeç/g, '').replace(/Önceki/g, '').replace(/Sonraki/g, '');
            questionText = bodyText.trim();
        }

        return {
            title: titleText,
            question: questionText,
            options: options
        };
    };

    // Tek Bir Sınav Sayfasındaki Soruları Çeken Çekirdek Akış
    const scrapeQuestionsOnPage = async (win, examName) => {
        console.log(`[${examName}] Sorular yükleniyor...`);
        
        // List sayfasının asıl URL'ini kaydet (yönlendirmeli sayfalardan geri dönmek için)
        const listUrl = win.location.href;

        const questions = [];
        let questionIndex = 0;
        let hasMore = true;

        // 2. Her sorunun "Ön izleme" butonuna sırayla tıklayarak aç, oku ve kapat
        while (hasMore) {
            // Soru listesi tablosunun (select length veya dtbl) tamamen yüklenmesini bekle (Tıpkı history.back() sonrasındaki gibi)
            let listReady = false;
            for (let attempt = 0; attempt < 30; attempt++) {
                try {
                    const hasLengthSelect = win.document.querySelector('select[name$="_length"], select.custom-select, #dtbl');
                    if (hasLengthSelect) {
                        listReady = true;
                        break;
                    }
                } catch (e) {}
                await sleep(500);
            }

            if (!listReady) {
                console.error(`[${examName}] Soru listesi tablosu yüklenemedi!`);
                break;
            }

            // Sayfa yönlendirmesi veya geri dönüş sonrasında satır sayısının 100 olduğundan emin ol
            try {
                const selectEl = win.document.querySelector('select[name$="_length"], select.custom-select, select.form-control-sm');
                if (selectEl && selectEl.value !== '100') {
                    selectEl.value = '100';
                    selectEl.dispatchEvent(new win.Event('change'));
                    console.log(`[${examName}] Gösterim sayısı tekrar 100 yapılıyor, tablonun yüklenmesi bekleniyor...`);
                    await sleep(2500);
                }
            } catch (e) {}

            // DOM güncellendiği için her döngüde buton listesini yeniden sorgula
            let previewBtns = [];
            try {
                previewBtns = Array.from(win.document.querySelectorAll('a, button')).filter(el => {
                    const text = el.textContent.toLowerCase().replace(/\s/g, '');
                    const hasClickAttr = el.getAttribute('onclick')?.includes('btn_questions') || el.onclick?.toString().includes('btn_questions');
                    return text.includes('önizleme') || text.includes('izleme') || hasClickAttr;
                });
            } catch (e) {}

            // Eğer listedeki tüm sorular bittiyse taramayı tamamla
            if (previewBtns.length === 0 || questionIndex >= previewBtns.length) {
                console.log(`[${examName}] Tüm sorular başarıyla tamamlandı. Toplam soru sayısı: ${questionIndex}`);
                break;
            }

            console.log(`[${examName}] Soru ${questionIndex + 1}/${previewBtns.length} açılıyor...`);
            const targetBtn = previewBtns[questionIndex];

            // Ön izleme butonuna tıkla
            clickElement(win, targetBtn);

            // Modalın veya soru detay sayfasının yüklenmesini bekle (En fazla 10 saniye)
            let modalLoaded = false;
            let activeModal = null;
            for (let attempt = 0; attempt < 20; attempt++) {
                await sleep(500);
                try {
                    activeModal = Array.from(win.document.querySelectorAll('.modal')).find(m => win.getComputedStyle(m).display !== 'none');
                    // Veya detay sayfası yüklendiyse (örneğin A şıkkı sayfada varsa)
                    const hasChoices = win.document.body.innerText.includes('A\n') || win.document.body.innerText.includes('A ') || win.location.href.includes('question');
                    if (activeModal || hasChoices) {
                        modalLoaded = true;
                        break;
                    }
                } catch (e) {}
            }

            if (!modalLoaded) {
                console.warn(`[${examName}] Soru ${questionIndex + 1} açılması zaman aşımına uğradı! Sonraki soruya geçiliyor.`);
                questionIndex++;
                continue;
            }

            // Sayfa stabilizasyonu için yarım saniye bekle
            await sleep(500);

            // Soru verilerini oku
            try {
                // Eğer sayfa modal yerine direkt detay sayfasına yönlendirildiyse, modal yerine document.body'i gönder
                const container = activeModal || win.document.body;
                const qData = parseQuestionFromModal(win.document, container);
                if (qData) {
                    // Soru başlığını/numarasını doğrula
                    if (qData.title === 'Soru') {
                        qData.title = `Soru ${questionIndex + 1}`;
                    }
                    questions.push(qData);
                    console.log(`[${examName}] Soru okundu:`, qData.title);
                }
            } catch (err) {
                console.error(`[${examName}] Soru ${questionIndex + 1} okunurken hata:`, err);
            }

            // Soru modalını kapat / Listeye geri dön
            console.log(`[${examName}] Kapatılıyor / listeye geri dönülüyor...`);
            
            // 1. Kapatma/vazgeçme butonuna bas
            try {
                const closeBtn = Array.from(win.document.querySelectorAll('.modal.show [data-dismiss="modal"], .modal.show button, .modal button, a.btn-default, button.btn-default')).find(el => {
                    const text = el.textContent.toLowerCase().replace(/\s/g, '');
                    return text.includes('vazgec') || text.includes('vazgeç') || text.includes('kapat') || text.includes('geri') || el.innerText === '×';
                });
                if (closeBtn) {
                    clickElement(win, closeBtn);
                }
            } catch (e) {}

            // 2. Yönlendirmeli sayfa açıldıysa veya URL değiştiyse, doğrudan liste URL'ine geri yönlendir
            await sleep(500); // Kapatma butonunun tetiklenmesini bekle
            try {
                if (win.location.href !== listUrl) {
                    win.location.href = listUrl;
                }
            } catch (e) {
                // CORS hatası alırsak (geçiş anında), güvenli yönlendirme yap
                try { win.location.href = listUrl; } catch (err) {}
            }

            // Bir sonraki soruya geç
            questionIndex++;
            await sleep(1000); // 1 saniye bekle ve devam et
        }

        return questions;
    };

    // TÜM SINAVLARI OTOMATİK ÇEKEN FONKSİYON (İçiçe Iframe Otomasyonu)
    const startAll = async () => {
        console.log('🚀 Toplu sınav çekme işlemi başlatıldı...');
        
        // Sınav satırlarını bul
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        if (rows.length === 0) {
            console.error('❌ Sayfada sınav tablosu bulunamadı! Lütfen "Sınavlar" sayfasında olduğunuza emin olun.');
            return;
        }

        const examsToScrape = [];

        // Tablodan sınav adlarını ve linklerini topla
        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 4) {
                const examName = cells[3]?.innerText.trim();
                const sorularBtn = Array.from(row.querySelectorAll('a, button')).find(el => el.textContent.includes('Sorular'));
                const url = sorularBtn ? sorularBtn.href : null;

                if (examName && url && url !== 'javascript:void(0)') {
                    examsToScrape.push({ name: examName, url: url });
                }
            }
        });

        if (examsToScrape.length === 0) {
            console.error('❌ Çekilecek geçerli bir sınav linki bulunamadı!');
            return;
        }

        console.log(`📊 Toplam ${examsToScrape.length} sınav bulundu. Sırayla çekiliyor...`);
        const allResults = [];

        // Sayfa üzerinde görünür bir iframe oluşturuyoruz (Popup engelleyiciye takılmaz!)
        console.log('ℹ️ Sayfa içine tarama ekranı (iframe) ekleniyor...');
        let iframe = document.getElementById('okinarScraperIframe');
        if (iframe) iframe.remove(); // Varsa temizle

        iframe = document.createElement('iframe');
        iframe.id = 'okinarScraperIframe';
        iframe.style.position = 'fixed';
        iframe.style.top = '10px';
        iframe.style.right = '10px';
        iframe.style.width = '1200px';
        iframe.style.height = '800px';
        iframe.style.zIndex = '999999';
        iframe.style.border = '3px solid #17a2b8';
        iframe.style.boxShadow = '0 0 15px rgba(0,0,0,0.5)';
        iframe.style.background = '#fff';
        document.body.appendChild(iframe);

        const iframeWin = iframe.contentWindow;

        for (let i = 0; i < examsToScrape.length; i++) {
            const exam = examsToScrape[i];
            console.log(`\n⏳ [${i + 1}/${examsToScrape.length}] Sınav Başlatılıyor: ${exam.name}`);
            
            // Önce iframe'i sıfırla
            try {
                iframeWin.location.href = 'about:blank';
            } catch (e) {}
            
            // about:blank yüklenmesini bekle
            let resetLoaded = false;
            for (let attempt = 0; attempt < 10; attempt++) {
                await sleep(200);
                try {
                    if (iframeWin && iframeWin.location.href === 'about:blank') {
                        resetLoaded = true;
                        break;
                    }
                } catch (e) {}
            }

            // Sınav linkini yükle
            try {
                iframeWin.location.href = exam.url;
            } catch (e) {}

            // Sayfanın yüklenmesini bekle (en fazla 15 saniye)
            let isLoaded = false;
            for (let attempt = 0; attempt < 30; attempt++) {
                await sleep(500);
                try {
                    if (iframeWin && iframeWin.document && iframeWin.document.readyState === 'complete') {
                        if (iframeWin.location.href !== 'about:blank') {
                            isLoaded = true;
                            break;
                        }
                    }
                } catch (e) {
                    // CORS/Yönlendirme aşaması, beklemeye devam et
                }
            }

            if (!isLoaded) {
                console.error(`❌ [${exam.name}] Sayfası yüklenemedi veya zaman aşımına uğradı!`);
                continue;
            }

            // Sayfanın tamamen stabil hale gelmesi için 1 saniye ek bekleme
            await sleep(1000);

            try {
                const questions = await scrapeQuestionsOnPage(iframeWin, exam.name);
                allResults.push({
                    examName: exam.name,
                    questionCount: questions.length,
                    questions: questions
                });
                console.log(`✅ [${exam.name}] başarıyla tamamlandı. ${questions.length} soru çekildi.`);
            } catch (err) {
                console.error(`❌ [${exam.name}] çekilirken hata oluştu:`, err);
            }
            
            await sleep(2000); 
        }

        // İşi bitince iframe'i temizle
        iframe.remove();

        console.log('🎉 Tüm sınav çekme işlemi tamamlandı!');
        downloadJSON(allResults, `${window.location.hostname}_sinavlar.json`);
    };

    // SADECE AÇIK OLAN TEK BİR SINAVI ÇEKEN FONKSİYON
    const startSingle = async () => {
        console.log('🚀 Tekil sınav çekme işlemi başlatıldı...');
        const pageTitleEl = document.querySelector('h1, h2, .content-header h1');
        const examName = pageTitleEl ? pageTitleEl.innerText.trim() : 'Tekil_Sinav';

        try {
            const questions = await scrapeQuestionsOnPage(window, examName);
            const result = [{
                examName: examName,
                questionCount: questions.length,
                questions: questions
            }];
            downloadJSON(result, `${examName.replace(/\s+/g, '_')}_sorulari.json`);
        } catch (err) {
            console.error('❌ Sınav çekilirken hata oluştu:', err);
        }
    };

    return {
        startAll: startAll,
        startSingle: startSingle
    };
})();

// Sayfa tespiti yapıp otomatik başlat (Sadece ana pencerede isek çalıştır)
const isChildWindow = window.name === 'okinarScraperWin' || (window.opener && window.opener !== window) || (window.self !== window.top);

if (!isChildWindow) {
    const currentUrl = window.location.href;
    const pageText = document.body.innerText;

    if (currentUrl.includes('sorular') || pageText.includes('Sınav Soruları') || pageText.includes('Soru Listesi')) {
        console.log('🔍 Soru listesi sayfası tespit edildi. Tekil tarama otomatik başlatılıyor...');
        consoleScraper.startSingle();
    } else {
        console.log('🔍 Sınav listesi sayfası tespit edildi. Toplu tarama otomatik başlatılıyor...');
        consoleScraper.startAll();
    }
} else {
    console.log('ℹ️ Popup/Child pencere (iframe) tespit edildi. Otomatik başlatma devre dışı bırakıldı (Ana pencere tarafından yönetiliyor).');
}
