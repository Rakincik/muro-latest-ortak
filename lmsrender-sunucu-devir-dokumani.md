# LMS Transcode Sunucusu — Sistem Kurulum & Devir Dökümanı

**Sunucu:** `lmsrender` · **IP:** `192.168.1.115` · **Kurulum tarihi:** 08.06.2026
**Amaç:** LMS için MP4 → HLS (720p + 480p) donanım hızlandırmalı transcode sunucusu.
**Bu belge:** Donanım, işletim sistemi ve sürücü kurulumunun tamamı tamamlanmış ve doğrulanmıştır. LMS projesinin kurulması ve transcode worker'larının yazılması bu belgeyi devralan kişiye aittir. Sonraki faz için kritik teknik notlar Bölüm 7-8'dedir.

---

## 1. Sistem Donanımı

| Bileşen | Model |
|---|---|
| İşlemci | Intel Core i9-13900K (24 çekirdek / 32 thread) |
| Anakart | MSI MAG Z790 Tomahawk WiFi DDR5 (MS-7D91) |
| RAM | 2×16 GB = 32 GB DDR5-5600 Corsair Dominator (XMP aktif, 5600 MHz) |
| GPU | MSI RTX 3090 Suprim X 24 GB (Ampere) |
| OS Diski | PNY CS3040 1 TB NVMe Gen4 (`nvme0n1`) |
| Depolama 1 | SanDisk Extreme 1 TB NVMe (`nvme1n1`) |
| Depolama 2 | Seagate ST2000DM008 2 TB HDD (`sda`) |
| Depolama 3 | WD Blue SA510 1 TB SSD (`sdb`) |
| Soğutma | NZXT Kraken 360mm LCD + 10× NZXT F120 RGB |
| PSU | NZXT C1000W |
| Kasa | NZXT H9 Flow Elite |

**İki donanım encode motoru mevcut:**
1. **NVENC** — RTX 3090 (ana iş gücü)
2. **Intel Quick Sync (QSV)** — i9-13900K içindeki UHD 770 iGPU (ikinci hat)

---

## 2. Erişim Bilgileri

| | |
|---|---|
| Hostname | `lmsrender` |
| Statik IP | `192.168.1.115/24` |
| Ağ geçidi | `192.168.1.1` |
| Kullanıcı | `volkan` (sudo yetkili, `docker` + `render` + `video` gruplarında) |
| Erişim | SSH: `ssh volkan@192.168.1.115` |
| Ağ arayüzü | `enp5s0` (2.5GbE, kablolu) |

> Parola ekip içi paylaşılır. İlk bağlantıda host key fingerprint sorulursa kabul edilir.

---

## 3. BIOS

| | |
|---|---|
| Sürüm | **7D91vHI** (`E7D91IMS.HI0`), build 03/17/2026 |
| Microcode | 0x12B üzeri (13900K kararlılık/degradasyon düzeltmeleri dahil) |

**Aktif edilen ayarlar:**
- Extreme Memory Profile (XMP) = Enabled → DDR5-5600
- Above 4G memory/Crypto Currency mining = Enabled
- Re-Size BAR Support = Enabled
- Intel Virtualization Technology (VT-x) = Enabled
- Intel VT-D Tech = Enabled
- Integrated Graphics = Enabled, Initiate Graphic Adapter = **IGD**
- Secure Boot = **Disabled** (NVIDIA DKMS imza derdini önlemek için)

> Monitör anakart HDMI/DP çıkışına bağlı; RTX 3090 tamamen compute/encode'a ayrılmıştır.

---

## 4. İşletim Sistemi

| | |
|---|---|
| Dağıtım | Ubuntu Server (kod adı **resolute**) |
| Çekirdek | 7.0.0-22-generic |
| SSH | OpenSSH server kurulu, açık |
| Klavye | Turkish Q |

**OS disk düzeni (PNY `nvme0n1`):**
- `nvme0n1p1` → `/boot/efi` (FAT32, 1 GB)
- `nvme0n1p2` → `/boot` (ext4, 2 GB)
- `nvme0n1p3` → LVM PV → `ubuntu-vg`
  - `ubuntu-lv` → `/` (ext4, **100 GB**)

> `ubuntu-vg` içinde ~828 GB boş alan var (root LV sadece 100 GB kullanıyor). Gerekirse `lvextend` + `resize2fs` ile `/` büyütülebilir, ancak veri `/mnt/storage`'a yazılacağı için gerekmez.

