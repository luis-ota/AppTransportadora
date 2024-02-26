import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/providers/admin/pagamentos_provider_adm.dart';
import 'package:apprubinho/providers/admin/usuarios_provider_adm.dart';
import 'package:apprubinho/providers/admin/custos_usuarios_provider.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:apprubinho/providers/custos_tabbar_provider.dart';
import 'package:apprubinho/providers/frete_card_provider.dart';
import 'package:apprubinho/providers/user_provider.dart';
import 'package:apprubinho/screens/form_frete_page.dart';
import 'package:apprubinho/screens/homepage.dart';
import 'package:apprubinho/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:apprubinho/screens/admin/homepage_adm.dart';
import 'package:apprubinho/screens/form_abastecimento_page.dart';
import 'package:apprubinho/screens/form_despesa_page.dart';

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
        ChangeNotifierProvider(
            create: (context) => CustosTabbarIndexProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
            create: (context) => FreteCardAndamentoProvider()),
        ChangeNotifierProvider(
            create: (context) => FreteCardConcluidoProvider()),
        ChangeNotifierProvider(create: (context) => DespesasProvider()),
        ChangeNotifierProvider(create: (context) => AbastecimentoProvider()),
        ChangeNotifierProvider(create: (context) => UsuariosProvider()),
        ChangeNotifierProvider(
            create: (context) => VerUsuarioFreteCardAndamentoProvider()),
        ChangeNotifierProvider(
            create: (context) => VerUsuarioFreteCardConcluidoProvider()),
        ChangeNotifierProvider(
            create: (context) => VerUsuarioAbastecimentoProvider()),
        ChangeNotifierProvider(
            create: (context) => VerUsuarioDespesaProvider()),
        ChangeNotifierProvider(
            create: (context) => PagamentosConcluidosProvider()),
        ChangeNotifierProvider(
            create: (context) => PagamentosProvider()),

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
          '/home/form_despesa_page': (context) => const FormDespesaPage(),
          '/home/form_abastecimento_page': (context) =>
              const FormAbastecimentoPage(),

          //admin
          '/home/admin/homepage_adm': (context) => const HomePageAdm(),
        },
      ),
    );
  }
}
