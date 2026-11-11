# -*- coding: utf-8 -*-
# urls.py - Projenin ana URL yönlendirme dosyasıdır.
# Gelen web isteklerinin (HTTP request) hangi uygulamaya yönlendirileceğini burada belirliyoruz.
# Örneğin: /api/persons adresine gelen istek persons uygulamasına yönlendirilir.
# Örneğin: /admin adresine gelen istek Django admin paneline yönlendirilir.

from django.contrib import admin  # Django yönetim paneli modülünü içe aktarıyoruz.
from django.urls import path, include  # URL tanımlama ve başka URL dosyalarını dahil etme fonksiyonları.

# urlpatterns, projemizdeki tüm URL yollarının listesidir.
# Django gelen her isteği bu listedeki yollarla karşılaştırır.
# Eşleşen yolu bulunca ilgili uygulamaya yönlendirir.
urlpatterns = [
    # /admin/ adresine gelen istekleri Django yönetim paneline yönlendir.
    # Admin panelinde veritabanındaki kayıtları görüntüleyebilir, ekleyebilir, düzenleyebilir ve silebilirsiniz.
    path('admin/', admin.site.urls),

    # /api/persons/ ile başlayan istekleri persons uygulamasının kendi URL dosyasına yönlendir.
    # include() fonksiyonu, persons/urls.py dosyasındaki URL tanımlarını buraya dahil eder.
    # Bu sayede URL tanımları düzenli ve modüler kalır.
    path('api/', include('persons.urls')),  # /api/ ile başlayan tüm istekleri persons uygulamasına gönder.
]
