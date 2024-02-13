
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/frete_card_provider.dart';

class HomePageAdm extends StatefulWidget {
  const HomePageAdm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageAdm> {
  bool _carregando = true;
  int currentPageIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    carregandoFretes();
  }

  @override
  Widget build(BuildContext context) {
    if (user?.uid == 'WYUO7BaXNCgqpVzqopIM0b6DiEl1') {
      return Visibility(
        visible: user?.uid == 'WYUO7BaXNCgqpVzqopIM0b6DiEl1',
        child: MaterialApp(
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
                    subtitle: const Text('Fretes de todos os usuarios'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.monetization_on_outlined, size: 50,),
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
                    leading: const Icon(Icons.analytics_outlined, size: 50,),
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
                        onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
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

  Future<void> carregandoFretes() async {
    await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
        .carregarDadosDoBanco();

    await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
        .carregarDadosDoBanco();
    setState(() {
      _carregando = false;
    });
  }
}
