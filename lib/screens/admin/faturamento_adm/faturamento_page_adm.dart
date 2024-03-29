import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../../services/firebase_service.dart';
import 'faturamento_caminhao_page.dart';
import 'faturamento_usuario_page.dart';

class FaturamentoPageAdm extends StatefulWidget {
  const FaturamentoPageAdm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FaturamentoPageState();
  }
}

class _FaturamentoPageState extends State<FaturamentoPageAdm> {
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final _dbFirebase = FirebaseService();
  late bool _carregandoUsuario = false;
  late bool _carregandoCaminhao = false;
  late Map<String, Card> cardsCaminhao;
  late Map<String, Map<String, double>> placas;

  @override
  void initState() {
    super.initState();
    cardsCaminhao = {};
    placas = {};
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
              title: const Text('Faturamento'),
              backgroundColor: const Color(0xFF43A0E4),
            ),
            body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: _carregandoUsuario
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.person,
                            size: 35,
                          ),
                    title: const Text('Por usuario'),
                    subtitle: const Text('Faturamento por usuario'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => acessar('usuarios'),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: _carregandoCaminhao
                        ? const CircularProgressIndicator()
                        : const ImageIcon(
                            AssetImage("lib/assets/img/caminhao.png"),
                            size: 35,
                          ),
                    title: const Text('Por caminhão'),
                    subtitle: const Text('Faturamento por usuario'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => acessar('caminhao'),
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

  void acessar(oque) async {
    setState(() {
      oque == 'usuarios'
          ? _carregandoUsuario = true
          : _carregandoCaminhao = true;
    });
    final cards = await gerarCards(oque);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => oque == 'usuarios'
              ? FaturamentoUsuarioPageAdm(
                  cards: cards[0],
                  total: [cards[1], cards[2]],
                )
              : FaturamentoCaminhaoPageAdm(
                  cards: cards[0],
                  total: [cards[1], cards[2]],
                ),
        ),
      );
    }
    setState(() {
      oque == 'usuarios'
          ? _carregandoUsuario = false
          : _carregandoCaminhao = false;
    });
  }

  Future<List> gerarCards(oque) async {
    List cards = [];
    List cardsEValores = [];
    final dados = await _dbFirebase.lerDadosBanco('Users', uid: '');
    double valorComissao = 0;
    double valorTotal = 0;
    if (dados != null) {
      for (var entry in dados.entries) {
        var key = entry.key;
        var value = entry.value;
        if (oque == 'usuarios') {
          cardsEValores = await carregarDadosBanco(key, value['nome']) ?? [];

          if (cardsEValores.isNotEmpty &&
              cardsEValores.first is Card &&
              cardsEValores is! List<Card?>) {
            cards.add(cardsEValores.first);
            valorTotal += cardsEValores[1] ?? 0;
            valorComissao += cardsEValores[2] ?? 0;
          }
        } else {
          await carregarDadosBancoCaminhao(
              key); // Espera a conclusão do carregamento dos dados
        }
      }
    }
    return oque == 'usuarios'?[cards, valorTotal, valorComissao]: [cardsCaminhao.values.toList(), valorTotal, valorComissao];
  }

  Future<List?> carregarDadosBanco(uid, String nome) async {
    final dados = await _dbFirebase.lerDadosBanco('Pagamentos', uid: uid);
    Map<String, double> dadosFaturamento = {
      'valorTotal': 0,
      'valorComissao': 0
    };
    dados?.forEach((key, value) {
      double vt = double.parse(value['valorTotal']);
      double vc = double.parse(value['valorComissao']);
      dadosFaturamento['valorTotal'] = dadosFaturamento['valorTotal']! + vt;
      dadosFaturamento['valorComissao'] =
          dadosFaturamento['valorComissao']! + vc;
    });

    return dados != null
        ? [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 35,
                ),
                title: Text(nome),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Ganhos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(dadosFaturamento['valorTotal'])}"),
                    Text(
                        "Custos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(dadosFaturamento['valorComissao'])}"),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 1.0,
                      indent: 10.0,
                      endIndent: 20.0,
                    ),
                    Text(
                        'Lucro: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(dadosFaturamento['valorTotal']! - dadosFaturamento['valorComissao']!)}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if (kDebugMode) {
                      print(uid);
                    }
                  },
                ),
                isThreeLine: true,
              ),
            ),
            dadosFaturamento['valorTotal'],
            dadosFaturamento['valorComissao']
          ]
        : null;
  }

  Future<void> carregarDadosBancoCaminhao(uid) async {
    final dados = await _dbFirebase.lerDadosBanco(
      'FretesC',
      uid: uid,
    );


    if (dados != null) {
      for (var entry in dados.entries) {
        var value = entry.value;
        var placa = value['placaCaminhao'];
        if (kDebugMode) {
          print(value['venda']);
        }
        // Verifica se a placa já existe no mapa
        if (placas.containsKey(placa)) {
          // Se existe, soma os novos valores aos valores existentes
          placas[placa]?['valorTotal'] =
              placas[placa]!['valorTotal']! + (double.parse(value['venda']) - double.parse(value['compra']));
          placas[placa]?['valorComissao'] =
              placas[placa]!['valorComissao']! + ((double.parse(value['venda']) - double.parse(value['compra'])) * 0.12);
        } else {
          // Se não existe, cria uma nova entrada no mapa
          placas[placa] = {
            'valorTotal': double.parse(value['venda']) - double.parse(value['compra']),
            'valorComissao': (double.parse(value['venda']) - double.parse(value['compra'])) * 0.12,
          };
        }
      }
    }

    for (var entry in placas.entries) {
      var placa = entry.key;
      var value = entry.value;
      cardsCaminhao.putIfAbsent(placa.toString(), () => const Card());
      cardsCaminhao.update(
        placa.toString(),
            (_) => Card(
          child: ListTile(
            leading: const Icon(
              Icons.person,
              size: 35,
            ),
            title: Text(placa),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ganhos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value['valorTotal'])}",
                ),
                Text(
                  "Custos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value['valorComissao'])}",
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 1.0,
                  indent: 10.0,
                  endIndent: 20.0,
                ),
                Text(
                  'Lucro: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value['valorTotal']! - value['valorComissao']!)}',
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                if (kDebugMode) {
                  print(uid);
                }
              },
            ),
            isThreeLine: true,
          ),
        ),
      );
      if (kDebugMode) {
        print('Placa: $placa');
      } // Adiciona este print
    }
    if (kDebugMode) {
      print('Cards Caminhao: $cardsCaminhao');
    } // Adiciona este print
  }
}
