CREATE DATABASE Yurt;
GO

USE Yurt;
GO


-- ============================================================================
-- ODA TABLOSU
-- ============================================================================
CREATE TABLE Oda(
    oda_id SMALLINT PRIMARY KEY,                    
    oda_no SMALLINT NOT NULL,                       
    kapasite TINYINT NOT NULL CHECK(kapasite > 0),  -- Odanýn maksimum öðrenci kapasitesi
    doluluk TINYINT NOT NULL DEFAULT 0 CHECK(doluluk >= 0), -- Mevcut öðrenci sayýsý
    kat_no TINYINT NOT NULL
    
    -- Oda numarasý ve kat kombinasyonu benzersiz olmalý
    CONSTRAINT uq_oda_no_kat UNIQUE(oda_no, kat_no)
);
GO

-- ============================================================================
-- ÖÐRENCÝ TABLOSU
-- ============================================================================
CREATE TABLE Öðrenci(
    ogrenci_id SMALLINT PRIMARY KEY IDENTITY(1,1),         -- Otomatik artan öðrenci kimliði
    ad VARCHAR(20) NOT NULL,                                
    soyad VARCHAR(20) NOT NULL,                            
    tcno CHAR(11) UNIQUE NOT NULL,                          
    telefon VARCHAR(15) UNIQUE NOT NULL,                    
    dogum_tarihi DATE,      
    oda_id SMALLINT NOT NULL,                               -- Atandýðý oda (foreign key)
    kayit_tarihi DATE NOT NULL,           
    durum BIT NOT NULL DEFAULT 1,                           -- Aktif/Pasif durum (1=Aktif, 0=Pasif)
    
    -- Oda referansý
    CONSTRAINT fk_ogr_oda FOREIGN KEY (oda_id) REFERENCES Oda(oda_id),
    
);
GO

-- ============================================================================
-- PERSONEL TABLOSU
-- ============================================================================
CREATE TABLE Personel(
    personel_id SMALLINT PRIMARY KEY IDENTITY(1,1),    -- Otomatik artan personel kimliði
    ad VARCHAR(20) NOT NULL,                            
    soyad VARCHAR(20) NOT NULL,                         
    tcno CHAR(11) UNIQUE NOT NULL,                      
    telefon VARCHAR(15) UNIQUE NOT NULL,                
    gorev VARCHAR(50) NOT NULL,                         -- Görev tanýmý
    ise_baslama_tarihi DATE NOT NULL,                   -- Ýþe baþlama tarihi
    aktif BIT NOT NULL DEFAULT 1,                       -- Çalýþma durumu (1=Aktif, 0=Ýþten ayrýlmýþ)
);
GO

-- ============================================================================
-- ÖDEME TABLOSU
-- ============================================================================
CREATE TABLE Ödeme(
    odeme_id INT PRIMARY KEY IDENTITY(1,1),             
    ogrenci_id SMALLINT NOT NULL,                       
    odeme_turu VARCHAR(50) NOT NULL,                    -- Ödeme türü (Yatak Bedeli, Yemek, vs.)
    tutar DECIMAL(10,2) NOT NULL CHECK(tutar > 0),      
    tarih DATETIME NOT NULL,          
    durum BIT NOT NULL DEFAULT 1,                       -- Ödeme durumu (1=Ödendi, 0=Ýptal)
    aciklama VARCHAR(200),                              
    
    -- Öðrenci referansý
    CONSTRAINT fk_odeme_ogr FOREIGN KEY (ogrenci_id) REFERENCES Öðrenci(ogrenci_id)
);
GO

/*
================================================================================
ÖRNEK VERÝ EKLEME
================================================================================
*/

-- Oda kayýtlarý
INSERT INTO Oda(oda_id, oda_no, kapasite, kat_no, doluluk)
VALUES 
    (1, 101, 4, 1, 0),
    (2, 102, 4, 1, 0),
    (3, 201, 2, 2, 0),
    (4, 202, 2, 2, 0);
GO

-- Öðrenci kaydý
INSERT INTO Öðrenci(ad, soyad, tcno, telefon, dogum_tarihi, oda_id, kayit_tarihi, durum)
VALUES ('Cevat Can', 'Aygüler', '11111111110', '05555555555', '2003-05-28', 1, '2025-01-01', 1);
GO

-- Oda doluluk durumunu güncelle
UPDATE Oda SET doluluk = 1 WHERE oda_id = 1;
GO

-- Personel kaydý
INSERT INTO Personel(ad, soyad, tcno, telefon, gorev, ise_baslama_tarihi)
VALUES 
    ('Ali', 'Veli', '11111111112', '05555555556', 'Temizlik Görevlisi','2000-01-01'),
    ('Ayþe', 'Demir', '11111111113', '05555555557', 'Yemekhane Sorumlusu','2000-01-01');
GO

-- Ödeme kaydý
INSERT INTO Ödeme(ogrenci_id, tutar, tarih, odeme_turu, durum, aciklama)
VALUES (1, 1000.00, '2025-01-01 10:30:00', 'Yatak Bedeli', 1, 'Ocak ayý konaklama ücreti');
GO

/*
================================================================================
KONTROL SORULARI
================================================================================
*/

-- Tüm tablolarýn içeriðini görüntüle
SELECT * FROM Oda ORDER BY kat_no, oda_no;
SELECT * FROM Öðrenci ORDER BY kayit_tarihi DESC;
SELECT * FROM Personel ORDER BY gorev, ad;
SELECT * FROM Ödeme ORDER BY tarih DESC;

-- Boþ odalar listesi
SELECT 
    oda_no AS 'Oda No',
    kat_no AS 'Kat',
    kapasite AS 'Kapasite',
    (kapasite - doluluk) AS 'Boþ Yatak Sayýsý'
FROM Oda
WHERE doluluk < kapasite
ORDER BY kat_no, oda_no;
GO
