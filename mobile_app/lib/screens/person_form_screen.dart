// person_form_screen.dart - Kişi Ekleme ve Düzenleme Form Ekranı.
// Bu ekran iki amaçla kullanılır:
// 1. Yeni Kişi Ekleme (person parametresi boş ise - POST isteği atar)
// 2. Kişi Bilgilerini Güncelleme (person parametresi dolu ise - PUT isteği atar)
// Form üzerindeki alanlar doldurulur ve "KAYDET" butonuna basılarak Django API'ye gönderilir.

import 'package:flutter/material.dart'; // Flutter temel arayüz kütüphanesi.
import '../models/person.dart'; // Kişi model sınıfı.
import '../services/api_service.dart'; // Django API istek servisi.

class PersonFormScreen extends StatefulWidget {
  // person parametresi:
  // Eğer bu ekrana bir person nesnesi gönderildiyse "DÜZENLEME" modunda çalışır.
  // Eğer null gönderildiyse "YENİ KİŞİ EKLEME" modunda çalışır.
  final Person? person;

  const PersonFormScreen({super.key, this.person});

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  // _formKey: Formun geçerli (valid) olup olmadığını kontrol etmek için kullanılan anahtar.
  // Boş bırakılan zorunlu alanlar var mı diye bu anahtar üzerinden kontrol ederiz.
  final _formKey = GlobalKey<FormState>();

  // TextEditingController'lar: Kullanıcının metin kutularına (TextFormField) yazdığı yazıları okumamızı ve kontrol etmemizi sağlar.
  late TextEditingController _fullNameController;   // Ad Soyad kutusu
  late TextEditingController _departmentController; // Departman kutusu
  late TextEditingController _photoUrlController;   // Fotoğraf URL kutusu
  late TextEditingController _birthPlaceController; // Doğum Yeri kutusu
  late TextEditingController _birthDateController;  // Doğum Tarihi kutusu
  late TextEditingController _emailController;      // E-posta kutusu
  late TextEditingController _phoneController;      // Telefon kutusu

  // _isSaving: Kaydet butonuna basıldığında internet işlemi sürerken çark göstermek için bayrak.
  bool _isSaving = false;

  // Düzenleme modunda mıyız yoksa yeni kayıt modunda mıyız kontrolü:
  bool get _isEditMode => widget.person != null;

  @override
  void initState() {
    super.initState();
    // Sayfa açılırken kutuların içine varsa mevcut kişinin bilgilerini dolduruyoruz (düzenleme modu için).
    // Yeni kayıt modunda ise kutuların içini boş başlatıyoruz.
    _fullNameController = TextEditingController(text: widget.person?.fullName ?? '');
    _departmentController = TextEditingController(text: widget.person?.department ?? '');
    _photoUrlController = TextEditingController(text: widget.person?.photoUrl ?? '');
    _birthPlaceController = TextEditingController(text: widget.person?.birthPlace ?? '');
    _birthDateController = TextEditingController(text: widget.person?.birthDate ?? '');
    _emailController = TextEditingController(text: widget.person?.email ?? '');
    _phoneController = TextEditingController(text: widget.person?.phone ?? '');
  }

