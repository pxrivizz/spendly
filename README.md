# 💰 Spendly - Akıllı Gider Takip Uygulaması

Spendly, finansal hayatınızı kontrol altına almanıza yardımcı olan, modern ve kullanıcı dostu bir Flutter mobil uygulamasıdır. Harcamalarınızı takip edin, bütçelerinizi yönetin ve finansal alışkanlıklarınızı analiz edin.

## 📱 Ekran Görüntüleri

| Dashboard | İşlemler | Analizler |
| :---: | :---: | :---: |
| ![Dashboard](https://via.placeholder.com/200x400?text=Dashboard) | ![İşlemler](https://via.placeholder.com/200x400?text=Transactions) | ![Analizler](https://via.placeholder.com/200x400?text=Analytics) |

## ✨ Özellikler

- **Modern Dashboard:** Günlük ve aylık finansal durumunuzu bir bakışta görün.
- **Harcama Takibi:** İşlemlerinizi kategorize edin ve hızlıca kaydedin.
- **Bütçe Yönetimi:** Kategoriler bazında bütçe limitleri belirleyin ve aşım yapmaktan kurtulun.
- **Detaylı Analizler:** Grafiklerle harcama trendlerinizi ve en çok harcama yaptığınız alanları keşfedin.
- **Bulut Senkronizasyonu:** Firebase ile verileriniz her zaman güvende ve tüm cihazlarınızda güncel.
- **Karanlık Mod & Premium Tasarım:** Göz yormayan, şık ve akıcı kullanıcı deneyimi.

## 🚀 Teknolojiler

Bu uygulama en güncel teknolojiler ve mimari yaklaşımlar kullanılarak geliştirilmiştir:

- **[Flutter](https://flutter.dev/):** UI Framework
- **[Riverpod](https://riverpod.dev/):** State Management
- **[Firebase](https://firebase.google.com/):** Auth, Firestore & Core hizmetleri
- **[GoRouter](https://pub.dev/packages/go_router):** Deklaratif navigasyon
- **[FL Chart](https://pub.dev/packages/fl_chart):** Veri görselleştirme
- **[Freezed](https://pub.dev/packages/freezed):** Immutable veri modelleri

## 🛠️ Kurulum

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları takip edin:

1. **Repoyu Klonlayın:**
   ```bash
   git clone https://github.com/pxrivizz/spendly.git
   cd spendly_mobile_app/spendly
   ```

2. **Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Kod Oluşturucuyu Çalıştırın:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Firebase Yapılandırması:**
   - [Firebase Console](https://console.firebase.google.com/)'da yeni bir proje oluşturun.
   - Android ve iOS uygulamalarını ekleyin.
   - `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ilgili dizinlere yerleştirin.

5. **Uygulamayı Çalıştırın:**
   ```bash
   flutter run
   ```

## 📂 Klasör Yapısı

Uygulama **Feature-first** (Özellik odaklı) katmanlı mimari kullanılarak yapılandırılmıştır:

```text
lib/
├── core/           # Ortak kullanılan bileşenler, yardımcı araçlar, temalar
├── features/       # Uygulama özellikleri
│   ├── analytics/  # Grafik ve analiz ekranları
│   ├── auth/       # Giriş ve kayıt işlemleri
│   ├── budget/     # Bütçe yönetimi
│   ├── dashboard/  # Ana ekran
│   └── transactions/# Harcama ekleme ve listeleme
└── main.dart       # Giriş noktası
```

## 📄 Lisans

Bu proje MIT Lisansı ile lisanslanmıştır.

---
*Geliştirici: [Halil Çiftçi](https://github.com/halilciftci)*
