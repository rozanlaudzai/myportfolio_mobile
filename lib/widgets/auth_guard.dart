import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/screens/login_screen.dart';
import 'package:myportfolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final loggedIn = await Navigator.of(context)
      .push<bool>(MaterialPageRoute(builder: (_) => const LoginScreen()));
  return loggedIn ?? false;
}

Future<void> signOut(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (!auth.isLoggedIn) return;
  final messenger = ScaffoldMessenger.of(context);
  var message = 'Signed out.';
  try {
    await auth.logout();
  } on Exception {
    message = 'Signed out locally. The server could not revoke the token.';
  }
  if (messenger.mounted) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
