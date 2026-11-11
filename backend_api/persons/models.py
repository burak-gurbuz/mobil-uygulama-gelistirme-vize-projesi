# -*- coding: utf-8 -*-
# models.py - Veritabanı modellerinin tanımlandığı dosyadır.
# Model, veritabanındaki bir tablonun Python karşılığıdır.
# Her model sınıfı bir tablo, her alan (field) bir sütun oluşturur.
# Django bu modelleri kullanarak SQL komutlarını otomatik oluşturur.

from django.db import models  # Django'nun veritabanı modelleme modülünü içe aktarıyoruz.


class Person(models.Model):
    """
    Kişi modeli - Veritabanında 'persons_person' adında bir tablo oluşturur.
    Bu tablo, kişilerin bilgilerini saklar (ad, departman, telefon, email vb.).
    Her bir satır bir kişi kaydını temsil eder.
    """

    # fullName alanı: Kişinin tam adını ve soyadını saklar.
    # CharField, kısa metin verisi saklamak için kullanılır.
    # max_length=200 en fazla 200 karakter girilebileceğini belirtir.
    # verbose_name, admin panelinde görünen Türkçe etiket adıdır.
    fullName = models.CharField(
        max_length=200,            # Bu alana en fazla 200 karakter yazılabilir.
        verbose_name='Ad Soyad'    # Admin panelinde bu alan "Ad Soyad" olarak görünür.
    )

    # department alanı: Kişinin çalıştığı departmanı saklar.
    # Örnek: "Yazılım Geliştirme", "İnsan Kaynakları" gibi.
    department = models.CharField(
        max_length=200,              # Bu alana en fazla 200 karakter yazılabilir.
        verbose_name='Departman'     # Admin panelinde bu alan "Departman" olarak görünür.
    )

    # photoUrl alanı: Kişinin fotoğraf bağlantısını (URL) saklar.
    # URLField, geçerli bir web adresi formatını kontrol eder.
    # blank=True ve null=True bu alanın boş bırakılabileceği anlamına gelir.
    # Yani fotoğraf eklenmek zorunda değildir.
    photoUrl = models.URLField(
        max_length=500,              # URL en fazla 500 karakter olabilir.
        blank=True,                  # Formda bu alan boş bırakılabilir.
        null=True,                   # Veritabanında bu alan NULL (boş) olabilir.
        verbose_name='Fotoğraf URL'  # Admin panelinde bu alan "Fotoğraf URL" olarak görünür.
    )

    # birthPlace alanı: Kişinin doğum yerini saklar.
    # Örnek: "İstanbul", "Ankara", "Adana" gibi.
    birthPlace = models.CharField(
        max_length=100,              # Bu alana en fazla 100 karakter yazılabilir.
        verbose_name='Doğum Yeri'    # Admin panelinde bu alan "Doğum Yeri" olarak görünür.
    )

    # birthDate alanı: Kişinin doğum tarihini saklar.
    # DateField, tarih verisi (yıl-ay-gün) saklamak için kullanılır.
    # Örnek format: "1994-04-12" (Yıl-Ay-Gün).
    birthDate = models.DateField(
        verbose_name='Doğum Tarihi'  # Admin panelinde bu alan "Doğum Tarihi" olarak görünür.
    )

    # email alanı: Kişinin e-posta adresini saklar.
    # EmailField, geçerli bir e-posta formatını kontrol eder (@ işareti olmalı vb.).
    email = models.EmailField(
        max_length=254,          # E-posta adresi en fazla 254 karakter olabilir (standart limit).
        verbose_name='E-posta'   # Admin panelinde bu alan "E-posta" olarak görünür.
    )

    # phone alanı: Kişinin telefon numarasını saklar.
    # CharField kullanıyoruz çünkü telefon numarası + işareti içerebilir.
    # Örnek: "+905550123456".
    phone = models.CharField(
        max_length=20,           # Telefon numarası en fazla 20 karakter olabilir.
        verbose_name='Telefon'   # Admin panelinde bu alan "Telefon" olarak görünür.
    )

    class Meta:
        """
        Meta sınıfı - Modelin genel ayarlarını belirler.
        Tablo adı, sıralama düzeni gibi ayarlar burada yapılır.
        """
        verbose_name = 'Kişi'          # Admin panelinde tekil ad (bir kayıt için).
        verbose_name_plural = 'Kişiler'  # Admin panelinde çoğul ad (liste için).
        ordering = ['id']              # Kayıtlar ID'ye göre sıralanır (küçükten büyüğe).

    def __str__(self):
        """
        Bu metot, bir kişi nesnesi yazdırıldığında veya admin panelinde gösterildiğinde
        ne görüneceğini belirler. Kişinin tam adını döndürür.
        Örnek: print(kisi) → "Ahmet Yılmaz"
        """
        return self.fullName  # Kişi nesnesini metin olarak gösterirken adını kullan.
