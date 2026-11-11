// person_list_screen.dart - Kişi Listesi (Ana Sayfa) Ekranı.
// Bu ekran, uygulamanın açılış sayfasıdır.
// Sunucudan (Django API) tüm kişileri çeker ve ekranda kaydırılabilir bir liste olarak gösterir.
// Sağ alttaki '+' butonuyla yeni kişi ekleme ekranına geçiş yapılır.
// Listedeki herhangi bir kişiye tıklandığında o kişinin detay sayfasına gidilir.

import 'package:flutter/material.dart'; // Flutter'ın temel buton, liste, renk vb. UI bileşenleri.
import '../models/person.dart'; // Kişi veri modelini içe aktarıyoruz (ad, soyad, telefon vb.).
import '../services/api_service.dart'; // Django API'ye istek atan servis fonksiyonlarımız.
import 'person_detail_screen.dart'; // Bir kişiye tıklandığında açılacak Detay Sayfası.
import 'person_form_screen.dart'; // '+' butonuna basıldığında açılacak Yeni Kişi Ekleme Sayfası.

// StatefulWidget kullanıyoruz çünkü bu ekranda durum (state) değişebilir.
// Örneğin: Veriler yüklenirken dönen çark gösterilir, veriler gelince liste gösterilir.
// Karmaşık kütüphaneler (Provider, Bloc vb.) yerine hocamızın istediği en ilkel ve sade 'setState' kullanıyoruz.
class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

// Ekranın durumunu (State) ve arayüz çizimini yöneten sınıf.
class _PersonListScreenState extends State<PersonListScreen> {
  // _persons: Sunucudan çekilen kişileri saklayacağımız liste.
  // Başlangıçta boş bir liste olarak tanımlıyoruz.
  List<Person> _persons = [];

  // _isLoading: Verilerin o anda internetten yüklenip yüklenmediğini tutan bayrak (true/false).
  // Sayfa ilk açıldığında veri çekileceği için başlangıçta true (yükleniyor) yapıyoruz.
  bool _isLoading = true;

  // _errorMessage: Eğer sunucuya bağlanırken bir hata olursa hata mesajını bu değişkende tutacağız.
  // Hata yoksa null (boş) kalır.
  String? _errorMessage;

  // initState: Bu ekran ekrana ilk kez çizilmeden hemen önce SADECE BİR KEZ çalışan başlangıç fonksiyonudur.
  // Sayfa açılır açılmaz internetten kişileri çekmek için bu fonksiyonu kullanırız.
  @override
  void initState() {
    super.initState();
    // Sayfa açılır açılmaz hemen sunucudan kişileri çekme fonksiyonumuzu çağırıyoruz.
    _fetchPersons();
  }

