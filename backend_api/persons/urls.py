# -*- coding: utf-8 -*-
# urls.py - Persons (Kişiler) uygulamasının URL yönlendirme dosyasıdır.
# Bu dosya, /api/persons ile başlayan URL'lerin hangi view (görünüm) fonksiyonuna
# gideceğini belirler. Ana urls.py dosyası bu dosyayı include() ile dahil eder.

from django.urls import path  # URL tanımlama fonksiyonunu içe aktarıyoruz.
from . import views  # Aynı klasördeki views.py dosyasındaki fonksiyonları içe aktarıyoruz.

# urlpatterns, bu uygulamadaki URL yollarının listesidir.
# Her path() fonksiyonu bir URL deseni ve o URL'e karşılık gelen view fonksiyonunu tanımlar.
urlpatterns = [
    # /api/persons/ adresine gelen istekleri person_list fonksiyonuna yönlendir.
    # Bu adres, tüm kişileri listelemek (GET) veya yeni kişi eklemek (POST) için kullanılır.
    # name='person-list' bu URL'e kod içinden isimle erişmemizi sağlar.
    path('persons/', views.person_list, name='person-list'),

    # /api/persons/5/ gibi bir adrese gelen istekleri person_detail fonksiyonuna yönlendir.
    # <int:pk> kısmı URL'deki sayıyı yakalar ve pk (primary key) parametresi olarak gönderir.
    # Örnek: /api/persons/3/ → pk=3 olarak person_detail fonksiyonuna gider.
    # <int:pk> açıklaması: <int: sadece sayı kabul et, pk: parametre adı>
    path('persons/<int:pk>/', views.person_detail, name='person-detail'),
]
