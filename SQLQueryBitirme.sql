-- 1. Musteri tablosu
CREATE TABLE Musteri (
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL CHECK(LEN(ad) >= 2),
  soyad NVARCHAR(50) NOT NULL CHECK(LEN(soyad) >= 2),
  email NVARCHAR(50) NOT NULL UNIQUE,
  sehir NVARCHAR(20) NOT NULL,
  kayit_tarihi DATE DEFAULT CAST(GETDATE() AS DATE)
);

-- 2. Kategori tablosu
CREATE TABLE Kategori (
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL UNIQUE
);

-- 3. Satici tablosu
CREATE TABLE Satici (
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL CHECK(LEN(ad) >= 2),
  adres NVARCHAR(50) NOT NULL
);

-- 4. Urun tablosu
CREATE TABLE Urun (
  id INT IDENTITY(1,1) PRIMARY KEY,
  ad NVARCHAR(50) NOT NULL UNIQUE,
  fiyat DECIMAL(10,2) NOT NULL CHECK(fiyat > 0),
  stok INT NOT NULL CHECK(stok >= 0),
  kategori_id INT NOT NULL FOREIGN KEY REFERENCES Kategori(id),
  satici_id INT NOT NULL FOREIGN KEY REFERENCES Satici(id)
);

-- 5. Siparis tablosu
CREATE TABLE Siparis (
  id INT IDENTITY(1,1) PRIMARY KEY,
  musteri_id INT NOT NULL FOREIGN KEY REFERENCES Musteri(id),
  tarih DATE DEFAULT CAST(GETDATE() AS DATE),
  toplam_tutar DECIMAL(10,2) NOT NULL CHECK(toplam_tutar >= 0),
  odeme_turu NVARCHAR(10) NOT NULL CHECK(odeme_turu IN ('Nakit', 'Kart', 'Havale'))
);

-- 6. Siparis_Detay tablosu
CREATE TABLE Siparis_Detay (
  id INT IDENTITY(1,1) PRIMARY KEY,
  siparis_id INT NOT NULL FOREIGN KEY REFERENCES Siparis(id),
  urun_id INT NOT NULL FOREIGN KEY REFERENCES Urun(id),
  adet INT NOT NULL CHECK(adet > 0),
  fiyat DECIMAL(10,2) NOT NULL CHECK(fiyat > 0)
);


INSERT INTO Musteri (ad, soyad, email, sehir) VALUES
('Ali', 'Yýlmaz', 'ali@example.com', 'Ankara'),
('Ayþe', 'Kaya', 'ayse@example.com', 'Ýstanbul'),
('Mehmet', 'Demir', 'mehmet@example.com', 'Ýzmir'),
('Fatma', 'Çelik', 'fatma@example.com', 'Bursa'),
('Can', 'Arslan', 'can@example.com', 'Antalya'),
('Zeynep', 'Koç', 'zeynep@example.com', 'Eskiþehir'),
('Ahmet', 'Þahin', 'ahmet@example.com', 'Konya'),
('Elif', 'Aydýn', 'elif@example.com', 'Adana'),
('Burak', 'Yýldýz', 'burak@example.com', 'Trabzon'),
('Seda', 'Kurt', 'seda@example.com', 'Kayseri'),
('Mert', 'Polat', 'mert@example.com', 'Samsun'),
('Hale', 'Güneþ', 'hale@example.com', 'Mersin'),
('Emre', 'Aksoy', 'emre@example.com', 'Diyarbakýr'),
('Buse', 'Erdoðan', 'buse@example.com', 'Van'),
('Deniz', 'Karaca', 'deniz@example.com', 'Gaziantep');

INSERT INTO Kategori (ad) VALUES
('Elektronik'),
('Kitap'),
('Ev Eþyalarý');


INSERT INTO Satici (ad, adres) VALUES
('TeknoMarket', 'Ýstanbul'),
('KitapEv', 'Ýzmir'),
('EvDekor', 'Bursa');


INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES
('Laptop', 20000.00, 10, 1, 1),
('Telefon', 12000.00, 20, 1, 1),
('Tablet', 8000.00, 15, 1, 1),
('Roman Kitabý', 150.00, 50, 2, 2),
('Tarih Kitabý', 200.00, 30, 2, 2),
('Yastýk', 100.00, 40, 3, 3),
('Battaniye', 300.00, 25, 3, 3),
('Çaydanlýk', 250.00, 35, 3, 3),
('Bluetooth Kulaklýk', 750.00, 60, 1, 1),
('Masa Lambasý', 400.00, 20, 3, 3);


