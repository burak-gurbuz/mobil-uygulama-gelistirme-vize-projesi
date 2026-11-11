# -*- coding: utf-8 -*-
# admin.py - Django yönetim paneli (admin panel) yapılandırma dosyasıdır.
# Bu dosyada, hangi modellerin admin panelinde görüneceğini ve nasıl gösterileceğini belirliyoruz.
# Admin paneline /admin/ adresinden erişilir ve veritabanı kayıtlarını yönetmek için kullanılır.

from django.contrib import admin  # Django admin modülünü içe aktarıyoruz.
from .models import Person  # Aynı klasördeki models.py'dan Person modelini içe aktarıyoruz.


# PersonAdmin sınıfı, Person modelinin admin panelinde nasıl gösterileceğini belirler.
# ModelAdmin sınıfından türetilir (miras alır) ve özelleştirme ayarları içerir.
class PersonAdmin(admin.ModelAdmin):
    """
    Kişi Admin Yapılandırması - Admin panelinde kişi kayıtlarının nasıl
    görüntüleneceğini, aranacağını ve filtreleneceğini belirler.
    """

    # list_display: Admin panelindeki liste sayfasında hangi sütunların gösterileceğini belirler.
    # Bu alanlar tablo sütunları olarak yan yana görünür.
    list_display = ('id', 'fullName', 'department', 'email', 'phone')

    # search_fields: Admin panelinde arama çubuğu ile hangi alanlarda arama yapılacağını belirler.
    # Kullanıcı arama kutusuna yazdığında bu alanlarda arar.
    search_fields = ('fullName', 'department', 'email')

    # list_filter: Admin panelinde sağ tarafta filtre seçenekleri ekler.
    # Departmana göre filtreleme yapılabilir.
    list_filter = ('department',)


# Person modelini admin paneline kayıt ediyoruz.
# Bu sayede /admin/ sayfasında "Kişiler" bölümü görünür ve kayıtlar yönetilebilir.
# İkinci parametre olarak PersonAdmin sınıfını vererek özelleştirilmiş görünümü kullanıyoruz.
admin.site.register(Person, PersonAdmin)
