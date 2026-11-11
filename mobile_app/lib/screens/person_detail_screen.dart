// person_detail_screen.dart - Kişi Detay Sayfası Ekranı.
// Bu ekran, ana listede bir kişiye tıklandığında açılır.
// Kişinin benzersiz ID'si ile Django API'den güncel detay verileri çekilir.
// Ekranda:
// 1. Üstte büyük profil fotoğrafı,
// 2. Merkezde Ad-Soyad ve Departman unvanı,
// 3. Alt panelde Doğum Yeri/Tarihi, tıklanabilir E-posta (mailto:) ve Telefon (tel:) satırları,
// 4. En altta sabit "Düzenle" ve "Sil" butonları yer alır.

import 'package:flutter/material.dart'; // Flutter temel arayüz kütüphanesi.
import 'package:url_launcher/url_launcher.dart'; // E-posta açma (mailto:) ve arama yapma (tel:) kütüphanesi.
import '../models/person.dart'; // Kişi model sınıfı.
import '../services/api_service.dart'; // API isteklerini atan servisimiz.
import 'person_form_screen.dart'; // Bilgileri güncellemek için açılacak Düzenleme Ekranı.

// Detay sayfası da dinamik veri içerdiği ve silme/düzenleme aksiyonları olduğu için StatefulWidget.
class PersonDetailScreen extends StatefulWidget {
  // personId: Ana sayfadan tıklanan kişinin benzersiz ID numarası.
  // Bu ID ile Django API'den kişinin tüm bilgilerini çekeceğiz (/api/persons/{id}/).
  final int personId;

  const PersonDetailScreen({super.key, required this.personId});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  // _person: Sunucudan çekilen kişinin tüm detaylarını tutan nesne.
  Person? _person;

  // _isLoading: Detaylar sunucudan yükleniyor mu kontrolü.
  bool _isLoading = true;

  // _errorMessage: Bağlantı hatası olursa tutulacak metin.
  String? _errorMessage;

  // Sayfa açıldığında ilk çalışan fonksiyon.
  @override
  void initState() {
    super.initState();
    // Ekran açılır açılmaz sunucudan bu ID'ye ait kişinin detayını çekiyoruz.
    _fetchPersonDetail();
  }

