# Kişi Yönetim Sistemi (Client-Server REST Mimarisi)
## Mobil Programlama Dersi Vize Projesi

Bu proje, **Flutter** mobil istemcisi ile **Django REST Framework (Python)** backend servisinin HTTP/REST protokolü üzerinden JSON formatında haberleştiği tam kapsamlı bir **Kişi Yönetim Sistemi** uygulamasıdır.

---

## 📁 Proje Klasör Yapısı

```text
Mobil uygulama geliştirme/
│
├── backend_api/                     # Sunucu Katmanı (Django REST Framework)
│   ├── manage.py                    # Django yönetim komut dosyası
│   ├── requirements.txt             # Gerekli Python kütüphaneleri listesi
│   ├── db.sqlite3                   # SQLite veritabanı dosyası (otomatik oluşur)
│   ├── kisi_yonetim/                # Proje genel ayarları
│   │   ├── settings.py              # Veritabanı, CORS ve yüklü uygulamalar ayarları
│   │   ├── urls.py                  # Ana URL yönlendirmeleri
│   │   └── wsgi.py                  # Web sunucusu köprüsü
│   └── persons/                     # Kişiler API Uygulaması
│       ├── models.py                # Veritabanı tablosu (Person tablosu)
│       ├── serializers.py           # Model <-> JSON dönüştürücüsü
│       ├── views.py                 # GET, POST, PUT, DELETE fonksiyonları
│       ├── urls.py                  # /api/persons/ uç noktaları
│       ├── admin.py                 # Django yönetim paneli ayarları
│       └── fixtures/
│           └── initial_data.json    # Hazır 5 adet başlangıç kişisi verisi
│
├── mobile_app/                      # Mobil İstemci (Flutter)
│   ├── pubspec.yaml                 # Paket bağımlılıkları (http, url_launcher)
│   ├── android/                     # Android izinleri ve konfigürasyonu
│   └── lib/
│       ├── main.dart                # Uygulama giriş noktası ve tema
│       ├── models/
│       │   └── person.dart          # Kişi veri modeli (fromJson, toJson)
│       ├── services/
│       │   └── api_service.dart     # HTTP istekleri (GET, POST, PUT, DELETE)
│       └── screens/
│           ├── person_list_screen.dart   # Ana Sayfa: Dairesel fotoğraflı kaydırılabilir liste + FAB
│           ├── person_detail_screen.dart # Detay Sayfası: Büyük profil fotosu, mailto/tel, Düzenle/Sil
│           └── person_form_screen.dart   # Ekleme & Düzenleme Formu
│
├── README.md                        # Adım adım kurulum ve çalıştırma rehberi
└── MULAKAT_KOPYA_KAGIDI.md          # Hoca mülakatı için canlı kod müdahale kılavuzu
```

---

## 🚀 1. Bölüm: Backend Servisini (Django API) Ayağa Kaldırma

Sunucuyu çalıştırmak için bilgisayarınızda **Python** yüklü olmalıdır.

### Adım 1: Terminali Açın ve Backend Klasörüne Gidin
VS Code veya PowerShell terminalini açıp şu komutu yazın:
```bash
cd "backend_api"
```

### Adım 2: Gerekli Paketleri Yükleyin
Django, Django REST Framework ve CORS paketlerini yükleyin:
```bash
pip install -r requirements.txt
```

### Adım 3: Veritabanını Oluşturun (Migrate)
SQLite veritabanı tablolarını oluşturmak için:
```bash
python manage.py makemigrations persons
python manage.py migrate
```

### Adım 4: Hazır Başlangıç Verilerini Yükleyin (Örnek 5 Kişi)
Hocaya sunum yaparken veritabanının dolu gözükmesi için hazır verileri tek komutla aktarın:
```bash
python manage.py loaddata persons/fixtures/initial_data.json
```

### Adım 5: Sunucuyu Başlatın
Sunucuyu hem bilgisayardan hem emülatörden erişilebilecek şekilde `0.0.0.0:8000` portunda başlatın:
```bash
python manage.py runserver 0.0.0.0:8000
```

> **Kontrol:** Tarayıcınızı açıp `http://127.0.0.1:8000/api/persons/` adresine gidin. Ekranda 5 adet kişinin JSON verisini görüyorsanız sunucunuz başarıyla çalışıyor demektir!

---

