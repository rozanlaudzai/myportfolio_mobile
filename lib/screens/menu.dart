import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/widgets/left_drawer.dart';
import 'package:myportfolio_mobile/widgets/page_card.dart';

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
    ItemHomePage('Show Projects', Icons.folder, Colors.yellow),
    ItemHomePage('Add a Project', Icons.add_circle, Colors.yellow),
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

      drawer: const LeftDrawer(),

      // Body halaman utama dengan padding di sekelilingnya.
      body: SingleChildScrollView(
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
                    crossAxisCount: 3,
                    // shrinkWrap agar ukuran kisi menyesuaikan tinggi konten anak.
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: items.map((ItemHomePage item) => ItemCard(item)).toList(),
                  ),
                ],
              ),
            ),

            const Text('This is Column:'),
            Column(
              children: [
                const Text('mantap'),
                const Text('gila kamu'),
                const Icon(Icons.person)
              ],
            ),

            const Text('This is Row:'),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                const Icon(Icons.person_2),
                const Icon(Icons.person_2_outlined),
                const Icon(Icons.person_3_sharp),
                const SizedBox(width: 5),
                const Text('Burhan bruh'),
                const Icon(Icons.edit),
              ],
            ),

            // === Learning Space ===
            const Text('This is Stack:'),
            Stack(
              alignment: .center,
              children: [
                Container(
                  width: 200,
                  height: 120,
                  color: Colors.blue,
                ),
                const Text(
                  'My Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'walawe',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const Text('This is GridView:'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                Card(
                  child: Text('Card 1'),
                ),
                Card(
                  child: Text('Card 2'),
                ),
                Card(
                  child: Text('Card 3'),
                ),
              ]
            ),
            // === End of Learning Space ===

          ],
        ),
      ),
    );
  }
}
