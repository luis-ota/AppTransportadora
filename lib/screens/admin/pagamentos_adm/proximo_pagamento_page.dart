import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/models/pagamento_model.dart';
import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/providers/admin/pagamentos_provider_adm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProximoPagamento extends StatefulWidget {
  final UsuariosDados userDados;
  final double total;

  const ProximoPagamento(
      {super.key, required this.userDados, required this.total});

  @override
  State<StatefulWidget> createState() {
    return _PagamentosPageState();
  }
}

class _PagamentosPageState extends State<ProximoPagamento> {
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  late PagamentosProvider pagamentos = Provider.of(context);
  late PagamentosConcluidosProvider concluirPagamentos =
      Provider.of(context, listen: false);
  late Map<String, FreteCardDados> pagamentosUsuarios =
      pagamentos.pagamentosUsuarios;
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
              title: Text('Pagamentos ao ${widget.userDados.nome}'),
              backgroundColor: const Color(0xFF43A0E4),
            ),
            body: _carregando
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 260,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  Provider.of<PagamentosProvider>(context)
                                      .count,
                              itemBuilder: (context, i) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${pagamentosUsuarios[pagamentosUsuarios.keys.toList()[i]]?.data}'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(limitarString(
                                                pagamentosUsuarios[
                                                        pagamentosUsuarios.keys
                                                            .toList()[i]]!
                                                    .origem)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(limitarString(
                                                pagamentosUsuarios[
                                                        pagamentosUsuarios.keys
                                                            .toList()[i]]!
                                                    .destino)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 95,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${(pagamentosUsuarios[pagamentosUsuarios.keys.toList()[i]]?.compra)}'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 95,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${(pagamentosUsuarios[pagamentosUsuarios.keys.toList()[i]]?.venda)}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$')
                                  .format(widget.total),
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Comissão: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$')
                                  .format(widget.total * 0.12),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  SizedBox(
                    width: 180,
                    child: MaterialButton(
                        textColor: Colors.green,
                        onPressed: () => pagamentoEfetuado(),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline),
                            Text('Pagamento Efetuado')
                          ],
                        )),
                  )
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

  String limitarString(String texto) {
    return texto.length <= 8 ? texto : "${texto.substring(0, 8)}...";
  }

  Future<void> pagamentoEfetuado() async {
    setState(() {
      _carregando = true;
    });
    PagamentoDados pagamentoDados = PagamentoDados(
        data: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ultimoFrete: pagamentosUsuarios.entries.last.value.freteId,
        valor: NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
            .format(widget.total * 0.12),
        uid: (DateTime.now())
            .toString()
            .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''));

    bool pagou = await concluirPagamentos.pagamentoEfetuado(
        pagamentoDados, widget.userDados.uid);
    if (mounted) {
      Navigator.of(context).pop(pagou);
    }
    setState(() {
      _carregando = false;
    });
  }
}