  // _fetchPersons: Django REST API'den kişi listesini çeken asenkron (async) fonksiyonumuz.
  // İnternet isteği zaman alacağı için 'async' ve 'await' anahtar kelimelerini kullanıyoruz.
  Future<void> _fetchPersons() async {
    // setState: Flutter'a "ekrandaki bir değişken değişti, ekranı yeniden çiz" emrini verir.
    // Yükleme başladığı için çark dönsün diye _isLoading'i true, eski hatayı null yapıyoruz.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ApiService içindeki getPersons() fonksiyonunu çağırarak Django'ya GET isteği atıyoruz.
      // 'await' sunucudan yanıt gelene kadar kodun bu satırda beklemesini sağlar.
      final persons = await ApiService.getPersons();

      // Sunucudan veriler başarıyla geldiyse listemizi güncelliyoruz.
      setState(() {
        _persons = persons; // Gelen kişi listesini yerel değişkenimize aktar.
        _isLoading = false; // Yükleme bittiği için çarkı gizle.
      });
    } catch (e) {
      // Sunucu kapalıysa, internet yoksa veya sunucudan hata döndüyse 'catch' bloğu yakalar.
      setState(() {
        _errorMessage = e.toString(); // Hata metnini kaydet.
        _isLoading = false; // Yükleme bittiği için çarkı kapat.
      });
    }
  }

  // build: Flutter'ın ekranı piksel piksel çizdiği ana fonksiyon.
  // setState her çağrıldığında bu build fonksiyonu baştan çalışarak ekranı yeniler.
  @override
  Widget build(BuildContext context) {
    // Scaffold: Sayfanın temel iskeletidir (üst bar, gövde, sağ alttaki buton vb.).
    return Scaffold(
      // AppBar: Ekranın en üstünde yer alan mavi başlık çubuğu.
      appBar: AppBar(
        title: const Text('Rehber / Kişi Listesi'),
        centerTitle: true, // Başlığı ekranın tam ortasına hizalar.
        backgroundColor: Colors.blue, // Üst barın arka plan rengi mavi.
        foregroundColor: Colors.white, // Üst bardaki yazıların ve simgelerin rengi beyaz.
      ),

      // body: Ekranın orta ana gövde kısmı.
      // _buildBody() fonksiyonu o anki duruma göre (yükleniyor, hata var veya liste hazır) arayüz üretir.
      body: _buildBody(),

      // floatingActionButton: Ekranın sağ alt köşesinde sabit duran dairesel buton (+).
      // Yönergede istenen "sağ altta sabit '+' simgeli buton".
      floatingActionButton: FloatingActionButton(
        // Butonun rengi mavi olsun.
        backgroundColor: Colors.blue,
        // Butonun içindeki simge artı (+) simgesi.
        child: const Icon(Icons.add, color: Colors.white),
        // Butona tıklandığında çalışacak fonksiyon:
        onPressed: () async {
          // Navigator.push: Yeni bir sayfaya (Yeni Kişi Ekleme Formuna) geçiş yapar.
          // 'await' koyduk çünkü kullanıcı yeni kişi ekleyip geri döndüğünde sonucu beklemek istiyoruz.
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonFormScreen(),
            ),
          );

          // Eğer form sayfasından dönerken 'true' değeri döndüyse (yani yeni kişi eklendiyse):
          if (result == true) {
            // Yeni eklenen kişiyi de görebilmek için listeyi sunucudan tekrar çek ve yenile.
            _fetchPersons();
          }
        },
      ),
    );
  }

  // _buildBody: Ekranın ortasında ne gösterileceğine karar veren yardımcı fonksiyon.
  Widget _buildBody() {
    // 1. DURUM: Veriler hâlâ sunucudan yükleniyorsa ekranda dönen mavi bir çark göster.
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Dönen yükleme animasyonu.
      );
    }

    // 2. DURUM: Bir bağlantı hatası oluştuysa kırmızı hata uyarısı ve tekrar deneme butonu göster.
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Kenarlardan 20 piksel boşluk bırak.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Ortala.
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60), // Büyük kırmızı hata ikonu.
              const SizedBox(height: 12), // Boşluk.
              const Text(
                'Sunucuya bağlanılamadı!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!, // Hata detay metni.
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              // Tekrar Dene Butonu: Kullanıcı basınca veriyi tekrar çekmeyi dener.
              ElevatedButton.icon(
                onPressed: _fetchPersons, // Butona basınca _fetchPersons fonksiyonunu çalıştır.
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. DURUM: Sunucudan veri geldi ama veritabanında hiç kişi yoksa (boşsa):
    if (_persons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 70, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Henüz kayıtlı kişi bulunmamaktadır.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text('Sağ alttaki + butonuna basarak ilk kişiyi ekleyin.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPersons,
              child: const Text('Yenile'),
            ),
          ],
        ),
      );
    }

    // 4. DURUM: Veriler başarıyla geldi! Kaydırılabilir liste (ListView) oluştur.
    // RefreshIndicator: Kullanıcı listeyi aşağı doğru parmağıyla çektiğinde listeyi yenilemeyi sağlar.
    return RefreshIndicator(
      onRefresh: _fetchPersons, // Aşağı çekince _fetchPersons çalışsın.
      // ListView.builder: Çok sayıda öğeyi hafızayı yormadan sadece ekranda görünen kadarını çizen performanslı liste widget'ı.
      child: ListView.builder(
        itemCount: _persons.length, // Listedeki toplam eleman sayısı (kaç kişi varsa).
        itemBuilder: (context, index) {
          // O anki sıradaki kişiyi alıyoruz (0. eleman, 1. eleman vb.).
          final person = _persons[index];

          // Her bir kişi için şık bir kart (Card) tasarımı oluşturuyoruz.
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Kartlar arası dış boşluk.
            elevation: 2, // Karta hafif gölge efekti verir.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Kartın köşelerini 10 piksel yuvarlat.
            ),
            // ListTile: Başlık, alt başlık ve sol tarafında ikon/resim olan hazır liste satır bileşeni.
            child: ListTile(
              // leading: Yönerge kuralı: "Solda dairesel profil fotoğrafı (ağ resmi)".
              leading: CircleAvatar(
                radius: 26, // Dairenin yarıçap büyüklüğü.
                backgroundColor: Colors.blue.shade100, // Resim yüklenemezse arkada açık mavi renk kalsın.
                // Eğer kişinin geçerli bir fotoğraf adresi (photoUrl) varsa internetten resmi çek.
                backgroundImage: (person.photoUrl != null && person.photoUrl!.isNotEmpty)
                    ? NetworkImage(person.photoUrl!) // İnternetteki adresten resmi yükle.
                    : null, // Resim linki yoksa boş bırak.
                // Eğer fotoğraf linki yoksa veya null ise dairenin içine varsayılan kişi simgesi koy.
                child: (person.photoUrl == null || person.photoUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.blue, size: 28)
                    : null,
              ),

              // title: Yönerge kuralı: "Kalın yazı tipiyle Ad-Soyad".
              title: Text(
                person.fullName, // Kişinin tam adı.
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Kalın yazı tipi (Bold).
                  fontSize: 16, // Yazı boyutu.
                ),
              ),

              // subtitle: Yönerge kuralı: "Altında Departman bilgisi gösterilir".
              subtitle: Text(
                person.department, // Kişinin departmanı (Örn: Yazılım Geliştirme).
                style: TextStyle(
                  color: Colors.grey.shade700, // Koyu gri renk.
                  fontSize: 14,
                ),
              ),

              // trailing: Satırın en sağında sağa ok simgesi gösteriyoruz.
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

              // onTap: Yönerge kuralı: "Listeden bir satıra tıklandığında seçilen kişinin benzersiz ID'si ile Detay Sayfası açılmalıdır".
              onTap: () async {
                // Detay sayfasına geçiş yap ve kişinin ID'sini parametre olarak gönder.
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Detay sayfasına kişinin id'sini ve mevcut verisini gönderiyoruz.
                    builder: (context) => PersonDetailScreen(personId: person.id!),
                  ),
                );

                // Eğer detay sayfasında kişi silindiyse veya düzenlendiyse geri dönüldüğünde listeyi yenile.
                if (result == true) {
                  _fetchPersons();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
