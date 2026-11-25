import 'package:flutter/material.dart';
import 'package:myportfolio_mobile/screens/menu.dart';
import 'package:myportfolio_mobile/services/api_client.dart';
import 'package:myportfolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.apiClient});

  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    final client = apiClient;
    return MultiProvider(
      providers: [
        if (client == null)
          Provider(create: (_) => ApiClient(), dispose: (_, api) => api.close())
        else
          Provider.value(value: client),
        ChangeNotifierProvider(create: (context) => AuthState(context.read())),
      ],
      child: MaterialApp(
        title: 'My Portfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber[700],
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
