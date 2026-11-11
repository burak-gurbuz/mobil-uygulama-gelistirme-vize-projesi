# -*- coding: utf-8 -*-
# serializers.py - Serileştirici (Serializer) dosyasıdır.
# Serializer, veritabanındaki Python nesnelerini JSON formatına çevirir (serileştirme).
# Ayrıca gelen JSON verisini Python nesnesine çevirir (ters serileştirme).
# API ile veri alışverişi JSON formatında yapılır, bu yüzden serializer gereklidir.
# Kısaca: Python nesnesi <-> JSON dönüşümünü yapar.

from rest_framework import serializers  # DRF'nin serializer modülünü içe aktarıyoruz.
from .models import Person  # Aynı klasördeki models.py dosyasından Person modelini içe aktarıyoruz.


class PersonSerializer(serializers.ModelSerializer):
    """
    Kişi Serileştiricisi - Person modelini JSON formatına çevirir ve tersini yapar.
    ModelSerializer kullanıyoruz çünkü model alanlarını otomatik olarak tanır.
    Elle tek tek alan tanımlamaya gerek kalmaz, model alanlarını otomatik alır.
    """

    class Meta:
        """
        Meta sınıfı - Serileştiricinin ayarlarını belirler.
        Hangi modeli kullanacağını ve hangi alanları JSON'a dahil edeceğini burada söylüyoruz.
        """
        model = Person  # Bu serializer, Person modelini kullanır.

        # fields = '__all__' tüm alanları JSON'a dahil eder.
        # Yani id, fullName, department, photoUrl, birthPlace, birthDate, email, phone
        # alanlarının hepsi JSON çıktısında yer alır.
        fields = '__all__'  # Modeldeki tüm alanları JSON'a dahil et.
