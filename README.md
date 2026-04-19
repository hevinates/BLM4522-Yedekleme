# PostgreSQL Automated Backup & Disaster Recovery Framework

Bu proje; ağ tabanlı paralel ve dağıtık sistemlerde veri bütünlüğünü korumak ve olası veri kayıplarını minimize etmek amacıyla geliştirilmiş, **yüksek hacimli (150.000+ kayıt)** bir yedekleme ve felaketten kurtarma (Disaster Recovery) çözümüdür. Sistem, macOS tabanlı PostgreSQL 15/16 ortamı için optimize edilmiştir.

---

## Proje Öne Çıkanlar

- **Large-Scale Dataset:** 100.000 kitap ve 50.000 üye kaydından oluşan, stres testlerine uygun sentetik veri kümesi.
- **Automated Snapshotting:** `pg_dump` yardımcı programı kullanılarak Crontab üzerinden yönetilen otonom yedekleme döngüsü.
- **Disaster Simulation:** Kasti veritabanı imhası (Drop Database) senaryolarına karşı test edilmiş hızlı restorasyon protokolleri.
- **Logging & Auditing:** Yedekleme süreçlerinin başarısını ve hata durumlarını anlık olarak takip eden günlükleme sistemi.

---

## 📂 Proje Yapısı

| Klasör | Teknik İçerik |
|--------|---------------|
| `sql_scripts/` | Veritabanı şeması, 150.000 kayıt üreten PL/pgSQL döngüleri ve Full Backup çıktıları |
| `other_scripts/` | macOS ortamı için optimize edilmiş, hata denetimi yapan Bash yedekleme scriptleri |
| `configs/` | Crontab zamanlayıcı parametreleri ve sistem bazlı yol (path) yapılandırmaları |
| `screenshots/` | Restorasyon başarısını, veri yoğunluğunu ve otomasyonu kanıtlayan teknik çıktılar |
| `logs/` | Operasyonel sürekliliğin takibi için oluşturulan sistem günlükleri |

---

## 🛠 Kurulum ve Devreye Alma

### 1. Veri Setinin İnşası

Sistemi ayağa kaldırmak ve sentetik verileri üretmek için:

```bash
psql -U postgres -d KutuphaneDB -f sql_scripts/setup_db.sql
```

---

### 2. Otonom Zamanlayıcı (Crontab) Yapılandırması

Sistemin her gece saat 00:00'da otomatik yedek alması için:

```bash
0 0 * * * /opt/homebrew/bin/pg_dump -U postgres -d KutuphaneDB > ~/Desktop/Veritabani_Projesi/Yedekleme_ve_Kurtarma/sql_scripts/kutuphane_full_yedek.sql >> ~/Desktop/Veritabani_Projesi/Yedekleme_ve_Kurtarma/logs/backup.log 2>&1
```

---

### 3. Manuel Yedekleme ve Doğrulama

Otomasyon dışı durumlar için:

```bash
sh other_scripts/manual_backup.sh
```

---

## Felaketten Kurtarma Protokolü (Disaster Recovery)

Proje kapsamında uygulanan operasyonel test adımları:

- **İmha:**
```sql
DROP DATABASE KutuphaneDB;
```

- **Tespit:**  
Uygulama katmanında bağlantı hataları ve veri eksikliği raporlanmıştır.

- **Restorasyon:**  
Arşivlenen son Full Backup dosyası, `psql` aracıyla saniyeler içerisinde geri yüklenmiştir.

- **Sonuç:**  
Veri kaybı %0 seviyesinde tutularak sistem tekrar kararlı hale getirilmiştir.

---

## Karşılaşılan Teknik Zorluklar ve Çözümler

### Hata:
macOS güvenlik kısıtlamaları (SIP) sebebiyle Crontab'ın dosya yazma yetkisinin engellenmesi.

### Çözüm:
Terminal'e **Full Disk Access** yetkisi atanmış ve script içerisinde mutlak dosya yolları kullanılmıştır.

---

### Hata:
100.000+ kayıt yüklemesi sırasında oluşan bellek darboğazı.

### Çözüm:
INSERT blokları yerine PostgreSQL'in `COPY` protokolü ve döngüsel işlem optimizasyonu uygulanmıştır.
