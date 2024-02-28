import 'package:apprubinho/providers/admin/usuarios_provider_adm.dart';
import 'package:apprubinho/screens/admin/comissao_page.dart';
import 'package:apprubinho/screens/admin/usuarios_adm/lista_usuarios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_service.dart';

class HomePageAdm extends StatefulWidget {
  const HomePageAdm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageAdm> {
  int currentPageIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  late bool _carregandoFretesUsuarios = false;
  late bool _carregandoCustosUsuarios = false;
  late bool _carregandoPagamentosUsuarios = false;
  late bool _carregandoPorcentagemPagamentos = false;

  final FirebaseService _dbPagamentos = FirebaseService();

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
                    title: const Text('Usuarios (desenvolvendo)'),
                    subtitle: const Text('Editar ou criar usuarios'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: _carregandoFretesUsuarios
                        ? const CircularProgressIndicator()
                        : const ImageIcon(
                            AssetImage("lib/assets/img/caminhao.png"),
                            size: 50,
                          ),
                    title: const Text('Fretes'),
                    subtitle: const Text('Fretes de todos os usuarios'),
                    trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () async {
                          await acessarFretesUsuarios();
                        }),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: _carregandoCustosUsuarios
                        ? const CircularProgressIndicator()
                        : const ImageIcon(
                            AssetImage("lib/assets/img/despesas_icon.png"),
                            size: 40,
                          ),
                    title: const Text('Despesas'),
                    subtitle: const Text('Manutenção e Abastecimento'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async => await acessarCustosUsuarios(),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: _carregandoPagamentosUsuarios
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.monetization_on_outlined,
                            size: 50,
                          ),
                    title: const Text('Pagamentos'),
                    subtitle: const Text('Pagamento aos caminhoneiros'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async => await acessarPagamentosUsuarios(),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: _carregandoPorcentagemPagamentos
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.percent,
                            size: 50,
                          ),
                    title: const Text('Porcentagem Comissão'),
                    subtitle: const Text('Atualizar a % da comissão'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () async => await acessarPorcentagemComissao(),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.analytics_outlined,
                      size: 50,
                    ),
                    title: const Text('Faturamento (desenvolv..)'),
                    subtitle: const Text('Lucros e despesas'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      size: 50,
                    ),
                    title: const Text('Fatura (desenvolvendo)'),
                    subtitle: const Text('Verifique sua fatura mensal'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => {},
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

  acessarFretesUsuarios() async {
    setState(() {
      _carregandoFretesUsuarios = true;
    });
    await Provider.of<UsuariosProvider>(context, listen: false)
        .carregarDadosDoBanco();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListaUsuariosPageAdm(
                administrar: 'Fretes',
              )));
    }
    setState(() {
      _carregandoFretesUsuarios = false;
    });
  }

  acessarCustosUsuarios() async {
    setState(() {
      _carregandoCustosUsuarios = true;
    });
    await Provider.of<UsuariosProvider>(context, listen: false)
        .carregarDadosDoBanco();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListaUsuariosPageAdm(
                administrar: 'Custos',
              )));
    }
    setState(() {
      _carregandoCustosUsuarios = false;
    });
  }

  acessarPagamentosUsuarios() async {
    setState(() {
      _carregandoPagamentosUsuarios = true;
    });
    await Provider.of<UsuariosProvider>(context, listen: false)
        .carregarDadosDoBanco();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListaUsuariosPageAdm(
                administrar: 'Pagamentos',
              )));
    }
    setState(() {
      _carregandoPagamentosUsuarios = false;
    });
  }

  acessarPorcentagemComissao() async {
    setState(() {
      _carregandoPorcentagemPagamentos = true;
    });
    Map? dados =
        await _dbPagamentos.lerDadosBanco('PorcentagemPagamentos', uid: '');
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AtualizarPorcentagemComissaoPage(
                porcentagemAtual: dados?['porcentagem'],
              )));
    }
    setState(() {
      _carregandoPorcentagemPagamentos = false;
    });
  }

  acessarFaturamentoUsuarios() async {
    setState(() {
      _carregandoFretesUsuarios = true;
    });
    await Provider.of<UsuariosProvider>(context, listen: false)
        .carregarDadosDoBanco();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListaUsuariosPageAdm(
                administrar: '',
              )));
    }
    setState(() {
      _carregandoFretesUsuarios = false;
    });
  }

  acessarFaturaUsuarios() async {
    setState(() {
      _carregandoFretesUsuarios = true;
    });
    await Provider.of<UsuariosProvider>(context, listen: false)
        .carregarDadosDoBanco();

    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListaUsuariosPageAdm(administrar: '')));
    }
    setState(() {
      _carregandoFretesUsuarios = false;
    });
  }
}
