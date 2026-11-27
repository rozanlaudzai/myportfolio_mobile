# myportfolio_mobile

[![CI](https://github.com/rozanlaudzai/myportfolio_mobile/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/rozanlaudzai/myportfolio_mobile/actions/workflows/main.yaml)

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

## Run against Django on Windows

From the Django repository, with its virtual environment active:

```powershell
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

From this Flutter repository:

```powershell
flutter pub get
dart run build_runner build
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

For the Android emulator, run `flutter run` to use the default API address,
`http://10.0.2.2:8000`. Anyone can browse projects. Sign in with a Django
superuser account to add one.

## Assignment 9 setup

- [Django backend repository](https://github.com/rozanlaudzai/myportfolio)
- [Deployed Awards API](https://rozan-laudzai-myportfolio.pws.cs.ui.ac.id/api/v1/awards/)

For local development, use the Django revision with token authentication for
Awards and follow the Windows setup above. In Flutter, open **Show Awards**
or **Awards** in the drawer to browse and open an entry without signing in.
Use **Add award** and sign in as a Django superuser to save. The list reloads
after saving. The [Django Awards page](https://rozan-laudzai-myportfolio.pws.cs.ui.ac.id/awards/)
uses the same records on the deployed backend. For local verification, open
the Awards page at `http://localhost:8000/awards/`.

To run against the deployed API from Android, deploy the matching Django revision
and pass its origin to Flutter:

```powershell
flutter run --dart-define=API_BASE_URL=https://rozan-laudzai-myportfolio.pws.cs.ui.ac.id
```

For a Flutter Web client talking to a production Django instance, configure
`CORS_ALLOWED_ORIGINS` on Django with that client's origin. To check session
expiry locally, revoke the signed-in user's DRF token in Django Admin, then
save an award in Flutter. Sign in again and press **Save** to retry the
preserved draft.

The GitHub Actions workflow builds and uploads `app-release-apk` after CI passes.
Set the repository's Actions variable `API_BASE_URL` to an HTTPS Django origin
to target a deployed backend. If the variable is empty, the APK uses the
emulator address.

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

### Tugas 8

No. 1

- `Navigator.push()` digunakan untuk membuka halaman baru dengan menambahkannya ke atas navigation stack, sehingga halaman sebelumnya tetap tersimpan dan dapat dikunjungi kembali.
- `Navigator.pushReplacement()` digunakan untuk membuka halaman baru sekaligus menggantikan halaman yang sedang aktif pada navigation stack.
- `Navigator.pop()` digunakan untuk menutup halaman atau route yang sedang aktif dan kembali ke halaman sebelumnya.
- Kartu aksi Add a Project dan Add an Award menggunakan `Navigator.push()` dengan `MaterialPageRoute` untuk membuka `ProjectFormPage` dan `AwardFormPage`. Users dapat kembali ke halaman sebelumnya menggunakan tombol back.
- Opsi Home pada `LeftDrawer` menggunakan `Navigator.pushReplacement()` untuk mengganti halaman yang sedang aktif dengan `MyHomePage`. Metode ini memastikan halaman yang ditinggalkan tidak tetap berada pada posisi teratas navigation stack.

No. 2

- `Scaffold` menyediakan kerangka dasar tampilan halaman flutter yang mengatur komponen seperti `AppBar`, `Drawer`, dan `body`. `AppBar` berfungsi menampilkan judul halaman dan navigasi bagian atas. `Drawer` menyediakan menu navigasi yang dapat digunakan untuk berpindah antarhalaman.
- Pada project ini, `MyHomePage`, `ProjectFormPage`, dan `AwardFormPage` menggunakan struktur `Scaffold` yang serupa. Ketiganya juga menggunakan komponen `LeftDrawer` yang sama sehingga menu navigasi tetap konsisten dan tidak perlu ditulis ulang pada setiap halaman.
- Contoh konsistensi tema adalah penggunaan `Colors.indigo` sebagai `backgroundColor` pada `AppBar` di halaman utama maupun kedua halaman forms. Warna yang sama juga digunakan pada `DrawerHeader` dan tombol Save. Selain itu, `MaterialApp` menggunakan `ColorScheme.fromSeed()` dengan `Colors.indigo` sebagai warna dasar tema aplikasi.

No. 3

- Pada `ProjectFormPage` dan `AwardFormPage`, form disusun menggunakan `Column` di dalam `SingleChildScrollView`. `Column` dipilih karena setiap komponen form, seperti `TextFormField`, `DropdownButtonFormField`, dan tombol Save, perlu ditampilkan secara vertikal agar mudah dibaca dan diisi secara berurutan.
- Widget `Padding` digunakan untuk memberikan jarak di sekitar setiap input sebesar 8 piksel sehingga komponen form tidak saling berhimpitan. Selain itu, `Align` dengan `Alignment.bottomCenter` digunakan untuk mengatur posisi tombol Save agar berada di tengah secara horizontal pada bagian akhir form.
- `SingleChildScrollView` digunakan agar halaman bisa di-scroll secara vertikal ketika tinggi keseluruhan form melebihi ruang layar yang tersedia, misalnya pada perangkat dengan layar kecil atau ketika keyboard muncul sehingga pengguna tetap dapat mengakses seluruh kolom input dan tombol Save tanpa mengalami masalah overflow.

No. 4

- `GlobalKey<FormState>` digunakan untuk identify dan mengakses state dari widget `Form`. Melalui `_formKey.currentState`, aplikasi dapat menjalankan validasi terhadap seluruh field yang terdaftar dalam form.
- Properti `validator` digunakan untuk menentukan aturan validasi setiap input. Jika input tidak valid, fungsi mengembalikan pesan kesalahan. Sebaliknya, jika input valid, fungsi mengembalikan `null`.
- Ketika tombol Save ditekan, aplikasi memanggil `_formKey.currentState!.validate()`. Method ini menjalankan seluruh fungsi validator dan return true jika semua input valid. Jika validasi berhasil, aplikasi menampilkan AlertDialog yang menyatakan bahwa data berhasil ditambahkan.
- Contoh input yang ditolak adalah Project Name yang kosong atau hanya berisi spasi. Validasi menggunakan `value.trim().isEmpty` untuk mendeteksi kondisi tersebut dan menampilkan pesan `"Project name cannot be empty!"`.
- Pemilihan jenis input atau papan ketik aja belum cukup untuk menjamin validitas data karena hanya membantu pengguna memasukkan data, bukan memastikan data memenuhi aturan yang ditentukan. Misalnya, papan ketik teks tetap memungkinkan pengguna memasukkan spasi tanpa karakter bermakna. Oleh karena itu, validasi tetap diperlukan untuk memastikan data yang dimasukkan sesuai dengan kebutuhan aplikasi.

### Assignment 9

1. `@JsonSerializable(fieldRename: FieldRename.snake)` mengubah nama field Dart ke format JSON yang dipakai DRF. Contohnya, `awardedAt` dikirim sebagai `awarded_at`, sehingga POST tidak gagal dengan HTTP 400 karena nama field yang salah. `@JsonKey(includeToJson: false)` membuat ID tetap bisa dibaca dari respons tanpa ikut dikirim saat POST.
2. Future dibuat di `initState()` agar GET hanya berjalan sekali saat layar dibuka. Jika Future dibuat di `build()`, GET bisa terulang setiap kali UI diperbarui. `ApiException` membawa kode HTTP, jadi aplikasi bisa membedakan sesi kedaluwarsa (401), akses ditolak (403), dan daftar yang memang kosong.
3. `SessionAuthentication` menggunakan cookie sesi dan memeriksa CSRF saat browser mengirim operasi tulis. Flutter memakai `TokenAuthentication` karena bisa mengirim token lewat header `Authorization: Token <key>`. Autentikasi sesi tetap aktif agar web Django bisa memakai API yang sama.
4. Job `build` memakai Very Good Workflows untuk memasang dependensi, membuat kode JSON, mengecek format, menjalankan analisis, dan menjalankan tes dengan laporan cakupan. Jika lulus, `build_apk` membuat dan mengunggah APK release sebagai `app-release-apk`. File `*.g.dart` diabaikan Git karena CI membuatnya ulang dari model Dart.

## AI Disclosure

### Tugas 7

I did not use AI at all.

### Tugas 8

- Chat link: https://chatgpt.com/share/6b046342-b558-83ec-a85a-5ea8060b449a
- Helped to create `awarded_at` date time field in the award form

### Assignment 9

Saya menggunakan OpenAI Codex melalui Codex Desktop. Prompt berisi teks tugas,
struktur kedua repositori, stack, dan batasan perubahan Git. Codex memeriksa
serializer dan izin Django yang sudah ada, membantu mengintegrasikan Awards
di Flutter, menulis tes, dan menyusun dokumentasi termasuk draf jawaban reflektif.

Saran kode diperiksa terhadap payload `AwardSerializer` dan diuji secara lokal.
Contohnya, tanggal dipertahankan dalam format `YYYY-MM-DD`, sementara UUID dan
metadata bintang hanya dibaca dari respons. Tes memeriksa respons 401 dan
memastikan draf tetap tersedia setelah login ulang. Pengujian lokal tidak
membuktikan status workflow pada commit yang belum diterbitkan ke GitHub.
