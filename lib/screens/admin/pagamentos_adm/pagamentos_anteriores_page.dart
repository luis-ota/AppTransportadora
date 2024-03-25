import 'package:apprubinho/components/admin/pagamenetos_anteriores_card.dart';
import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/pagamentos_provider_adm.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class PagamentosAnterioresPage extends StatefulWidget {
  final UsuariosDados userDados;

  const PagamentosAnterioresPage({super.key, required this.userDados});

  @override
  State<StatefulWidget> createState() {
    return _PagamentosAnterioresPageState();
  }
}

class _PagamentosAnterioresPageState extends State<PagamentosAnterioresPage> {
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseService();
  late PagamentosConcluidosProvider pagamentosAnteriores = Provider.of(context);

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
              title: Text('Pagamentos ao ${widget.userDados.nome}'),
              backgroundColor: const Color(0xFF43A0E4),
            ),
            body: RefreshIndicator(
              onRefresh: () async =>
                  await Provider.of<PagamentosConcluidosProvider>(context,
                          listen: false)
                      .carregarDadosDoBanco(widget.userDados.uid),
              child: pagamentosAnteriores.vazio
                  ? const Center(
                      child: Text('Nenhum registro de pagamento'),
                    )
                  : ListView.builder(
                      itemCount: pagamentosAnteriores.count,
                      itemBuilder: (context, i) => PagamentoCard(
                            pagamento: (pagamentosAnteriores.all.elementAt(i)),
                            userDados: widget.userDados,
                          )),
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
