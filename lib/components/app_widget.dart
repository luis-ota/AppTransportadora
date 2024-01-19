import 'package:app_caminhao/screens/form_frete_page.dart';
import 'package:app_caminhao/screens/homepage.dart';
import 'package:app_caminhao/screens/login_page.dart';
import 'package:app_caminhao/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: '/home',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/home/perfil': (context) => const PerfilPage(),
        '/home/form_frete_page': (context) => const FormFretePage(),
      },
    );
  }
}