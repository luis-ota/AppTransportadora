import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/providers/admin/usuarios_provider_adm.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:apprubinho/providers/frete_card_provider.dart';
import 'package:apprubinho/providers/user_provider.dart';
import 'package:apprubinho/screens/admin/fatura_adm/fatura_page_adm.dart';
import 'package:apprubinho/screens/admin/faturamento_adm/faturamento_page_adm.dart';
import 'package:apprubinho/screens/admin/fretes_usuarios_adm/fretes_usuarios_page_adm.dart';
import 'package:apprubinho/screens/admin/pagamentos_adm/pagamentos_page_adm.dart';
import 'package:apprubinho/screens/form_frete_page.dart';
import 'package:apprubinho/screens/homepage.dart';
import 'package:apprubinho/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:apprubinho/screens/admin/despesas_adm/despesas_page_adm.dart';
import 'package:apprubinho/screens/admin/homepage_adm.dart';
import 'package:apprubinho/screens/admin/usuarios_adm/usuarios_page_adm.dart';
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
          '/home/form_despesa_page': (context) => const FormDespesaPage(
                admin: false,
              ),
          '/home/form_abastecimento_page': (context) =>
              const FormAbastecimentoPage(
                admin: false,
              ),

          //admin
          '/home/admin/homepage_adm': (context) => const HomePageAdm(),
          '/home/admin/usuarios_page_adm': (context) => const UsuariosPageAdm(),
          '/home/admin/despesas_page_adm': (context) => const DespesasPageAdm(),
          '/home/admin/pagamentos_page_adm': (context) =>
              const PagamentosPageAdm(),
          '/home/admin/faturamento_page_adm': (context) =>
              const FaturamentoPageAdm(),
          '/home/admin/fatura_page_adm': (context) => const FaturaPageAdm(),
          '/home/admin/fretes_usuarios_page_adm': (context) =>
              const FretesUsuariosPageAdm(),
        },
      ),
    );
  }
}