## 📱 2. Bölüm: Mobil Uygulamayı (Flutter) Ayağa Kaldırma

### Adım 1: Yeni Bir Terminal Açın ve Mobil Klasöre Gidin
Django sunucusunun çalıştığı terminal açık kalsın. **İkinci bir terminal sekmesi açın** ve şu komutu yazın:
```bash
cd "mobile_app"
```

### Adım 2: Paketleri İndirin
Gerekli kütüphaneleri (`http`, `url_launcher`) projeye çekin:
```bash
flutter pub get
```

### Adım 3: Emülatörü Başlatın veya Telefonunuzu Bağlayın
- **Android Emülatör Kullanıyorsanız:** Android Studio'dan bir sanal cihaz (Pixel vb.) başlatın.
- **Önemli Ağ Bilgisi:** Android emülatör kendi içinde ayrı bir sanal ağda çalıştığı için bilgisayarınızın `localhost`una **`10.0.2.2`** IP adresi üzerinden ulaşır. Projemizde `api_service.dart` dosyası varsayılan olarak `http://10.0.2.2:8000` adresine ayarlıdır, ekstra hiçbir ayar yapmanıza gerek yoktur!
- *(Eğer fiziksel telefonunuzu USB ile bağlayıp çalıştıracaksanız, bilgisayarınızın Wi-Fi yerel IP adresini örn: `192.168.1.35:8000` yazmalısınız).*

### Adım 4: Flutter Uygulamasını Çalıştırın
```bash
flutter run
```

---

## 📡 REST API Uç Noktaları ve JSON Şeması

| Metot | Uç Nokta | Açıklama | Gövde (Body) |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/persons/` | Tüm kayıtlı kişileri liste olarak döner | Yok |
| **GET** | `/api/persons/{id}/` | Belirtilen ID'ye sahip kişinin detayını döner | Yok |
| **POST** | `/api/persons/` | Yeni bir kişi kaydı oluşturur | JSON (Ad, Departman, Tel vb.) |
| **PUT** | `/api/persons/{id}/` | Var olan kişinin bilgilerini günceller | JSON (Ad, Departman, Tel vb.) |
| **DELETE** | `/api/persons/{id}/` | Belirtilen ID'li kişiyi kalıcı olarak siler | Yok |

### Örnek JSON Payload (İstek ve Yanıt Formatı):
```json
{
  "id": 1,
  "fullName": "Ahmet Yılmaz",
  "department": "Yazılım Geliştirme",
  "photoUrl": "https://randomuser.me/api/portraits/men/1.jpg",
  "birthPlace": "Adana",
  "birthDate": "1994-04-12",
  "email": "ahmet.yilmaz@sirket.com",
  "phone": "+905550123456"
}
```

---

## 🎯 Ekran Özellikleri ve Gezinim Akışı

1. **Kişi Listesi (Ana Sayfa):**
   - Açılışta API'den verileri çeker. Yükleme esnasında dönen çark gösterir.
   - Solda dairesel profil fotoğrafı (`CircleAvatar`), kalın Ad-Soyad ve altında Departman unvanı.
   - Aşağı kaydırarak yenileme (`RefreshIndicator`) desteği.
   - Sağ altta sabit **`+`** (FloatingActionButton) ile yeni kişi formuna geçiş.
   - Satıra dokunulduğunda kişinin ID'si ile Detay Sayfasına geçiş.

2. **Kişi Detay Sayfası:**
   - Üstte büyük profil fotoğrafı (`radius: 65`).
   - Merkezde büyük Ad-Soyad ve Departman unvanı.
   - Doğum Yeri ve Doğum Tarihi kartı (`Adana | 1994-04-12`).
   - Tıklanabilir **E-posta**: Dokunulduğunda `mailto:` protokolüyle e-posta uygulamasını açar.
   - Tıklanabilir **Telefon**: Dokunulduğunda `tel:` protokolüyle arama ekranını açar.
   - En altta sabit **DÜZENLE** ve **KİŞİYİ SİL** butonları.
   - Silme butonuna basıldığında onay isteyen açılır pencere (`AlertDialog`).

3. **Ekleme & Düzenleme Formu:**
   - Boş bırakılamaz alanlar için form validasyonu (`_formKey.currentState!.validate()`).
   - E-posta için `@` işareti kontrolü.
   - Yeni kayıtta `POST`, düzenlemede `PUT` isteği.
