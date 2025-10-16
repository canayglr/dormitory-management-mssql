# 🏢 Yurt Yönetim Sistemi

Öğrenci yurtlarının etkin yönetimi için geliştirilmiş kapsamlı bir veritabanı sistemi.

## 📋 İçindekiler

- [Genel Bakış](#genel-bakış)
- [Özellikler](#özellikler)
- [Veritabanı Şeması](#veritabanı-şeması)
- [Kurulum](#kurulum)
- [Kullanım](#kullanım)
- [Tablolar](#tablolar)

## 🎯 Genel Bakış

Bu proje, öğrenci yurtlarında oda yönetimi, öğrenci kayıtları, personel takibi ve ödeme işlemlerini tek bir sistemde birleştiren MSSQL tabanlı bir veritabanı çözümüdür.

### Teknolojiler

- **DBMS:** Microsoft SQL Server


## ✨ Özellikler

- ✅ **Oda Yönetimi:** Oda kapasitesi, doluluk durumu ve kat bilgilerini takip
- ✅ **Öğrenci Kayıt Sistemi:** Kapsamlı öğrenci bilgileri ve durum takibi
- ✅ **Personel Yönetimi:** Çalışan bilgileri ve görev tanımları
- ✅ **Ödeme Takibi:** Detaylı ödeme kayıtları ve raporlama
- ✅ **Veri Bütünlüğü:** Foreign key kısıtlamaları ve CHECK constraint'leri

## 🗂️ Veritabanı Şeması

```
Yurt
│
├── Oda
│   ├── oda_id (PK)
│   ├── oda_no
│   ├── kapasite
│   ├── doluluk
│   └── kat_no
│
├── Öğrenci
│   ├── ogrenci_id (PK)
│   ├── ad
│   ├── soyad
│   ├── tcno (UNIQUE)
│   ├── telefon (UNIQUE)
│   ├── dogum_tarihi
│   ├── oda_id (FK → Oda)
│   ├── kayit_tarihi
│   └── durum
│
├── Personel
│   ├── personel_id (PK)
│   ├── ad
│   ├── soyad
│   ├── tcno (UNIQUE)
│   ├── telefon (UNIQUE)
│   ├── gorev
│   ├── ise_baslama_tarihi
│   └── aktif
│
└── Ödeme
    ├── odeme_id (PK)
    ├── ogrenci_id (FK → Öğrenci)
    ├── odeme_turu
    ├── tutar
    ├── tarih
    ├── durum
    └── aciklama
```

## 🚀 Kurulum

### Gereksinimler

- Microsoft SQL Server 2016 veya üzeri
- SQL Server Management Studio (SSMS) önerilir

### Adımlar

1. **Repoyu klonlayın:**
```bash
git clone https://github.com/canayglr/MSSQL-Yurt-Takip-Sistemi
cd MSSQL-Yurt-Takip-Sistemi
```

2. **SQL Server'a bağlanın:**
   - SSMS'i açın
   - SQL Server instance'ınıza bağlanın

3. **Script'i çalıştırın:**
   - `yurt_database.sql` dosyasını SSMS'de açın
   - F5 tuşuna basarak tüm script'i çalıştırın

4. **Veritabanını doğrulayın:**
```sql
USE Yurt;
SELECT * FROM Oda;
SELECT * FROM Öğrenci;
SELECT * FROM Personel;
SELECT * FROM Ödeme;
```

## 💻 Kullanım

### Yeni Öğrenci Kaydı

```sql
INSERT INTO Öğrenci(ad, soyad, tcno, telefon, dogum_tarihi, oda_id, kayit_tarihi)
VALUES ('Ahmet', 'Yılmaz', '12345678901', '05551234567', '2002-03-15', 2, GETDATE());

-- Oda doluluk durumunu güncelle
UPDATE Oda SET doluluk = doluluk + 1 WHERE oda_id = 2;
```

### Yeni Ödeme Kaydı

```sql
INSERT INTO Ödeme(ogrenci_id, odeme_turu, tutar, tarih, aciklama)
VALUES (1, 'Yatak Bedeli', 1500.00, GETDATE(), 'Şubat ayı konaklama ücreti');
```

### Yeni Personel Kaydı

```sql
INSERT INTO Personel(ad, soyad, tcno, telefon, gorev, ise_baslama_tarihi)
VALUES ('Mehmet', 'Kaya', '98765432101', '05559876543', 'Güvenlik Görevlisi', GETDATE());
```

## 📊 Tablolar

### Oda Tablosu
Yurttaki odaların fiziksel özelliklerini ve doluluk durumunu saklar.

| Alan | Tip | Açıklama |
|------|-----|----------|
| oda_id | SMALLINT | Benzersiz oda kimliği (Primary Key) |
| oda_no | SMALLINT | Oda numarası |
| kapasite | TINYINT | Maksimum öğrenci kapasitesi |
| doluluk | TINYINT | Mevcut öğrenci sayısı |
| kat_no | TINYINT | Kat numarası |

**Kısıtlamalar:**
- `oda_no` ve `kat_no` kombinasyonu benzersiz olmalı
- `kapasite > 0` olmalı
- `doluluk >= 0` olmalı

### Öğrenci Tablosu
Yurtta kalan öğrencilerin bilgilerini içerir.

| Alan | Tip | Açıklama |
|------|-----|----------|
| ogrenci_id | SMALLINT | Otomatik artan kimlik (Primary Key) |
| ad | VARCHAR(20) | Öğrencinin adı |
| soyad | VARCHAR(20) | Öğrencinin soyadı |
| tcno | CHAR(11) | TC Kimlik Numarası (Benzersiz) |
| telefon | VARCHAR(15) | Telefon numarası (Benzersiz) |
| dogum_tarihi | DATE | Doğum tarihi |
| oda_id | SMALLINT | Atandığı oda (Foreign Key) |
| kayit_tarihi | DATE | Yurda kayıt tarihi |
| durum | BIT | Aktif/Pasif (1=Aktif, 0=Pasif) |

### Personel Tablosu
Yurtta çalışan personelin bilgilerini tutar.

| Alan | Tip | Açıklama |
|------|-----|----------|
| personel_id | SMALLINT | Otomatik artan kimlik (Primary Key) |
| ad | VARCHAR(20) | Personelin adı |
| soyad | VARCHAR(20) | Personelin soyadı |
| tcno | CHAR(11) | TC Kimlik Numarası (Benzersiz) |
| telefon | VARCHAR(15) | Telefon numarası (Benzersiz) |
| gorev | VARCHAR(50) | Görev tanımı |
| ise_baslama_tarihi | DATE | İşe başlama tarihi |
| aktif | BIT | Çalışma durumu (1=Aktif, 0=Pasif) |

### Ödeme Tablosu
Öğrencilerin yaptığı ödemelerin kaydını saklar.

| Alan | Tip | Açıklama |
|------|-----|----------|
| odeme_id | INT | Otomatik artan kimlik (Primary Key) |
| ogrenci_id | SMALLINT | Ödemeyi yapan öğrenci (Foreign Key) |
| odeme_turu | VARCHAR(50) | Ödeme türü |
| tutar | DECIMAL(10,2) | Ödeme tutarı |
| tarih | DATETIME | Ödeme tarihi ve saati |
| durum | BIT | Ödeme durumu (1=Ödendi, 0=İptal) |
| aciklama | VARCHAR(200) | Ek açıklamalar |