// person.dart - Kişi veri modeli dosyasıdır.
// Bu dosya, API'den gelen JSON verisini Dart nesnesine çeviren sınıfı içerir.
// Model, verinin yapısını (hangi alanları olduğunu) tanımlar.
// JSON → Dart nesnesi ve Dart nesnesi → JSON dönüşümlerini yapar.

// Person sınıfı: Bir kişinin tüm bilgilerini tutan veri yapısıdır.
// API'den gelen her kişi kaydı bu sınıfın bir örneği (instance) olur.
class Person {
  // Sınıfın alanları (fields): Her kişinin sahip olduğu bilgiler.
  // final anahtar kelimesi, bu alanların oluşturulduktan sonra değiştirilemeyeceğini belirtir.

  final int? id;           // Kişinin benzersiz kimlik numarası. Yeni kayıtta null olabilir (?).
  final String fullName;   // Kişinin tam adı ve soyadı. Örnek: "Ahmet Yılmaz"
  final String department; // Kişinin departmanı. Örnek: "Yazılım Geliştirme"
  final String? photoUrl;  // Kişinin fotoğraf bağlantısı. Boş olabilir (?) bu yüzden nullable.
  final String birthPlace; // Kişinin doğum yeri. Örnek: "Adana"
  final String birthDate;  // Kişinin doğum tarihi. Örnek: "1994-04-12"
  final String email;      // Kişinin e-posta adresi. Örnek: "ahmet@sirket.com"
  final String phone;      // Kişinin telefon numarası. Örnek: "+905550123456"

  // Constructor (Yapıcı metot): Person nesnesi oluşturmak için kullanılır.
  // required anahtar kelimesi, bu parametrelerin zorunlu olduğunu belirtir.
  // this.id gibi yazımlar, parametreyi doğrudan aynı isimdeki alana atar.
  Person({
    this.id,                    // id zorunlu değil (yeni kayıtta henüz ID yok).
    required this.fullName,     // Ad soyad zorunlu.
    required this.department,   // Departman zorunlu.
    this.photoUrl,              // Fotoğraf URL zorunlu değil.
    required this.birthPlace,   // Doğum yeri zorunlu.
    required this.birthDate,    // Doğum tarihi zorunlu.
    required this.email,        // E-posta zorunlu.
    required this.phone,        // Telefon zorunlu.
  });

  // fromJson: JSON verisinden (Map) bir Person nesnesi oluşturan fabrika metottur.
  // API'den gelen JSON verisi bu metot ile Dart nesnesine dönüştürülür.
  // factory anahtar kelimesi, bu metodun her zaman yeni bir nesne döndüreceğini belirtir.
  // Map<String, dynamic> tipindeki json parametresi, anahtar-değer çiftlerinden oluşan bir haritadır.
  // Örnek JSON: {"id": 1, "fullName": "Ahmet", ...}
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],                 // JSON'daki 'id' anahtarının değerini al.
      fullName: json['fullName'],     // JSON'daki 'fullName' anahtarının değerini al.
      department: json['department'], // JSON'daki 'department' anahtarının değerini al.
      photoUrl: json['photoUrl'],     // JSON'daki 'photoUrl' anahtarının değerini al (null olabilir).
      birthPlace: json['birthPlace'], // JSON'daki 'birthPlace' anahtarının değerini al.
      birthDate: json['birthDate'],   // JSON'daki 'birthDate' anahtarının değerini al.
      email: json['email'],           // JSON'daki 'email' anahtarının değerini al.
      phone: json['phone'],           // JSON'daki 'phone' anahtarının değerini al.
    );
  }

  // toJson: Person nesnesini JSON formatına (Map) çeviren metottur.
  // API'ye veri gönderirken (POST, PUT) bu metot kullanılır.
  // Dart nesnesi → JSON dönüşümü yapar.
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,     // Ad soyadı JSON'a ekle.
      'department': department, // Departmanı JSON'a ekle.
      'photoUrl': photoUrl,     // Fotoğraf URL'sini JSON'a ekle.
      'birthPlace': birthPlace, // Doğum yerini JSON'a ekle.
      'birthDate': birthDate,   // Doğum tarihini JSON'a ekle.
      'email': email,           // E-postayı JSON'a ekle.
      'phone': phone,           // Telefonu JSON'a ekle.
    };
    // NOT: id'yi JSON'a eklemiyoruz çünkü id sunucu tarafından otomatik atanır.
  }
}
