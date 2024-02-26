import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/pagamentos_provider_adm.dart';
import 'package:apprubinho/screens/admin/pagamentos_adm/proximo_pagamento_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class PagamentosPageAdm extends StatefulWidget {
  final UsuariosDados card;

  const PagamentosPageAdm({super.key, required this.card});

  @override
  State<StatefulWidget> createState() {
    return _PagamentosPageState();
  }
}

class _PagamentosPageState extends State<PagamentosPageAdm> {
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  late bool _carregando = false;
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
              title: Text('Pagamentos ao ${widget.card.nome}'),
              backgroundColor: const Color(0xFF43A0E4),

            ),
            body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: _carregando
                        ?const CircularProgressIndicator()
                        :const Icon(
                      Icons.monetization_on_outlined,
                      size: 50,
                    ),
                    title: const Text('Proximo pagamento'),
                    subtitle: const Text('Comissao dos ultimos 15 dias'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        acessar();
                      },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const ImageIcon(
                      AssetImage("lib/assets/img/pagamento_ok.png"),
                      size: 50,
                      color: Colors.green,
                    ),
                    title: const Text('Pagamentos anteriores'),
                    subtitle: const Text('Pagamentos ja efetuados'),
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
  Future<void> acessar() async {
setState(() {
  _carregando=true;
});
    double total = await Provider.of<
        PagamentosProvider>(
        context, listen: false).carregarDadosDoBanco(widget.card.uid);

    if(mounted){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProximoPagamento(
            card: widget.card,
            total: total
          )));
    }
setState(() {
  _carregando=false;
});
  }
}
