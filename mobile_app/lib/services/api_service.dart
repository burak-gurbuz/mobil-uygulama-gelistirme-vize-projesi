// api_service.dart - API servis dosyasıdır.
// Bu dosya, Django backend API'sine HTTP istekleri gönderen fonksiyonları içerir.
// Tüm CRUD (Create, Read, Update, Delete) işlemleri bu dosyadan yapılır.
// Flutter uygulaması bu servis aracılığıyla sunucu ile iletişim kurar.

import 'dart:convert'; // JSON encode (kodlama) ve decode (çözme) işlemleri için gerekli kütüphane.
import 'package:flutter/foundation.dart'; // kIsWeb kontrolü: Uygulama Chrome'da mı yoksa Emülatörde mi çalışıyor anlamak için.
import 'package:http/http.dart' as http; // HTTP istekleri (GET, POST, PUT, DELETE) göndermek için paket.
import '../models/person.dart'; // Person model sınıfımızı içe aktarıyoruz.

// ApiService sınıfı: API ile iletişim kuran tüm fonksiyonları barındırır.
// Bu sınıfı kullanarak sunucudan veri çekebilir, ekleyebilir, güncelleyebilir ve silebiliriz.
class ApiService {

  // baseUrl: API'nin temel adresidir. Tüm istekler bu adres üzerine eklenir.
  // - Chrome / Tarayıcıda çalışırken: http://127.0.0.1:8000 (localhost)
  // - Android Emülatörde çalışırken: http://10.0.2.2:8000 (Android'in PC köprüsü)
  // Bu akıllı kontrol sayesinde hem Chrome'da hem de Emülatörde kod değiştirmeden çalışır!
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000'; // Web / Chrome için
    }
    return 'http://10.0.2.2:8000'; // Android Emülatör için
  }

  // =============================================
  // GET İSTEĞİ: Tüm kişileri sunucudan çeker.
  // =============================================
  // Bu fonksiyon asenkron (async) çalışır. Yani sunucudan yanıt gelene kadar
  // uygulamanın donmasını engeller, arka planda bekler.
  // Future<List<Person>> dönüş tipi: Gelecekte bir Person listesi döneceğini belirtir.
  static Future<List<Person>> getPersons() async {
    // http.get() ile sunucuya GET isteği gönderiyoruz.
    // Uri.parse() metodu, metin olan URL'yi Uri nesnesine çevirir.
    // await anahtar kelimesi, sunucudan yanıt gelene kadar bekler.
    final response = await http.get(
      Uri.parse('$baseUrl/api/persons/'), // İstek adresi: http://10.0.2.2:8000/api/persons/
    );

    // Sunucudan gelen yanıtın durum kodunu kontrol ediyoruz.
    // 200 = Başarılı (OK) demektir.
    if (response.statusCode == 200) {
      // Sunucudan gelen JSON metnini Dart listesine çeviriyoruz.
      // jsonDecode() JSON metnini Dart nesnesine dönüştürür.
      // response.body sunucunun gönderdiği JSON metnidir.
      List<dynamic> jsonList = jsonDecode(response.body);

      // JSON listesindeki her bir öğeyi Person nesnesine çevirip yeni bir liste oluşturuyoruz.
      // .map() her öğe için verilen fonksiyonu çalıştırır.
      // .toList() sonucu tekrar liste formatına çevirir.
      return jsonList.map((json) => Person.fromJson(json)).toList();
    } else {
      // Başarısız yanıt aldıysak hata fırlatıyoruz.
      // throw, bir hata oluşturur ve çağıran fonksiyona bildirir.
      throw Exception('Kişiler yüklenemedi. Hata kodu: ${response.statusCode}');
    }
  }

  // =============================================
  // GET İSTEĞİ: Tek bir kişinin detaylarını çeker.
  // =============================================
  // id parametresi: Detayları istenen kişinin benzersiz numarası.
  static Future<Person> getPerson(int id) async {
    // Belirli bir kişinin bilgilerini almak için ID'yi URL'ye ekliyoruz.
    // Örnek: http://10.0.2.2:8000/api/persons/3/
    final response = await http.get(
      Uri.parse('$baseUrl/api/persons/$id/'), // $id yerine gerçek ID numarası gelir.
    );

    // Yanıt başarılıysa (200), JSON'u Person nesnesine çevirip döndürüyoruz.
    if (response.statusCode == 200) {
      return Person.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kişi detayı yüklenemedi. Hata kodu: ${response.statusCode}');
    }
  }

  // =============================================
  // POST İSTEĞİ: Yeni bir kişi kaydı oluşturur.
  // =============================================
  // person parametresi: Oluşturulacak kişinin bilgilerini içeren Person nesnesi.
  // Future<Person> dönüş tipi: Sunucunun oluşturduğu kişiyi (ID ile birlikte) döndürür.
  static Future<Person> createPerson(Person person) async {
    // http.post() ile sunucuya POST isteği gönderiyoruz.
    final response = await http.post(
      Uri.parse('$baseUrl/api/persons/'), // POST isteği bu adrese gider.
      headers: {
        // Content-Type başlığı, gönderdiğimiz verinin JSON formatında olduğunu belirtir.
        // Sunucu bu başlığa bakarak veriyi nasıl yorumlayacağını bilir.
        'Content-Type': 'application/json',
      },
      // body: Gönderilecek veri. Person nesnesini önce Map'e (toJson), sonra JSON metnine çeviriyoruz.
      // jsonEncode() Dart nesnesini JSON metnine dönüştürür.
      body: jsonEncode(person.toJson()),
    );

    // 201 = Oluşturuldu (Created) durum kodu. Kayıt başarıyla oluşturuldu demektir.
    if (response.statusCode == 201) {
      return Person.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kişi oluşturulamadı. Hata kodu: ${response.statusCode}');
    }
  }

  // =============================================
  // PUT İSTEĞİ: Mevcut bir kişinin bilgilerini günceller.
  // =============================================
  // id: Güncellenecek kişinin ID'si.
  // person: Yeni (güncellenmiş) bilgileri içeren Person nesnesi.
  static Future<Person> updatePerson(int id, Person person) async {
    // http.put() ile sunucuya PUT isteği gönderiyoruz.
    final response = await http.put(
      Uri.parse('$baseUrl/api/persons/$id/'), // Güncellenecek kişinin URL'si.
      headers: {
        'Content-Type': 'application/json', // Gönderilen verinin JSON olduğunu belirtiyoruz.
      },
      body: jsonEncode(person.toJson()), // Güncellenmiş verileri JSON olarak gönderiyoruz.
    );

    // 200 = Başarılı. Güncelleme başarıyla yapıldı demektir.
    if (response.statusCode == 200) {
      return Person.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kişi güncellenemedi. Hata kodu: ${response.statusCode}');
    }
  }

  // =============================================
  // DELETE İSTEĞİ: Bir kişi kaydını siler.
  // =============================================
  // id: Silinecek kişinin ID'si.
  // Future<void> dönüş tipi: Bu fonksiyon bir değer döndürmez (silme işlemi sonuç döndürmez).
  static Future<void> deletePerson(int id) async {
    // http.delete() ile sunucuya DELETE isteği gönderiyoruz.
    final response = await http.delete(
      Uri.parse('$baseUrl/api/persons/$id/'), // Silinecek kişinin URL'si.
    );

    // 204 = İçerik Yok (No Content). Silme başarılı ama döndürülecek veri yok demektir.
    if (response.statusCode != 204) {
      throw Exception('Kişi silinemedi. Hata kodu: ${response.statusCode}');
    }
    // 204 gelirse sessizce devam eder (başarılı silme).
  }
}
