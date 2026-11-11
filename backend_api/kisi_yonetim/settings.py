# -*- coding: utf-8 -*-
# settings.py - Django projesinin tüm ayarlarının bulunduğu dosyadır.
# Veritabanı, yüklü uygulamalar, güvenlik, dil gibi her şey burada tanımlanır.
# Bu dosyayı değiştirerek projenin davranışını kontrol edebilirsiniz.

import os  # os modülü, dosya yolları ve ortam değişkenleri ile çalışmak için kullanılır.
from pathlib import Path  # Path, dosya yollarını kolay yönetmemizi sağlayan bir sınıftır.

# BASE_DIR, projenin kök dizinini (ana klasörünü) belirtir.
# __file__ bu dosyanın kendisini gösterir, .resolve() tam yolunu verir,
# .parent iki kez kullanılarak iki üst klasöre çıkılır (backend_api klasörü).
BASE_DIR = Path(__file__).resolve().parent.parent

# SECRET_KEY, Django'nun güvenlik için kullandığı gizli bir anahtardır.
# Bu anahtar şifreleme, oturum yönetimi gibi işlemlerde kullanılır.
# Gerçek projelerde bu anahtar gizli tutulmalıdır ama bu bir ödev projesi olduğu için sorun yok.
SECRET_KEY = 'django-insecure-vize-projesi-icin-ornek-gizli-anahtar-2024'

# DEBUG = True olduğunda Django hata mesajlarını detaylı gösterir.
# Geliştirme sırasında True olmalıdır, canlı yayında (production) False yapılır.
DEBUG = True

# ALLOWED_HOSTS, bu sunucuya hangi alan adlarından erişilebileceğini belirler.
# '*' işareti tüm adreslerden erişime izin verir (geliştirme için uygundur).
# Canlı yayında buraya sadece kendi alan adınızı yazmalısınız.
ALLOWED_HOSTS = ['*']

# INSTALLED_APPS, projede yüklü olan tüm uygulamaların listesidir.
# Django'nun kendi uygulamaları ve bizim oluşturduğumuz uygulamalar burada yer alır.
INSTALLED_APPS = [
    'django.contrib.admin',        # Django yönetim paneli (admin sayfası) uygulaması.
    'django.contrib.auth',         # Kullanıcı kimlik doğrulama (giriş/çıkış) sistemi.
    'django.contrib.contenttypes', # İçerik türlerini yöneten sistem (Django içsel kullanır).
    'django.contrib.sessions',     # Oturum (session) yönetimi - kullanıcı oturumlarını takip eder.
    'django.contrib.messages',     # Kullanıcıya mesaj gösterme sistemi (başarılı, hata vb.).
    'django.contrib.staticfiles',  # CSS, JavaScript gibi statik dosyaları yöneten uygulama.
    'rest_framework',              # Django REST Framework - API oluşturmak için kullandığımız kütüphane.
    'corsheaders',                 # CORS başlıkları - Flutter gibi farklı kaynaklardan erişime izin verir.
    'persons',                     # Bizim oluşturduğumuz kişi yönetim uygulaması.
]

# MIDDLEWARE, her HTTP isteği ve yanıtı arasında çalışan ara katman yazılımlarıdır.
# İstekler sırayla bu katmanlardan geçer (güvenlik kontrolü, oturum kontrolü vb.).
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',        # CORS ara katmanı - farklı kaynaklardan gelen isteklere izin verir. EN ÜSTTE olmalı!
    'django.middleware.security.SecurityMiddleware', # Güvenlik kontrolleri yapan ara katman.
    'django.contrib.sessions.middleware.SessionMiddleware',  # Oturum yönetimi ara katmanı.
    'django.middleware.common.CommonMiddleware',     # Genel HTTP işlemleri (URL düzenleme vb.) ara katmanı.
    'django.middleware.csrf.CsrfViewMiddleware',     # CSRF saldırılarına karşı koruma sağlayan ara katman.
    'django.contrib.auth.middleware.AuthenticationMiddleware',  # Kullanıcı kimlik doğrulama ara katmanı.
    'django.contrib.messages.middleware.MessageMiddleware',     # Mesaj sistemi ara katmanı.
    'django.middleware.clickjacking.XFrameOptionsMiddleware',  # Clickjacking saldırılarına karşı koruma.
]

# ROOT_URLCONF, projenin ana URL yapılandırma dosyasını belirtir.
# Django, gelen isteklerin hangi sayfaya yönlendirileceğini bu dosyadan öğrenir.
ROOT_URLCONF = 'kisi_yonetim.urls'

