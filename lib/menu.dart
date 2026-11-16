import 'package:flutter/material.dart';

class ItemHomePage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomePage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomePage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // menggunakan warna sekunder dari skema tema aplikasi
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.black.withValues(alpha: 0.3);
          }
          return null;
        }),
        // aksi ketika kartu ditekan oleh pengguna
        onTap: () {
          // menampilkan SnackBar dengan pesan interaktif
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('You pressed button ${item.name}!'))
            );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white)
                )
              ],
            )
          )
        )
      )
    );
  }
}

class InfoCard extends StatelessWidget {
  // kartu informasi yang menampilkan judul (title) dan isi (content)
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // memberikan efek bayangan kartu elevasi 2 unit
      elevation: 2.0,
      child: Container(
        // menyesuaikan lebar kartu dengan proporsi layar (dibagi 3.5)
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        // menyusun teks title dan content secara vertikal
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8.0),
            Text(content)
          ]
        )
      )
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = '2506547544';
  final String name = 'Rozan Laudzai';
  final String courseClass = 'PBP B';

  final List<ItemHomePage> items = [
    ItemHomePage('Show Experience', Icons.folder, Colors.blue),
    ItemHomePage('Add an Experience', Icons.add_circle, Colors.green),
    ItemHomePage('Show Awards', Icons.folder, Colors.purple),
    ItemHomePage('Add an Award', Icons.add_circle, Colors.brown),
    ItemHomePage('Logout', Icons.logout, Colors.red)
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'My Portfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // Body halaman utama dengan padding di sekelilingnya.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Baris horizontal untuk menampilkan 3 InfoCard secara sejajar.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: courseClass),
              ],
            ),

            const SizedBox(height: 16.0),

            // Bagian tengah: pesan sambutan dan kisi tombol menu portofolio.
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to My Portfolio Mobile!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // GridView menampilkan kartu tombol dalam tata letak kisi 3 kolom.
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    // shrinkWrap agar ukuran kisi menyesuaikan tinggi konten anak.
                    shrinkWrap: true,
                    children: items.map((ItemHomePage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