**Diğer 3 disk OS kurulumunda formatlanmadı, depolama havuzu için ayrıldı (Bölüm 6).**

---

## 5. Ağ Yapılandırması

Statik IP netplan ile sabitlendi. Dosya: `/etc/netplan/50-cloud-init.yaml` (izin `600`):

```yaml
network:
  version: 2
  ethernets:
    enp5s0:
      dhcp4: false
      addresses: [192.168.1.115/24]
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 1.1.1.1]
```

**Güvenlik duvarı:** UFW aktif, yalnızca OpenSSH açık.

---

## 6. Depolama Havuzu (mergerfs)

OS dışındaki 3 disk **ext4** olarak formatlanıp **mergerfs** ile tek havuzda birleştirildi.

| Cihaz | Boyut | Mount | Etiket | UUID |
|---|---|---|---|---|
| `sda1` (Seagate 2TB) | 1.8 TB | `/mnt/disk1` | disk1 | `0d9a2596-5528-4c83-bad8-fb0f6fb9a93e` |
| `sdb1` (WD Blue 1TB) | 916 GB | `/mnt/disk2` | disk2 | `0bcdd51c-77ce-4fa2-a095-d96ec0286fc9` |
| `nvme1n1p1` (SanDisk 1TB) | 916 GB | `/mnt/disk3` | disk3 | `14f06500-c78b-4515-83de-3b303e26293c` |

**Birleşik havuz:** `/mnt/storage` → **~3.6 TB** (mergerfs)

`/etc/fstab` ilgili satırlar:
```fstab
UUID=0d9a2596-5528-4c83-bad8-fb0f6fb9a93e  /mnt/disk1  ext4  defaults  0 2
UUID=0bcdd51c-77ce-4fa2-a095-d96ec0286fc9  /mnt/disk2  ext4  defaults  0 2
UUID=14f06500-c78b-4515-83de-3b303e26293c  /mnt/disk3  ext4  defaults  0 2
/mnt/disk1:/mnt/disk2:/mnt/disk3  /mnt/storage  fuse.mergerfs  defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true,minfreespace=20G,fsname=mergerfs  0 0
```

**Davranış / kısıtlar:**
- Her dosya tek bir fiziksel diskte durur (mergerfs file-level union).
- `category.create=mfs` → yeni dosyalar en boş diske yazılır.
- Tek bir dosya, indiği diskin boş alanından büyük olamaz (video dosyaları için sorun değil).
- **Yedeklilik yok** — bir disk arızalanırsa yalnızca o diskteki dosyalar kaybolur. Bu havuz bir çalışma/staging alanıdır; kaynak ve çıktı master'ı dedicated sunucuda tutulacaktır.

---

## 7. Kurulan Sürücüler & Runtime

### 7.1 NVIDIA Sürücü (NVENC/NVDEC)
- **Sürüm:** 610.43.02 (resmi NVIDIA CUDA deposundan `cuda-drivers`)
- DKMS ile çekirdeğe derlendi, Secure Boot kapalı (imza sorunu yok)
- CUDA UMD: 13.3
- `libnvidia-encode` (NVENC) + `libnvidia-decode` (NVDEC) kurulu
- **Host'a full CUDA toolkit kurulmadı** (transcode için gerekmez; GPU ölçekleme/CUDA filtresi gerekirse container imajında çözülecek)

Doğrulama: `nvidia-smi` → RTX 3090, 24576 MiB görünüyor ✅

### 7.2 Intel QSV / VAAPI
- Paketler: `intel-media-va-driver-non-free`, `libmfx-gen1.2`, `libvpl2`, `vainfo`, `intel-gpu-tools`
- Sürücü: **iHD** 26.1.2
- Encode desteği: **H264** (Main/High/Baseline), HEVC (Main/Main10/...), VP9
- `/etc/environment` içine `LIBVA_DRIVER_NAME=iHD` eklendi
- `~/.bashrc` içinde `vainfo` alias'ı renderD129'a yönlendirilmiş

### 7.3 ⚠️ KRİTİK — İki Render Node
Sistemde iki DRM render node var, **karıştırma:**

| Cihaz | Donanım | Kullanım |
|---|---|---|
| `/dev/dri/renderD128` | **NVIDIA RTX 3090** | NVENC (CUDA/NVENC üzerinden) |
| `/dev/dri/renderD129` | **Intel UHD 770 iGPU** | QSV (VAAPI/QSV üzerinden) |

