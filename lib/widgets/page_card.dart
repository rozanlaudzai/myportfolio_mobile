import 'package:material_ui/material_ui.dart';
import 'package:myportfolio_mobile/screens/award_form.dart';
import 'package:myportfolio_mobile/screens/project_form.dart';

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
          
          // Navigate ke halaman yang sesuai
          if (item.name == "Add a Project") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProjectFormPage()
              )
            );
          } else if (item.name == "Add an Award") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AwardFormPage()
              )
            );
          }
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