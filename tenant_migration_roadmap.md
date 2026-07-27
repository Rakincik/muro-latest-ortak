# 🚀 MURO LMS: Çoklu Kurum (Multi-Tenant) Geçiş Yol Haritası ve Kılavuzu

Bu kılavuz, `3U` kurumunda karşılaştığımız yönlendirme ve API adresi eşleşme problemlerinden çıkarılan derslerle, kalan **7 kurumun** yeni mono repo (`mono.git`) mimarisine sorunsuz bir şekilde taşınması için adım adım rehberlik eder.

---

## 🔍 Eşitleme Sırasında Karşılaşılan Kritik Hatalar ve Çözümleri

Diğer kurumların geçişine başlamadan önce `3U` sürecinde çözdüğümüz iki büyük teknik engeli aklımızda tutmalıyız:

### 1. Next.js basePath / Yönlendirme Hatası (404 Not Found)
*   **Sorun:** `mono` reposundaki güncel `next.config.ts` kodunda, eğer derleme anında bir base path belirtilmezse varsayılan olarak tüm yolların başına `/admin` eki eklenir. Bu durum subdomain ile çalışan sitelerde (Örn: `3u-ad.muro.click/dashboard`) **404 Not Found** hatasına yol açar.
*   **Çözüm:** Derleme komutunda `NEXT_PUBLIC_BASE_PATH=""` argümanını geçirerek bu eki devre dışı bırakmalıyız.

### 2. API Adresinin `localhost:5292` Olarak Kalması (Bağlantı Hatası)
*   **Sorun:** Next.js derleme motoru (Webpack), modül düzeyinde atanan `export const API_URL = ...` satırını derleme aşamasında (build-time) çalıştırıp doğrudan `localhost:5292` olarak JS dosyalarının içerisine statik bir metin halinde gömer.
*   **Çözüm:** Derleme komutunda `NEXT_PUBLIC_API_URL` argümanını ilgili kurumun API adresiyle (Örn: `https://3u-ap.muro.click/api/v1`) derleme anında beslemeliyiz.

> [!IMPORTANT]
> Her iki parametrenin de Docker build aşamasında geçerli olabilmesi için sunucudaki **`frontend/admin/Dockerfile`** dosyasının başında mutlaka şu tanımlamaların yer alması gerekir:
> ```dockerfile
> ARG NEXT_PUBLIC_BASE_PATH
> ENV NEXT_PUBLIC_BASE_PATH=$NEXT_PUBLIC_BASE_PATH
> ARG NEXT_PUBLIC_API_URL
> ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
> ```

---

## 📋 Adım Adım Kurum Geçiş Playbook'u (Yol Haritası)

Kalan 7 kurumun (Örn: `ens`, `akm`, `trk`, `omr`, `mvz`, `mng`, `hll`) her biri için sırasıyla şu adımları uygulayacağız:

### Adım 1: Kurum Parametrelerinin Belirlenmesi (Pre-Flight)
Geçişe başlamadan önce kurum için şu 4 parametreyi not edin:
1.  **Kurum Kodu:** `[KURUM]` (Örn: `ens`)
2.  **Yönlendirme Tipi:** Subdomain mimarisi mi, yoksa Monopol gibi tek domain (`basePath: '/admin'`) mimarisi mi?
    *   *Subdomain ise:* `NEXT_PUBLIC_BASE_PATH=""`
    *   *Tek domain ise:* `NEXT_PUBLIC_BASE_PATH="/admin"`
3.  **API Domaini:** `https://[KURUM]-api.muro.click/api/v1` (veya `[KURUM]-ap`)
4.  **OpenLiteSpeed Portları:** CyberPanel'in vhost ayarlarından (veya eski docker-compose dosyasından) admin ve api portları tespit edilir:
    *   `grep -rn "[KURUM]-ad" /usr/local/lsws/conf/`

### Adım 2: Sunucudaki Dockerfile Kontrolü
Sunucudaki `/opt/[KURUM]/frontend/admin/Dockerfile` dosyasında `ARG` tanımlarının yukarıda bahsedilen **[IMPORTANT]** uyarısındaki gibi güncel olduğundan emin olun. Gerekirse `cat << 'EOF' > ...` ile güncelleyin.

### Adım 3: Temiz Derleme (Build)
İlgili kurumun dizinine gidip (`/opt/[KURUM]`), aşağıdaki şablona göre derleme komutunu çalıştırın:

```bash
docker build --no-cache -t muro-admin-[KURUM]:latest \
  --build-arg NEXT_PUBLIC_API_URL="https://[KURUM]-ap.muro.click/api/v1" \
  --build-arg NEXT_PUBLIC_BASE_PATH="" \
  -f frontend/admin/Dockerfile ./frontend/admin
```
*(Not: `NEXT_PUBLIC_API_URL` ve `NEXT_PUBLIC_BASE_PATH` değerlerini Adım 1'de belirlediğiniz verilere göre özelleştirin).*

### Adım 4: Compose Güncelleme ve Başlatma
`docker-compose.[KURUM].yml` dosyasını kontrol edin. Derlenen yeni imaj adını (`muro-admin-[KURUM]:latest`) ve doğru port eşleşmelerini doğruladıktan sonra container'ı yeniden başlatın:

```bash
docker compose -f docker-compose.[KURUM].yml up -d
```

### Adım 5: Doğrulama (Post-Flight)
1.  Tarayıcıda yeni bir **Gizli Sekme (Incognito Window)** açın.
2.  Kurumun panel adresine gidin: `https://[KURUM]-ad.muro.click/dashboard`
3.  `F12` Geliştirici Konsolunu açın. console sekmesinde `localhost:5292` hatası olmadığını ve API isteklerinin başarıyla `https://[KURUM]-ap.muro.click/api/v1` adresine gittiğini doğrulayın.

---

## 📊 Kurum Parametre Takip Matrisi

| Kurum (Tenant) | Çalışma Portu | API URL (NEXT_PUBLIC_API_URL) | Base Path (NEXT_PUBLIC_BASE_PATH) | Durum |
| :--- | :---: | :--- | :---: | :---: |
| **3U** | `13001` | `https://3u-ap.muro.click/api/v1` | `""` (Boş) | **✅ Aktif & Çalışıyor** |
| **ENS** | *Beklemede* | `https://ens-api.muro.click/api/v1` | `""` veya `"/admin"` | *Sıradaki* |
| **AKM** | *Beklemede* | `https://akm-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |
| **TRK** | *Beklemede* | `https://trk-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |
| **OMR** | *Beklemede* | `https://omr-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |
| **MVZ** | *Beklemede* | `https://mvz-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |
| **MNG** | *Beklemede* | `https://mng-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |
| **HLL** | *Beklemede* | `https://hll-api.muro.click/api/v1` | *Belirlenecek* | *Beklemede* |

---

> [!TIP]
> Geçiş yaptığımız her kurumda derleme öncesi port çakışmalarını önlemek için `docker ps` ile mevcut port durumlarını süzmek işimizi çok kolaylaştıracaktır.