-- Ali
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (1, 20750.00, 'Kart');

-- Ayþe
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (2, 950.00, 'Nakit');

-- Mehmet
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (3, 16150.00, 'Havale');

-- Sipariþ  Ali 
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES 
(1, 1, 1, 20000.00),
(1, 9, 1, 750.00);  

-- Sipariþ Ayþe
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES 
(2, 4, 2, 150.00),
(2, 5, 1, 200.00),
(2, 6, 1, 100.00);

-- Sipariþ Mehmet
INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES 
(3, 2, 1, 12000.00),
(3, 3, 1, 8000.00);

--Stok Azaltma

UPDATE Urun SET stok = stok - 1 WHERE id = 1;
UPDATE Urun SET stok = stok - 1 WHERE id = 9;

UPDATE Urun SET stok = stok - 2 WHERE id = 4;  
UPDATE Urun SET stok = stok - 1 WHERE id = 5;
UPDATE Urun SET stok = stok - 1 WHERE id = 6;

UPDATE Urun SET stok = stok - 1 WHERE id = 2;
UPDATE Urun SET stok = stok - 1 WHERE id = 3;



DELETE FROM Urun WHERE stok = 0;

TRUNCATE TABLE Urun;

-- En çok sipariþ veren 5 müþteri.
select top 5 Musteri.id, Musteri.ad, Musteri.soyad, count(Siparis.id) as Siparis_Sayisi from Musteri 
join Siparis on Musteri.id = Siparis.musteri_id
group by Musteri.id, Musteri.ad, Musteri.soyad
order by Siparis_Sayisi desc;

-- En çok satýlan ürünler.
select Urun.id, Urun.ad, sum(Siparis_Detay.adet) as Total_Satis
from Urun
join Siparis_Detay on Urun.id = Siparis_Detay.urun_id
group by Urun.id, Urun.ad
order by Total_Satis desc;

-- En yüksek cirosu olan satýcýlar.
select Satici.id, Satici.ad, sum(Siparis_Detay.adet * Siparis_Detay.fiyat) as Total_Ciro
from Satici
join Urun on Satici.id = Urun.satici_id
join Siparis_Detay on Siparis_Detay.urun_id = Urun.id
group by Satici.id, Satici.ad
order by Total_Ciro desc;

-- Þehirlere göre müþteri sayýsý.
select sehir, count(*) as Müþteri_Sayisi
from Musteri
group by sehir
order by Müþteri_Sayisi desc;

-- Kategori bazlý toplam satýþlar.
select Kategori.id,	Kategori.ad, sum(Siparis_Detay.adet * Siparis_Detay.fiyat) as Total_Satýþ
from Kategori
join Urun on Urun.kategori_id = Kategori.id
join Siparis_Detay on Siparis_Detay.urun_id = Urun.id
group by Kategori.id, Kategori.ad
order by Total_Satýþ desc;

-- Aylara göre sipariþ sayýsý.
select year(tarih) as YIL, month(tarih) as AY, count(*) as Sipariþ_Sayýsý
from Siparis
group by year(tarih), month(tarih)
order by YIL, AY;

-- Sipariþlerde müþteri bilgisi + ürün bilgisi + satýcý bilgisi.
select Siparis.id, Musteri.ad, Musteri.soyad, Urun.ad, Satici.ad
from Siparis
join Musteri on Musteri.id = Siparis.musteri_id
join Siparis_Detay on Siparis_Detay.siparis_id = Siparis.id
join Urun on Siparis_Detay.id = Urun.id
join Satici on Satici.id = Urun.satici_id;

-- Hiç satýlmamýþ ürünler.
select Urun.id, Urun.ad
from Urun
left join Siparis_Detay on Urun.id = Siparis_Detay.urun_id
where Siparis_Detay.id is null;

-- Hiç sipariþ vermemiþ müþteriler.
select Musteri.id, Musteri.ad, Musteri.soyad
from Musteri
left join Siparis on Siparis.musteri_id = Musteri.id
where Siparis.id is null;