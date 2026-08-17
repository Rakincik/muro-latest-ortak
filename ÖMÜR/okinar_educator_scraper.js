/**
 * OKINAR LMS - Eğitimci (Instructor) Çekici Konsol Scripti (İlk Öğrencide Duran Sürüm)
 * 
 * Bu script, Okinar tabanlı LMS sitelerinden "Kullanıcılar" veya "Eğitimciler" 
 * sayfasındaki rolü "Eğitimci" olan kişilerin bilgilerini (Ad Soyad, Telefon, E-posta) 
 * çekerek JSON formatında bilgisayarınıza indirir.
 * 
 * Sıralama Şartı:
 * Bu scripti çalıştırmadan önce tablonun "Rol" sütununa tıklayarak eğitimcileri 
 * en üste getirin. Script ilk "Öğrenci" satırını gördüğü anda taramayı durduracaktır.
 * 
 * Hızlı Kullanım:
 * 1. Tarayıcınızda Okinar Yönetim Panelinde "Kullanıcılar" sayfasına gidin.
 * 2. Tabloyu "Rol" sütununa göre sıralayıp eğitimcileri en üste getirin.
 * 3. Tablo satır sayısını en yüksek yapın (örn: 100).
 * 4. F12 -> Console sekmesine bu kodun tamamını yapıştırıp Enter'a basın.
 */

(() => {
    console.log("🚀 Eğitimci tarayıcı başlatılıyor (İlk öğrencide duracak)...");

    setTimeout(() => {
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        if (rows.length === 0) {
            console.error("❌ Tabloda kullanıcı satırı bulunamadı!");
            return;
        }

        const educators = [];
        const table = document.querySelector('table');
        const headers = Array.from(table.querySelectorAll('thead th')).map(th => th.innerText.trim().toLowerCase());
        
        const roleIdx = headers.findIndex(h => h.includes('rol'));
        const nameIdx = headers.findIndex(h => h.includes('ad') || h.includes('isim') || h.includes('soyad'));
        const phoneIdx = headers.findIndex(h => h.includes('tel') || h.includes('telefon'));
        const emailIdx = headers.findIndex(h => h.includes('eposta') || h.includes('mail') || h.includes('email'));
        const regIdx = headers.findIndex(h => h.includes('kayıt') || h.includes('tarih'));

        console.log(`[*] Tespit edilen sütun indeksleri: Rol=${roleIdx}, Adı=${nameIdx}, Tel=${phoneIdx}, Eposta=${emailIdx}`);

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const cells = row.querySelectorAll('td');
            if (cells.length >= 4) {
                const roleText = roleIdx !== -1 && cells[roleIdx] ? cells[roleIdx].innerText.trim() : "";
                
                // Rolün eğitimci/yönetici/admin olup olmadığını kontrol et
                const isStaff = roleText.toLowerCase().includes("eğitimci") || 
                                roleText.toLowerCase().includes("instructor") || 
                                roleText.toLowerCase().includes("yönetici") || 
                                roleText.toLowerCase().includes("admin");

                if (!isStaff) {
                    console.log(`🛑 Rolü "${roleText}" olan ilk satıra gelindi (Eğitimci değil). Tarama durduruluyor...`);
                    break;
                }

                const name = nameIdx !== -1 && cells[nameIdx] ? cells[nameIdx].innerText.trim() : "";
                const phone = phoneIdx !== -1 && cells[phoneIdx] ? cells[phoneIdx].innerText.trim() : "";
                const email = emailIdx !== -1 && cells[emailIdx] ? cells[emailIdx].innerText.trim() : "";
                const regDate = regIdx !== -1 && cells[regIdx] ? cells[regIdx].innerText.trim() : "";

                if (name) {
                    educators.push({
                        id: educators.length + 1,
                        name: name,
                        phone: phone,
                        email: email,
                        role: roleText,
                        registrationDate: regDate
                    });
                }
            }
        }

        console.log(`📊 Toplam ${educators.length} eğitimci/yönetici bulundu.`);

        if (educators.length > 0) {
            // JSON dosyasını indir
            const jsonBlob = new Blob([JSON.stringify(educators, null, 2)], { type: 'application/json' });
            const jsonUrl = URL.createObjectURL(jsonBlob);
            const jsonA = document.createElement('a');
            jsonA.href = jsonUrl;
            jsonA.download = `omr_egitimciler.json`;
            document.body.appendChild(jsonA);
            jsonA.click();
            jsonA.remove();
            URL.revokeObjectURL(jsonUrl);
            console.log("✅ 'omr_egitimciler.json' başarıyla indirildi!");
        } else {
            console.warn("⚠️ Filtreye uyan hiçbir eğitimci bulunamadı.");
        }
    }, 500);
})();
