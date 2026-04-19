-- Tablo Şemalarının Oluşturulması
DROP TABLE IF EXISTS Kitaplar CASCADE;
DROP TABLE IF EXISTS Uyeler CASCADE;

CREATE TABLE Kitaplar (
    id SERIAL PRIMARY KEY,
    baslik VARCHAR(255),
    yazar VARCHAR(255),
    stok_sayisi INTEGER,
    eklenme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Uyeler (
    id SERIAL PRIMARY KEY,
    ad_soyad VARCHAR(255),
    eposta VARCHAR(255),
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN
   FOR i IN 1..100000 LOOP
      INSERT INTO Kitaplar (baslik, yazar, stok_sayisi) 
      VALUES ('Mühendislik Kitabı Vol ' || i, 'Yazar Kodu: ' || i, (floor(random() * 50) + 1)::INT);
   END LOOP;
END;
$$;

DO $$
BEGIN
   FOR i IN 1..50000 LOOP
      INSERT INTO Uyeler (ad_soyad, eposta) 
      VALUES ('Ogrenci Kayit ' || i, 'ogrenci' || i || '@universite.edu.tr');
   END LOOP;
END;
$$;
