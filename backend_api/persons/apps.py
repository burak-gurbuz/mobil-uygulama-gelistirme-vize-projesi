# -*- coding: utf-8 -*-
# apps.py - Uygulama yapılandırma dosyasıdır.
# Her Django uygulamasının bir AppConfig sınıfı vardır.
# Bu sınıf, uygulamanın adını, otomatik alan türünü ve admin panelindeki adını belirler.

from django.apps import AppConfig  # Django uygulama yapılandırma sınıfını içe aktarıyoruz.


class PersonsConfig(AppConfig):
    """
    Persons uygulamasının yapılandırma sınıfı.
    Django bu sınıfı kullanarak uygulamayı tanır ve ayarlarını uygular.
    """

    # default_auto_field: Veritabanı tablolarında otomatik oluşturulan ID alanının türünü belirler.
    # BigAutoField, 64-bit tamsayı kullanır ve çok büyük sayılara kadar destek verir.
    default_auto_field = 'django.db.models.BigAutoField'

    # name: Uygulamanın Python modül adı. Django bu isimle uygulamayı bulur.
    # settings.py'deki INSTALLED_APPS listesinde bu isim yazılıdır.
    name = 'persons'

    # verbose_name: Admin panelinde uygulamanın Türkçe görünen adı.
    verbose_name = 'Kişi Yönetimi'
