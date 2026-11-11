# -*- coding: utf-8 -*-
# wsgi.py - WSGI (Web Server Gateway Interface) yapılandırma dosyasıdır.
# WSGI, web sunucusu (Apache, Nginx vb.) ile Django uygulaması arasındaki
# iletişim protokolüdür (köprüdür).
# Bu dosya, Django uygulamasını bir web sunucusuna bağlamak için kullanılır.
# Geliştirme sırasında genellikle doğrudan kullanılmaz (runserver komutu bunu otomatik yapar).

import os  # os modülü, işletim sistemi ile iletişim kurmamızı sağlar.

# Django'nun hangi ayar dosyasını kullanacağını ortam değişkeni olarak belirtiyoruz.
# 'kisi_yonetim.settings' diyerek kisi_yonetim/settings.py dosyasını gösteriyoruz.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'kisi_yonetim.settings')

from django.core.wsgi import get_wsgi_application  # Django WSGI uygulama fonksiyonunu içe aktarıyoruz.

# WSGI uygulamasını oluşturuyoruz.
# Bu değişken, web sunucusunun Django ile iletişim kurmasını sağlar.
# Web sunucusu bu 'application' değişkenini kullanarak Django'ya istek gönderir.
application = get_wsgi_application()