> `vainfo` parametresiz çalıştırılırsa varsayılan olarak NVIDIA'nın VA sürücüsünü açmaya çalışıp hata verir. QSV için **mutlaka** `LIBVA_DRIVER_NAME=iHD` + `--device /dev/dri/renderD129` kullanılmalı.

### 7.4 Docker + NVIDIA Container Toolkit
- Docker: **29.5.3** (resmi `get.docker.com` script'i)
- `volkan` kullanıcısı `docker` grubunda
- NVIDIA Container Toolkit: **1.19.1**, `nvidia-ctk runtime configure --runtime=docker` çalıştırıldı, CDI spec üretildi
- Doğrulama: `docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi` → container içinden 3090 görünüyor ✅

---

## 8. Mevcut Sistem Durumu (Doğrulanmış)

| Bileşen | Durum | Doğrulama komutu |
|---|---|---|
| BIOS | vHI, ayarlar yapılmış | `sudo dmidecode -s bios-version` |
| OS / SSH | resolute, SSH aktif | `ssh volkan@192.168.1.115` |
| Statik IP | 192.168.1.115 sabit | `ip a show enp5s0` |
| Depolama havuzu | mergerfs ~3.6 TB | `df -h /mnt/storage` |
| NVIDIA / NVENC | 610.43.02, 3090 | `nvidia-smi` |
| Intel QSV | iHD, renderD129, H264 | `LIBVA_DRIVER_NAME=iHD vainfo --display drm --device /dev/dri/renderD129` |
| Docker | 29.5.3 | `docker version` |
| Container Toolkit | 1.19.1, GPU container'da | `docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi` |

**Donanım katmanı %100 hazırdır.** Aşağıdaki faz uygulama (LMS + transcode) katmanıdır.

---

## 9. SONRAKİ FAZ — Devralan İçin Yapılacaklar

### 9.1 Kaynak/Çıktı bağlantısı (dedicated sunucu)
Kaynak MP4'ler ve HLS çıktısı **ayrı bir dedicated sunucuda** duracak. Bu makine yalnızca transcode eder. NFS/CIFS istemci araçları kurulu (`nfs-common`, `cifs-utils`).

```bash
sudo mkdir -p /mnt/source /mnt/dest
# Örnek NFS:
sudo mount -t nfs <dedicated-ip>:/lms/source /mnt/source
sudo mount -t nfs <dedicated-ip>:/lms/hls    /mnt/dest
# Kalıcı için /etc/fstab'a ekle
```
İş akışı önerisi: `/mnt/source`'tan oku → `/mnt/storage`'da işle → `/mnt/dest`'e yaz → çalışma alanını temizle.

### 9.2 Transcode worker (Docker, FFmpeg)
Worker container içinde çalışacak. FFmpeg imajı NVENC ve/veya QSV destekli olmalı.

**⚠️ Container'da GPU encode için zorunlu ayarlar:**

**NVENC (3090) için** — Container Toolkit varsayılan olarak yalnızca `compute,utility` açar; **NVENC için `video` capability ŞART:**
```yaml
environment:
  - NVIDIA_VISIBLE_DEVICES=all
  - NVIDIA_DRIVER_CAPABILITIES=video,compute,utility   # 'video' olmazsa NVENC çalışmaz
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu, video]
```

**QSV (iGPU) için** — iGPU render node'unu geçir:
```yaml
devices:
  - /dev/dri/renderD129:/dev/dri/renderD129    # Intel iGPU (128 DEĞİL)
group_add: [render, video]
environment:
  - LIBVA_DRIVER_NAME=iHD
```

### 9.3 HLS Pipeline (720p + 480p)
**Codec = H.264** (LMS'te her cihaz/tarayıcı oynatsın; HEVC kullanma — sadece Safari oynatır).

**NVENC ile (ana hat) — 720p + 480p ABR:**
```bash
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i /mnt/source/in.mp4 \
  -filter_complex "[0:v]split=2[a][b]; \
    [a]scale_npp=1280:720[v1]; \
    [b]scale_npp=854:480[v2]" \
  -map "[v1]" -c:v:0 h264_nvenc -preset:v:0 p5 -b:v:0 3M  -maxrate:v:0 3.3M -bufsize:v:0 6M \
  -map "[v2]" -c:v:1 h264_nvenc -preset:v:1 p5 -b:v:1 1.5M -maxrate:v:1 1.6M -bufsize:v:1 3M \
  -map a:0 -c:a:0 aac -b:a:0 128k \
  -map a:0 -c:a:1 aac -b:a:1 96k \
  -f hls -hls_time 6 -hls_playlist_type vod -hls_flags independent_segments \
  -hls_segment_filename "/mnt/dest/%v/seg_%03d.ts" \
  -master_pl_name master.m3u8 \
  -var_stream_map "v:0,a:0 v:1,a:1" \
  "/mnt/dest/%v/playlist.m3u8"
```

**QSV ile (ikinci hat, paralel kapasite):**
```bash
ffmpeg -hwaccel qsv -qsv_device /dev/dri/renderD129 -c:v h264_qsv -i /mnt/source/in.mp4 \
  -vf "scale_qsv=w=1280:h=720" -c:v h264_qsv -b:v 3M \
  -c:a aac -b:a 128k -f hls -hls_time 6 -hls_playlist_type vod \
  -hls_segment_filename "/mnt/dest/720/seg_%03d.ts" "/mnt/dest/720/playlist.m3u8"
```

### 9.4 Paralellik & throughput
- **NVENC oturum limiti:** GeForce kartlarında eşzamanlı NVENC oturumu sınırlıdır. Çok paralel iş kuyruğunda `OpenEncodeSessionEx failed` alınırsa **keylase nvidia-patch** uygulanmalı (https://github.com/keylase/nvidia-patch). Sürücü her güncellendiğinde tekrar uygulanır.
- **Hat dağıtımı:** kuyruğun büyük kısmını NVENC worker'larına, taşanı QSV worker'ına yönlendir. İzleme: `nvidia-smi dmon -s u` (NVENC) + `intel_gpu_top` (QSV).
- VRAM (24 GB) darboğaz değil; 3090'ın tek NVENC bloğu ~6-10 eşzamanlı 1080p işte doyar.

### 9.5 Codec destek özeti (3090 NVENC)
| İşlem | Destek |
|---|---|
| H.264 encode | ✅ (HLS için bunu kullan) |
| HEVC encode | ✅ (LMS web için önerilmez) |
| AV1 encode | ❌ (RTX 40+ gerekir; gerekirse CPU/SVT-AV1) |
| H264/HEVC/VP9/AV1 decode | ✅ |

---

## 10. Önemli Notlar & Uyarılar

- **Render node karışıklığı:** QSV = `renderD129`, NVENC/CUDA = `renderD128`. Yanlış cihaz seçilirse QSV/NVENC çalışmaz.
- **mergerfs yedeksiz:** kritik veri burada kalıcı tutulmaz; master dedicated sunucuda.
- **CUDA filtreleri:** `scale_npp`/`scale_cuda` kullanan FFmpeg imajları NPP/CUDA destekli derlenmiş olmalı (`jrottenberg/ffmpeg:*-nvidia` gibi). Aksi halde CPU `scale` kullanılır.
- **Secure Boot kapalı:** sürücü güncellemelerinde DKMS yeniden derlenir, imza sorunu çıkmaz.
- **OS Ubuntu resolute (26.04):** NVIDIA deposu olarak `ubuntu2404` kullanıldı; 3090 için sorunsuz çalışıyor. Sürücü güncellemelerinde aynı repo geçerli.

---

## 11. Hızlı Sağlık / Doğrulama Komutları

```bash
# Sistem
ip a show enp5s0                  # statik IP
df -h /mnt/storage                # depolama havuzu
free -h && nproc                  # RAM / çekirdek

# GPU (NVENC)
nvidia-smi                        # 3090 durumu
nvidia-smi dmon -s u              # encode/decode utilization (canlı)

# iGPU (QSV)
LIBVA_DRIVER_NAME=iHD vainfo --display drm --device /dev/dri/renderD129
intel_gpu_top                     # iGPU utilization

# Docker / GPU container
docker version
docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi

# Disk sağlığı
sudo nvme smart-log /dev/nvme0
sensors
```

---

## 12. Özet — Hazır Olan / Olmayan

**HAZIR (bu belgede tamamlandı):**
Donanım, BIOS, Ubuntu Server, statik ağ, mergerfs depolama havuzu, NVIDIA sürücü + NVENC, Intel QSV, Docker, NVIDIA Container Toolkit — hepsi kurulu ve doğrulanmış.

**YAPILACAK (devralan):**
1. Dedicated sunucu kaynak/çıktı mount'u (NFS/CIFS)
2. LMS projesinin kurulması
3. Transcode worker container'ları (FFmpeg NVENC + QSV, `video` capability + `renderD129` passthrough ile)
4. MP4 → HLS (720p + 480p, H.264) pipeline
5. Kuyruk/paralellik ve gerekirse NVENC session patch
