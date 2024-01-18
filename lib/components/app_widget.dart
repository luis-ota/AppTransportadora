import 'package:app_caminhao/screens/homepage.dart';
import 'package:app_caminhao/screens/login_page.dart';
import 'package:app_caminhao/screens/perfil.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/home/perfil': (context) => PerfilPage(),
      },
    );
  }
}