  // _fetchPersonDetail: Belirli bir ID'ye sahip kişinin bilgilerini sunucudan getiren fonksiyon.
  Future<void> _fetchPersonDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ApiService.getPerson fonksiyonu GET /api/persons/{id}/ isteği atar.
      final person = await ApiService.getPerson(widget.personId);
      setState(() {
        _person = person; // Gelen kişi nesnesini değişkene ata.
        _isLoading = false; // Yükleme bitti.
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // =====================================================================
  // İLETİŞİM AKSİYONU 1: E-POSTA GÖNDERME NİYETİ (url_launcher / mailto)
  // =====================================================================
  // Yönerge kuralı: "E-posta satırları tıklanabilir olmalı; sistemin posta gönderme niyetini tetiklemelidir".
  Future<void> _launchEmail(String email) async {
    // mailto: protokolü işletim sistemine "bu adrese e-posta gönder" niyetini (Intent) bildirir.
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto', // Protokol tipi: e-posta
      path: email, // Gönderilecek e-posta adresi
    );

    try {
      // canLaunchUrl: Cihazda e-posta açabilecek bir uygulama (Gmail, Outlook vb.) var mı kontrol eder.
      if (await canLaunchUrl(emailLaunchUri)) {
        // launchUrl: Uygulamayı (Gmail vb.) açar ve e-posta gönderme ekranını getirir.
        await launchUrl(emailLaunchUri);
      } else {
        // Eğer cihazda e-posta uygulaması yoksa kullanıcıya alt bildirim (SnackBar) göster.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('E-posta uygulaması açılamadı: $email')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  // =====================================================================
  // İLETİŞİM AKSİYONU 2: TELEFON ARAMA NİYETİ (url_launcher / tel)
  // =====================================================================
  // Yönerge kuralı: "Telefon satırları tıklanabilir olmalı; sistemin arama niyetini tetiklemelidir".
  Future<void> _launchPhone(String phone) async {
    // tel: protokolü işletim sistemine "bu numarayı çevir/ara" niyetini (Intent) bildirir.
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel', // Protokol tipi: telefon
      path: phone, // Aranacak telefon numarası
    );

    try {
      // canLaunchUrl: Cihazda arama yapabilecek bir telefon uygulaması var mı kontrol eder.
      if (await canLaunchUrl(phoneLaunchUri)) {
        // launchUrl: Arama ekranını (çeviriciyi) açar ve numarayı ekrana yazar.
        await launchUrl(phoneLaunchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Telefon uygulaması açılamadı: $phone')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  // =====================================================================
  // AKSİYON: KİŞİYİ SİLME VE ONAY DİYALOĞU (DELETE / AlertDialog)
  // =====================================================================
  // Yönerge kuralı: "Kullanıcıdan onay diyaloğu alarak API'ye DELETE isteği yollar ve listeye geri döner".
  Future<void> _confirmAndDelete() async {
    // showDialog: Ekranda kullanıcıdan onay isteyen bir açılır pencere (Popup / AlertDialog) gösterir.
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Başlık:
          title: const Text('Kişiyi Sil'),
          // Uyarı içeriği:
          content: Text(
            '${_person!.fullName} isimli kişiyi kalıcı olarak silmek istediğinizden emin misiniz?\n\nBu işlem geri alınamaz.',
          ),
          actions: [
            // İptal Butonu: Silme işlemini iptal eder, pencereyi kapatır.
            TextButton(
              onPressed: () {
                // Navigator.pop içine 'false' vererek pencereyi kapatıyoruz.
                Navigator.pop(dialogContext, false);
              },
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),

            // Sil Onay Butonu: Kullanıcı kesin silmek istiyorsa basar.
            // (Mülakat Sorusu: Hoca bu butonun rengini değiştir derse buradaki Colors.red değiştirilir!)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Kırmızı silme butonu.
                foregroundColor: Colors.white, // Buton üzerindeki beyaz yazı.
              ),
              onPressed: () {
                // Navigator.pop içine 'true' vererek silme onayını iletiyoruz.
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );

    // Eğer kullanıcı 'Sil' butonuna bastıysa (confirm == true):
    if (confirm == true) {
      try {
        // ApiService içindeki deletePerson() fonksiyonunu çağırarak DELETE isteği yolluyoruz.
        await ApiService.deletePerson(_person!.id!);

        // mounted kontrolü: Ekran hâlâ ekranda açık mı kontrol eder (hafıza güvenliği için).
        if (mounted) {
          // Kullanıcıya yeşil bir başarılı silindi uyarısı gösteriyoruz.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kişi başarıyla silindi.'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigator.pop(context, true): Detay sayfasını kapatıp ana listeye geri dönüyoruz.
          // 'true' parametresi ana listeye "bir değişiklik oldu, listeyi yenile" mesajını iletir.
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Silme işlemi başarısız: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // =====================================================================
  // AKSİYON: KİŞİYİ DÜZENLEME EKRANINA GEÇİŞ (EDIT)
  // =====================================================================
  // Yönerge kuralı: "Düzenle (Edit): Bilgileri güncelleme ekranına taşır".
  Future<void> _navigateToEdit() async {
    // Form sayfasına mevcut kişinin bilgilerini (_person) gönderiyoruz.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonFormScreen(person: _person),
      ),
    );

    // Eğer form sayfasında güncelleme yapılıp 'true' dönüldüyse:
    if (result == true) {
      // Güncellenmiş yeni bilgileri sunucudan tekrar çekip detay ekranını yenile.
      _fetchPersonDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar: Detay sayfasının üst başlığı.
      appBar: AppBar(
        title: const Text('Kişi Detay Bilgileri'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // Gövde: Yükleniyorsa çark, hata varsa hata mesajı, veri geldiyse detay paneli.
      body: _buildBody(),

      // bottomNavigationBar: Yönerge kuralı: "Aksiyon Butonları (En Altta Sabit)".
      // Ekranın en altında sabit duran "Düzenle" ve "Sil" butonları.
      bottomNavigationBar: _person == null
          ? null // Kişi bilgisi henüz yüklenmediyse alttaki butonları gösterme.
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2), // Üste doğru hafif gölge verir.
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 1. DÜZENLE BUTONU (EDIT):
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _navigateToEdit, // Düzenleme ekranını aç.
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'DÜZENLE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12), // İki buton arasına 12 piksel boşluk.

                  // 2. KİŞİYİ SİL BUTONU (DELETE):
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _confirmAndDelete, // Silme onay diyaloğunu aç.
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'KİŞİYİ SİL',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Detay içeriğini oluşturan arayüz fonksiyonu.
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text('Hata: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPersonDetail,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_person == null) {
      return const Center(child: Text('Kişi bilgisi bulunamadı.'));
    }

    // Yönergedeki "Görsel & Bilgi Hiyerarşisi" düzeni:
    // SingleChildScrollView: Ekran küçük telefonlarda taşmasın, dikey kaydırılabilsin diye.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Tüm elemanları yatayda ortala.
        children: [
          const SizedBox(height: 10),

          // 1. ÜSTTE BÜYÜK PROFİL FOTOĞRAFI (CircleAvatar):
          CircleAvatar(
            radius: 65, // Yarıçapı 65 yaparak büyük profil fotoğrafı elde ediyoruz.
            backgroundColor: Colors.blue.shade100,
            backgroundImage: (_person!.photoUrl != null && _person!.photoUrl!.isNotEmpty)
                ? NetworkImage(_person!.photoUrl!)
                : null,
            child: (_person!.photoUrl == null || _person!.photoUrl!.isEmpty)
                ? const Icon(Icons.person, size: 70, color: Colors.blue)
                : null,
          ),

          const SizedBox(height: 16),

          // 2. MERKEZDE AD-SOYAD (Büyük ve kalın):
          Text(
            _person!.fullName,
            style: const TextStyle(
              fontSize: 24, // Büyük font boyutu.
              fontWeight: FontWeight.bold, // Kalın yazı tipi.
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          // 3. DEPARTMAN UNVANI:
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _person!.department,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 4. ALT PANELDE BİLGİ KARTLARI (Doğum Yeri, Tarih, E-posta, Telefon):
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // DOĞUM YERİ VE DOĞUM TARİHİ SATIRI:
                  // Yönergedeki format: "• D.Yeri / Tarih: Adana | 12.04.1994"
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.cake),
                    ),
                    title: const Text(
                      'D. Yeri / Tarih',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    subtitle: Text(
                      '${_person!.birthPlace} | ${_person!.birthDate}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const Divider(height: 1), // Araya ince ayırıcı çizgi.

                  // E-POSTA SATIRI (TIKLANABİLİR):
                  // Yönerge kuralı: "E-posta satırları tıklanabilir olmalı; posta gönderme niyetini tetiklemelidir".
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.email),
                    ),
                    title: const Text(
                      'E-Posta (Göndermek için dokunun)',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    subtitle: Text(
                      _person!.email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue, // Tıklanabilir olduğunu belli etmek için mavi renk.
                        decoration: TextDecoration.underline, // Altı çizili bağlantı efekti.
                      ),
                    ),
                    trailing: const Icon(Icons.open_in_new, size: 18, color: Colors.blue),
                    onTap: () => _launchEmail(_person!.email), // Tıklandığında mailto tetikle.
                  ),

                  const Divider(height: 1), // Araya ince ayırıcı çizgi.

                  // TELEFON SATIRI (TIKLANABİLİR):
                  // Yönerge kuralı: "Telefon satırları tıklanabilir olmalı; arama niyetini tetiklemelidir".
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.phone),
                    ),
                    title: const Text(
                      'Telefon (Aramak için dokunun)',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    subtitle: Text(
                      _person!.phone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green, // Tıklanabilir olduğunu belli etmek için yeşil renk.
                        decoration: TextDecoration.underline, // Altı çizili telefon efekti.
                      ),
                    ),
                    trailing: const Icon(Icons.call, size: 18, color: Colors.green),
                    onTap: () => _launchPhone(_person!.phone), // Tıklandığında tel: tetikle.
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80), // Alttaki butonların üstüne binmemesi için alt boşluk.
        ],
      ),
    );
  }
}