# TEMPLATES, HTML şablon (template) ayarlarını içerir.
# Admin paneli gibi sayfalar bu şablonları kullanır.
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',  # Django'nun kendi şablon motoru.
        'DIRS': [],          # Ekstra şablon klasörleri (şu an boş, ihtiyaç yok).
        'APP_DIRS': True,    # True olunca Django her uygulamanın templates klasörüne bakar.
        'OPTIONS': {
            'context_processors': [
                # Şablonlara otomatik olarak eklenen bilgiler (context).
                'django.template.context_processors.debug',    # Debug bilgisi ekler.
                'django.template.context_processors.request',  # HTTP istek bilgisi ekler.
                'django.contrib.auth.context_processors.auth',  # Kullanıcı bilgisi ekler.
                'django.contrib.messages.context_processors.messages',  # Mesaj bilgisi ekler.
            ],
        },
    },
]

# WSGI_APPLICATION, projenin WSGI uygulamasının yolunu belirtir.
# WSGI, web sunucusu ile Django arasındaki iletişim protokolüdür.
WSGI_APPLICATION = 'kisi_yonetim.wsgi.application'

# DATABASES, veritabanı ayarlarını içerir.
# SQLite kullanıyoruz çünkü kurulum gerektirmez, tek bir dosyada çalışır.
# Veritabanı dosyası projenin ana dizininde db.sqlite3 adıyla oluşturulur.
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',   # SQLite veritabanı motoru kullanılacak.
        'NAME': BASE_DIR / 'db.sqlite3',           # Veritabanı dosyasının yolu ve adı.
    }
}

# AUTH_PASSWORD_VALIDATORS, şifre güvenlik kurallarını belirler.
# Kullanıcı şifresi oluştururken bu kurallar kontrol edilir.
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
        # Şifrenin kullanıcı bilgilerine (isim, email) benzemesini engeller.
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        # Şifrenin minimum uzunluğunu kontrol eder (varsayılan 8 karakter).
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
        # Çok yaygın şifrelerin (123456, password vb.) kullanılmasını engeller.
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
        # Şifrenin tamamen sayılardan oluşmasını engeller.
    },
]

# LANGUAGE_CODE, projenin dilini belirler.
# 'tr' Türkçe anlamına gelir. Admin paneli Türkçe görünecektir.
LANGUAGE_CODE = 'tr'

# TIME_ZONE, projenin saat dilimini belirler.
# 'Europe/Istanbul' Türkiye saat dilimini kullanır (UTC+3).
TIME_ZONE = 'Europe/Istanbul'

# USE_I18N = True olduğunda Django çeviri (internationalization) sistemini aktif eder.
# Bu sayede farklı dillerde içerik gösterilebilir.
USE_I18N = True

# USE_TZ = True olduğunda Django saat dilimi farkındalığını aktif eder.
# Tarih/saat bilgileri saat dilimine göre saklanır.
USE_TZ = True

# STATIC_URL, statik dosyaların (CSS, JS, resimler) erişim yolunu belirler.
# Tarayıcıda /static/dosya.css şeklinde erişilir.
STATIC_URL = 'static/'

# DEFAULT_AUTO_FIELD, veritabanı tablolarında otomatik oluşturulan birincil anahtar (primary key) türünü belirler.
# BigAutoField, büyük sayılara kadar destekleyen otomatik artan bir alan oluşturur.
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# =============================================
# CORS AYARLARI (Cross-Origin Resource Sharing)
# =============================================
# CORS, farklı bir adresteki uygulamanın (örneğin Flutter) bu API'ye erişmesine izin verir.
# Normalde tarayıcılar güvenlik nedeniyle farklı adreslerden gelen istekleri engeller.
# CORS_ALLOW_ALL_ORIGINS = True diyerek tüm adreslere izin veriyoruz.
# Bu sadece geliştirme ortamı içindir, canlı yayında belirli adresler yazılmalıdır.
CORS_ALLOW_ALL_ORIGINS = True  # Tüm kaynaklardan (origin) gelen isteklere izin ver.

# =============================================
# REST FRAMEWORK AYARLARI
# =============================================
# Django REST Framework'ün genel ayarlarını burada belirliyoruz.
REST_FRAMEWORK = {
    # DEFAULT_PERMISSION_CLASSES, API'ye erişim izinlerini belirler.
    # AllowAny, herkesin (giriş yapmadan) API'yi kullanabilmesine izin verir.
    # Bu bir ödev projesi olduğu için kimlik doğrulama gerekmiyor.
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny',  # Herkese erişim izni ver (kimlik doğrulama yok).
    ]
}
