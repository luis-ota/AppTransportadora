import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DespesasPageAdm extends StatefulWidget {
  const DespesasPageAdm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DespesasPageState();
  }
}

class _DespesasPageState extends State<DespesasPageAdm> {
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user?.email == 'rubens@apprubinho.com') {
      return Visibility(
        visible: user?.email == 'rubens@apprubinho.com',
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Administração'),
              backgroundColor: const Color(0xFF43A0E4),
              actions: [
                IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () =>
                        Navigator.pushNamed(context, "/home/perfil")),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outlined,
                      size: 50,
                    ),
                    title: const Text('Usuarios'),
                    subtitle: const Text('Editar ou criar usuarios'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const ImageIcon(
                      AssetImage("lib/assets/img/caminhao.png"),
                      size: 50,
                    ),
                    title: const Text('Fretes'),
                    subtitle: const Text('Fretes de todos os usuarios'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const ImageIcon(
                      AssetImage("lib/assets/img/despesas_icon.png"),
                      size: 40,
                    ),
                    title: const Text('Despesas'),
                    subtitle: const Text('Manutenção e Abastecimento'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.monetization_on_outlined,
                      size: 50,
                    ),
                    title: const Text('Pagamentos'),
                    subtitle: const Text('Pagamento aos caminhoneiros'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.analytics_outlined,
                      size: 50,
                    ),
                    title: const Text('Faturamento'),
                    subtitle: const Text('Lucros e despesas'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      size: 50,
                    ),
                    title: const Text('Fatura'),
                    subtitle: const Text('Verifique sua fatura mensal'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: MaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.home), Text('Voltar')],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text('Tranportadora Rubinho'),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: SizedBox(
          height: double.maxFinite,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Voce nao tem acesso a essa área',
                  style: TextStyle(fontSize: 19),
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, "/home"),
                    child: const Text("Voltar"))
              ],
            ),
          ),
        ),
      ));
    }
  }
}