  // dispose: Sayfa kapandığında controller'ları hafızadan temizleyen temizlik fonksiyonudur.
  // Hafıza sızıntısını (memory leak) önlemek için her controller dispose edilmelidir.
  @override
  void dispose() {
    _fullNameController.dispose();
    _departmentController.dispose();
    _photoUrlController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // =====================================================================
  // KAYDETME FONKSİYONU: FORM KONTROLÜ VE API İSTEĞİ (POST VEYA PUT)
  // =====================================================================
  Future<void> _savePerson() async {
    // 1. ADIM: Form alanlarının geçerliliğini kontrol et.
    // _formKey.currentState!.validate() formdaki tüm TextFormField'ların 'validator' kurallarını çalıştırır.
    // Eğer herhangi bir alanda hata varsa false döner ve işlem durdurulur.
    if (!_formKey.currentState!.validate()) {
      return; // Hatalı alan varsa kaydetme, burada dur!
    }

    // 2. ADIM: Kaydetme başladı, çark dönsün.
    setState(() {
      _isSaving = true;
    });

    // 3. ADIM: Kullanıcının kutulara girdiği yazılardan yeni bir Person nesnesi oluşturuyoruz.
    final personData = Person(
      id: widget.person?.id, // Düzenleme modundaysak mevcut ID'yi koru, yeniyse null.
      fullName: _fullNameController.text.trim(), // trim() baştaki ve sondaki gereksiz boşlukları temizler.
      department: _departmentController.text.trim(),
      photoUrl: _photoUrlController.text.trim().isEmpty ? null : _photoUrlController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    try {
      if (_isEditMode) {
        // DÜZENLEME MODU: Django API'ye PUT /api/persons/{id}/ isteği gönderiyoruz.
        await ApiService.updatePerson(widget.person!.id!, personData);
      } else {
        // YENİ EKLEME MODU: Django API'ye POST /api/persons/ isteği gönderiyoruz.
        await ApiService.createPerson(personData);
      }

      // Kayıt başarılı oldu!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Kişi başarıyla güncellendi!' : 'Yeni kişi başarıyla eklendi!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigator.pop(context, true): Form ekranını kapatıp önceki sayfaya geri dönüyoruz.
        // 'true' değeri dönerek listeyi yenilemesini söylüyoruz.
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Hata oluştuysa çarkı durdur ve kırmızı hata bildirimi göster.
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar: Moduna göre başlık gösterir (Yeni Kişi Ekle veya Kişiyi Düzenle).
      appBar: AppBar(
        title: Text(_isEditMode ? 'Kişiyi Düzenle' : 'Yeni Kişi Ekle'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // Form alanlarının bulunduğu gövde.
      // SingleChildScrollView: Klavye açıldığında ekran taşmasın diye kaydırma özelliği verir.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // Form: İçindeki tüm form alanlarını (TextFormField) gruplayan ve doğrulayan widget.
        child: Form(
          key: _formKey, // Doğrulama kontrolü için anahtarımızı bağlıyoruz.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Elemanları yatayda tam genişlikte yay.
            children: [
              // 1. AD SOYAD ALANI:
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad *', // Alan etiketi.
                  hintText: 'Örn: Ahmet Yılmaz',
                  prefixIcon: Icon(Icons.person), // Sol tarafa simge.
                  border: OutlineInputBorder(), // Kutulu kenarlık.
                ),
                // validator: Kullanıcı kaydet dediğinde bu kontrol çalışır.
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen Ad Soyad giriniz'; // Hata mesajı.
                  }
                  return null; // Hata yoksa null döner.
                },
              ),

              const SizedBox(height: 14), // Alanlar arası dikey boşluk.

              // 2. DEPARTMAN ALANI:
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Departman *',
                  hintText: 'Örn: Yazılım Geliştirme',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen departman bilgisi giriniz';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 3. FOTOĞRAF URL ALANI:
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Fotoğraf URL (İsteğe bağlı)',
                  hintText: 'https://cdn.site/p/104.png',
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
                // Fotoğraf zorunlu olmadığı için validator boş döner.
              ),

              const SizedBox(height: 14),

              // 4. DOĞUM YERİ ALANI:
              TextFormField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(
                  labelText: 'Doğum Yeri *',
                  hintText: 'Örn: Adana',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen doğum yeri giriniz';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 5. DOĞUM TARİHİ ALANI:
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(
                  labelText: 'Doğum Tarihi * (YYYY-AA-GG)',
                  hintText: '1994-04-12',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen doğum tarihi giriniz (Örn: 1994-04-12)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 6. E-POSTA ALANI:
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Klavyeyi e-posta klavyesi yapar (@ işareti çıkar).
                decoration: const InputDecoration(
                  labelText: 'E-posta *',
                  hintText: 'ahmet.yilmaz@sirket.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen e-posta adresi giriniz';
                  }
                  if (!value.contains('@')) {
                    return 'Geçerli bir e-posta adresi giriniz (@ içermelidir)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 7. TELEFON ALANI:
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone, // Klavyeyi telefon tuş takımı yapar.
                decoration: const InputDecoration(
                  labelText: 'Telefon *',
                  hintText: '+905550123456',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lütfen telefon numarası giriniz';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // KAYDET BUTONU:
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Mavi buton rengi.
                  foregroundColor: Colors.white, // Beyaz yazı rengi.
                  padding: const EdgeInsets.symmetric(vertical: 16), // Buton yüksekliği.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Yuvarlatılmış köşeler.
                  ),
                ),
                // Kaydetme işlemi sürüyorsa butona basılamasın (null), bitince _savePerson çalışsın:
                onPressed: _isSaving ? null : _savePerson,
                // Eğer kaydediliyorsa küçük çark dönüyor, değilse "KAYDET" yazısı gösteriliyor:
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving
                      ? 'Kaydediliyor...'
                      : (_isEditMode ? 'DEĞİŞİKLİKLERİ KAYDET' : 'KİŞİYİ KAYDET'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
