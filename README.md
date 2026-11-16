# myportfolio_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Pertanyaan Reflektif

### Tugas 7

1. Widgets di flutter membentuk struktur tree. Parents wrap children. Constraints go down. Sizes go up. Parent sets position.
2. Berikut widgets yang digunakan dan fungsinya:

| Widget        | Fungsi dalam proyek |
| ------------- | ------------------- |
| `MaterialApp` | Mengonfigurasi aplikasi, termasuk judul, tema Material Design 3, dan halaman utama. |
| `Scaffold`    | Menyediakan struktur dasar halaman yang terdiri atas `AppBar` dan `body`. |
| `AppBar`      | Menampilkan bilah bagian atas aplikasi dengan judul "My Portfolio". |
| `Material`    | Menjadi permukaan dasar `ItemCard`, mengatur warna dan sudut membulat, serta mendukung efek visual `InkWell`. |
| `InkWell`     | Membuat kartu menu dapat ditekan dan memberikan efek penggelapan warna saat ditekan. |
| `Padding`     | Memberikan jarak di sekitar child agar konten tidak terlalu dekat dengan tepi. |
| `Center`      | Menempatkan widget anak di tengah ruang yang tersedia. |
| `Column`      | Menyusun widget secara vertikal, seperti informasi pada kartu dan bagian utama halaman. |
| `Row`         | Menyusun tiga `InfoCard` secara horizontal. |
| `Text`        | Menampilkan teks seperti judul aplikasi, NPM, nama, kelas, dan label menu. |
| `Icon`        | Menampilkan ikon pada setiap menu, seperti folder, tambah, dan logout. |
| `Card`        | Membuat kartu informasi pengguna dengan tampilan Material Design dan efek bayangan. |
| `Container`   | Mengatur lebar dan padding konten di dalam `InfoCard`. |
| `SizedBox`    | Memberikan jarak vertikal antarwidget, misalnya sebesar 8 atau 16 piksel logis. |
| `GridView`    | Menampilkan lima menu portofolio dalam bentuk kisi dengan tiga kolom. |
| `SnackBar`    | Menampilkan pesan singkat ketika pengguna menekan salah satu menu. |
| `MyApp`       | Widget utama yang membangun `MaterialApp`, mengatur tema aplikasi, dan menentukan halaman awal. |
| `MyHomePage`  | Menampilkan halaman utama, termasuk informasi pengguna, pesan sambutan, dan menu portofolio. |
| `ItemCard`    | Menampilkan kartu menu dengan ikon, teks, warna khusus, serta respons ketika ditekan. |
| `InfoCard`    | Menampilkan informasi pengguna dalam kartu yang terdiri atas judul dan isi, seperti NPM, nama, serta kelas. |

3. `MaterialApp` adalah widget yang menyediakan konfigurasi dan fasilitas utama untuk membangun aplikasi Flutter menggunakan prinsip Material Design. Fungsi utamanya antara lain mengatur tema aplikasi, menyediakan dukungan navigasi antarlayar, menentukan halaman awal, mendukung lokalisasi, dan menyediakan konfigurasi yang dibutuhkan oleh berbagai widgets Material Design. `MaterialApp` umumnya digunakan di bagian atas widget tree karena konfigurasi seperti tema dan navigasi perlu tersedia bagi widget-widget di bawahnya.

4. State adalah data atau kondisi yang memengaruhi tampilan aplikasi. Pakai `StatelessWidget` jika tidak memerlukan states yang berubah. Sebaliknya, pakai `StatefulWidget` jika perlu menyimpan dan memperbarui states, e.g. counter value, user option, button condition.

5. `BuildContext` adalah objek yang merepresentasikan posisi sebuah widget dalam struktur widget tree Flutter. `BuildContext` merupakan interface dari objek `Element` yang menghubungkan widget dengan lokasi dan siklus hidupnya dalam tree. `BuildContext` penting karena memungkinkan suatu widget mengakses informasi atau fasilitas yang disediakan oleh widget lain di atasnya (ancestor). Beberapa penggunaannya adalah memperoleh tema aplikasi melalui `Theme.of(context)`, informasi layar melalui `MediaQuery.of(context)`, layanan navigasi melalui `Navigator.of(context)`, serta pengelolaan `SnackBar` melalui `ScaffoldMessenger.of(context)`.

6. *hot reload* digunakan untuk mempercepat pengembangan UI sambil mempertahankan state, *hot restart* digunakan untuk menjalankan ulang aplikasi pada level Dart dan menginisialisasi ulang state, sedangkan *full restart* diperlukan ketika aplikasi harus dihentikan dan dijalankan kembali, terutama setelah perubahan native atau konfigurasi build.

## AI Disclosure

### Tugas 7

I did not use AI at all.

