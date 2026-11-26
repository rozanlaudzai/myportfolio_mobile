import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/screens/award_form.dart';
import 'package:myportfolio_mobile/screens/award_list_screen.dart';
import 'package:myportfolio_mobile/screens/project_form.dart';
import 'package:myportfolio_mobile/screens/project_list_screen.dart';
import 'package:myportfolio_mobile/widgets/auth_guard.dart';

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
        onTap: () async {
          final Widget? page = switch (item.name) {
            'Show Projects' => const ProjectListScreen(),
            'Add a Project' => const ProjectFormPage(),
            'Show Awards' => const AwardListScreen(),
            _ => null,
          };
          if (item.name == 'Logout') {
            await signOut(context);
          } else if (item.name == 'Add an Award') {
            if (await openAwardForm(context) && context.mounted) {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const AwardListScreen()),
              );
            }
          } else if (page != null) {
            if (page is ProjectFormPage && !await ensureLoggedIn(context)) {
              return;
            }
            if (!context.mounted) return;
            await Navigator.of(context)
                .push<void>(MaterialPageRoute(builder: (_) => page));
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('You pressed button ${item.name}!')),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
