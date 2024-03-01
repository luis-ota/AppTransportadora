import 'package:apprubinho/screens/admin/usuarios_adm/form_usuarios_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class UsuariosPageAdm extends StatefulWidget {
  const UsuariosPageAdm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UsuariosPageState();
  }
}

class _UsuariosPageState extends State<UsuariosPageAdm> {
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
              title: const Text('Gerenciar usuarios'),
              backgroundColor: const Color(0xFF43A0E4),
            ),
            body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: const Text('Usuarios existentes'),
                    subtitle: const Text('Editar ou desativar'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_add_alt_1,
                      size: 40,
                    ),
                    title: const Text('Criar usuarios'),
                    subtitle: const Text('Criar novos usuarios'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const FormUsuarioPage())),
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
