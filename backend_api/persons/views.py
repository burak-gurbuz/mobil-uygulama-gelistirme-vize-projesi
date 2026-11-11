# -*- coding: utf-8 -*-
# views.py - Görünüm (View) dosyasıdır.
# View, API isteklerini (GET, POST, PUT, DELETE) karşılayan fonksiyonlardır.
# Gelen isteğe göre veritabanından veri çeker, ekler, günceller veya siler.
# Sonucu JSON formatında istemciye (Flutter uygulaması) geri gönderir.

from rest_framework import status  # HTTP durum kodlarını içe aktarıyoruz (200, 201, 404 vb.).
from rest_framework.decorators import api_view  # Fonksiyonu API görünümüne çeviren dekoratör.
from rest_framework.response import Response  # API yanıtı oluşturmak için kullanılan sınıf.
from .models import Person  # Person modelini içe aktarıyoruz (veritabanı tablosu).
from .serializers import PersonSerializer  # JSON dönüştürücüyü içe aktarıyoruz.


@api_view(['GET', 'POST'])  # Bu fonksiyon sadece GET ve POST isteklerini kabul eder.
def person_list(request):
    """
    Kişi listesi görünümü.
    GET isteği: Veritabanındaki tüm kişileri JSON listesi olarak döndürür.
    POST isteği: Gönderilen JSON verisinden yeni bir kişi kaydı oluşturur.
    """

    # Eğer gelen istek GET ise (veri listeleme isteği):
    if request.method == 'GET':
        # Veritabanındaki tüm kişi kayıtlarını çekiyoruz.
        # Person.objects.all() tüm kişileri bir liste olarak döndürür.
        persons = Person.objects.all()

        # Kişi listesini JSON formatına çeviriyoruz.
        # many=True parametresi birden fazla nesne olduğunu belirtir (liste).
        serializer = PersonSerializer(persons, many=True)

        # JSON verisini HTTP 200 (Başarılı) durum koduyla döndürüyoruz.
        return Response(serializer.data)  # serializer.data JSON formatındaki veridir.

    # Eğer gelen istek POST ise (yeni kayıt oluşturma isteği):
    elif request.method == 'POST':
        # Gelen JSON verisini serializer'a gönderiyoruz.
        # request.data, istemcinin gönderdiği JSON verisini içerir.
        serializer = PersonSerializer(data=request.data)

        # Gelen verinin geçerli olup olmadığını kontrol ediyoruz.
        # Örneğin: email alanı gerçekten bir email mi, zorunlu alanlar dolu mu?
        if serializer.is_valid():
            # Veri geçerliyse veritabanına kaydediyoruz.
            serializer.save()

            # Kaydedilen veriyi HTTP 201 (Oluşturuldu) durum koduyla döndürüyoruz.
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        # Veri geçerli değilse hata mesajlarını HTTP 400 (Hatalı İstek) koduyla döndürüyoruz.
        # serializer.errors hangi alanlarda hata olduğunu açıklar.
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])  # Bu fonksiyon GET, PUT ve DELETE isteklerini kabul eder.
def person_detail(request, pk):
    """
    Kişi detay görünümü.
    GET isteği: Belirtilen ID'ye sahip kişinin bilgilerini döndürür.
    PUT isteği: Belirtilen ID'ye sahip kişinin bilgilerini günceller.
    DELETE isteği: Belirtilen ID'ye sahip kişiyi veritabanından siler.

    pk parametresi: Primary Key (birincil anahtar) yani kişinin benzersiz ID numarası.
    URL'den otomatik olarak alınır. Örnek: /api/persons/3 → pk=3
    """

    try:
        # Belirtilen ID'ye sahip kişiyi veritabanından bulmaya çalışıyoruz.
        # Person.objects.get(pk=pk) ID'si eşleşen tek bir kişiyi döndürür.
        person = Person.objects.get(pk=pk)
    except Person.DoesNotExist:
        # Eğer belirtilen ID'ye sahip kişi bulunamazsa bu blok çalışır.
        # HTTP 404 (Bulunamadı) durum koduyla hata mesajı döndürüyoruz.
        return Response(
            {'hata': 'Belirtilen ID ile kişi bulunamadı.'},  # Türkçe hata mesajı.
            status=status.HTTP_404_NOT_FOUND  # 404 durum kodu: Kaynak bulunamadı.
        )

    # Eğer gelen istek GET ise (tek kişi detayı görüntüleme):
    if request.method == 'GET':
        # Bulunan kişiyi JSON formatına çeviriyoruz.
        serializer = PersonSerializer(person)

        # JSON verisini HTTP 200 (Başarılı) durum koduyla döndürüyoruz.
        return Response(serializer.data)

    # Eğer gelen istek PUT ise (kişi bilgilerini güncelleme):
    elif request.method == 'PUT':
        # Mevcut kişi nesnesini ve gelen yeni veriyi serializer'a gönderiyoruz.
        # İlk parametre mevcut nesne, data parametresi yeni (güncellenmiş) veridir.
        serializer = PersonSerializer(person, data=request.data)

        # Gelen verinin geçerli olup olmadığını kontrol ediyoruz.
        if serializer.is_valid():
            # Veri geçerliyse güncellemeyi veritabanına kaydediyoruz.
            serializer.save()

            # Güncellenmiş veriyi HTTP 200 (Başarılı) durum koduyla döndürüyoruz.
            return Response(serializer.data)

        # Veri geçerli değilse hata mesajlarını HTTP 400 (Hatalı İstek) koduyla döndürüyoruz.
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # Eğer gelen istek DELETE ise (kişiyi silme):
    elif request.method == 'DELETE':
        # Kişiyi veritabanından siliyoruz.
        person.delete()

        # HTTP 204 (İçerik Yok) durum koduyla yanıt döndürüyoruz.
        # 204 kodu, işlemin başarılı olduğunu ama döndürülecek veri olmadığını belirtir.
        return Response(status=status.HTTP_204_NO_CONTENT)
