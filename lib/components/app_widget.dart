import 'package:app_caminhao/screens/form_frete_page.dart';
import 'package:app_caminhao/screens/homepage.dart';
import 'package:app_caminhao/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_caminhao/providers/user_provider.dart';
import 'package:app_caminhao/providers/despesas_provider.dart';
import 'package:app_caminhao/providers/frete_card_provider.dart';


class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DespesasProvider()),
        ChangeNotifierProvider(create: (context) => FreteCardAndamentoProvider()),
        ChangeNotifierProvider(create: (context) => FreteCardConcluidoProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,

        ],
        supportedLocales: const [Locale('pt', 'BR')],
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomePage(),
          '/home/perfil': (context) => const PerfilPage(),
          '/home/form_frete_page': (context) => const FormFretePage(),
        },
      ),
    );
  }
}