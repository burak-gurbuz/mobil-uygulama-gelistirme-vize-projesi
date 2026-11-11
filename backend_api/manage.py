#!/usr/bin/env python
# -*- coding: utf-8 -*-
# manage.py - Django projesinin yönetim dosyasıdır.
# Bu dosya, Django komutlarını çalıştırmak için kullanılır.
# Örneğin: python manage.py runserver (sunucuyu başlatır)
# Örneğin: python manage.py migrate (veritabanını oluşturur)

"""Django yönetim betiği - komut satırından Django işlemlerini çalıştırır."""
# Üstteki satır, bu dosyanın ne işe yaradığını kısaca açıklar.

import os  # os modülü, işletim sistemi ile iletişim kurmamızı sağlar.
import sys  # sys modülü, Python yorumlayıcısı ile ilgili bilgilere erişmemizi sağlar.


def main():
    """Ana fonksiyon - Django yönetim komutlarını çalıştırır."""
    # Bu satır, Django'nun hangi ayar dosyasını kullanacağını belirtir.
    # 'kisi_yonetim.settings' diyerek kisi_yonetim klasöründeki settings.py dosyasını gösteriyoruz.
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'kisi_yonetim.settings')

    try:
        # Django'nun komut satırı aracını içe aktarıyoruz (import ediyoruz).
        # Bu araç sayesinde runserver, migrate gibi komutları çalıştırabiliriz.
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        # Eğer Django yüklü değilse bu hata mesajını gösterir.
        # Bu durumda "pip install django" komutu ile Django yüklenmelidir.
        raise ImportError(
            "Django içe aktarılamadı. Django'nun yüklü olduğundan "
            "ve PYTHONPATH ortam değişkeninde mevcut olduğundan emin olun. "
            "Sanal ortamı (virtual environment) aktifleştirmeyi unutmayın."
        ) from exc

    # Komut satırından girilen argümanları (örn: runserver) Django'ya iletir ve çalıştırır.
    execute_from_command_line(sys.argv)


# Bu kontrol, dosyanın doğrudan çalıştırılıp çalıştırılmadığını kontrol eder.
# Eğer bu dosya doğrudan çalıştırılıyorsa (python manage.py ...) main() fonksiyonunu çağırır.
if __name__ == '__main__':
    main()  # Ana fonksiyonu çalıştır ve Django komutunu işle.
