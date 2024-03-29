import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class FaturamentoCaminhaoPageAdm extends StatefulWidget {
  final List cards;
  final List total;

  const FaturamentoCaminhaoPageAdm(
      {super.key, required this.cards, required this.total});

  @override
  State<StatefulWidget> createState() {
    return FaturamentoCaminhaoPageState();
  }
}

class FaturamentoCaminhaoPageState extends State<FaturamentoCaminhaoPageAdm> {
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
                title: const Text('Faturamento por usuarios'),
                backgroundColor: const Color(0xFF43A0E4)),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: 570,
                    child: ListView.builder(
                      itemCount: widget.cards.length,
                      itemBuilder: (context, i){
                        Card? card = widget.cards[i];
                        if (card != null){
                          return card;
                        }
                        return const Visibility(visible: false, child: Card());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ganhos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.total[0])}",
                        style: const TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Custos: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.total[1])}",
                        style: const TextStyle(fontSize: 17),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                        height: 1.0,
                        indent: 10.0,
                        endIndent: 20.0,
                      ),
                      Text(
                        'Lucro: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(widget.total[0]! - widget.total[1]!)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),)
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
        ),
      );
    }
  }
}
