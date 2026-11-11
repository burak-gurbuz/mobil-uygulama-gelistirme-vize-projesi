// Bu dosya Flutter projesinin ana giriş noktasıdır.
// Flutter uygulaması çalıştırıldığında ilk bu dosya çalışır.
// MaterialApp widget'ı ile uygulamanın temasını ve ana sayfasını belirleriz.

import 'package:flutter/material.dart'; // Flutter'ın temel UI (kullanıcı arayüzü) kütüphanesi.
import 'screens/person_list_screen.dart'; // Ana sayfa olan kişi listesi ekranını içe aktarıyoruz.

// main() fonksiyonu: Uygulamanın başlangıç noktasıdır.
// Dart programları her zaman main() fonksiyonundan başlar.
// runApp() fonksiyonu, verilen widget'ı ekrana yerleştirir ve uygulamayı başlatır.
void main() {
  runApp(const MyApp()); // MyApp widget'ını çalıştır ve ekrana yerleştir.
}

// MyApp sınıfı: Uygulamanın kök (root) widget'ıdır.
// StatelessWidget'tan türetilir çünkü bu widget'ın durumu (state) değişmez.
// Sadece uygulama temasını ve başlangıç ekranını belirler.
class MyApp extends StatelessWidget {
  // const constructor: Bu widget değişmez (immutable) olduğu için const kullanıyoruz.
  // key parametresi Flutter'ın widget'ları takip etmesi için kullanılır.
  const MyApp({super.key});

  // build metodu: Widget'ın ekranda nasıl görüneceğini belirler.
  // Flutter her widget için bu metodu çağırarak UI'ı oluşturur.
  @override
  Widget build(BuildContext context) {
    // MaterialApp: Google'ın Material Design tasarım dilini kullanan uygulama widget'ı.
    // Tema, yönlendirme (navigation) ve temel uygulama yapısını sağlar.
    return MaterialApp(
      // Uygulamanın başlığı (tarayıcı sekmesinde veya uygulama değiştiricide görünür).
      title: 'Kişi Yönetim Sistemi',

      // debugShowCheckedModeBanner: false yaparak sağ üstteki "DEBUG" etiketini kaldırıyoruz.
      // Bu sadece görsel bir ayardır, uygulamanın çalışmasını etkilemez.
      debugShowCheckedModeBanner: false,

      // theme: Uygulamanın genel görünüm temasını belirler (renkler, yazı tipleri vb.).
      theme: ThemeData(
        // colorSchemeSeed: Tema renklerinin türetileceği ana renk.
        // Colors.blue mavi tonlarında bir tema oluşturur.
        colorSchemeSeed: Colors.blue,

        // useMaterial3: Material Design 3 (en yeni tasarım sistemi) kullanılsın mı?
        // true yaparak modern görünüm elde ediyoruz.
        useMaterial3: true,
      ),

      // home: Uygulama açıldığında gösterilecek ilk ekran (ana sayfa).
      // PersonListScreen, kişi listesini gösteren ekranımızdır.
      home: const PersonListScreen(),
    );
  }
}
