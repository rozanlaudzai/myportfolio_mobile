import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/screens/award_form.dart';
import 'package:myportfolio_mobile/screens/award_list_screen.dart';
import 'package:myportfolio_mobile/screens/project_form.dart';
import 'package:myportfolio_mobile/screens/project_list_screen.dart';
import 'package:myportfolio_mobile/services/auth_state.dart';
import 'package:myportfolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, this.onAwardCreated});

  final Future<void> Function()? onAwardCreated;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'My Portfolio',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            onTap: () => _open(context, const ProjectListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _open(context, const ProjectFormPage(), guarded: true),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Awards'),
            onTap: () => _open(context, const AwardListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Award'),
            onTap: () async {
              final routeContext = ModalRoute.of(context)!.subtreeContext!;
              Navigator.pop(context);
              if (!await openAwardForm(routeContext) || !routeContext.mounted) {
                return;
              }
              final refresh = onAwardCreated;
              if (refresh != null) {
                await refresh();
              } else {
                await Navigator.of(routeContext).push<void>(
                  MaterialPageRoute(builder: (_) => const AwardListScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () {
              final routeContext = ModalRoute.of(context)!.subtreeContext!;
              Navigator.pop(context);
              if (isLoggedIn) {
                signOut(routeContext);
              } else {
                ensureLoggedIn(routeContext);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _open(
    BuildContext context,
    Widget page, {
    bool guarded = false,
  }) async {
    final routeContext = ModalRoute.of(context)!.subtreeContext!;
    Navigator.pop(context);
    if (guarded && !await ensureLoggedIn(routeContext)) return;
    if (!routeContext.mounted) return;
    await Navigator.of(routeContext)
        .push<void>(MaterialPageRoute(builder: (_) => page));
  }
}
