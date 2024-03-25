import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/models/pagamento_model.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseService _dbPagamentos = FirebaseService();

class PagamentosProvider with ChangeNotifier {
  final Map<String, FreteCardDados> pagamentosUsuarios = {
    '0': FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: '')
  };

  List<FreteCardDados> get all {
    return [...pagamentosUsuarios.values];
  }

  int get count {
    return pagamentosUsuarios.length;
  }

  FreteCardDados byIndex(int i) {
    return pagamentosUsuarios.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        pagamentosUsuarios.containsKey(freteCard.freteId)) {
      pagamentosUsuarios.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      pagamentosUsuarios.putIfAbsent(
          id,
          () => FreteCardDados(
              origem: freteCard.origem,
              compra: freteCard.compra,
              destino: freteCard.destino,
              venda: freteCard.venda,
              data: freteCard.data,
              placaCaminhao: freteCard.placaCaminhao,
              status: 'Em andamento',
              freteId: id));
    }
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    pagamentosUsuarios.remove(freteCard.freteId);
    notifyListeners();
  }

  Future<double> carregarDadosDoBanco(String? uid) async {
    pagamentosUsuarios.clear();
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));
    String ultimoFrete =
        await PagamentosConcluidosProvider().carregarDadosDoBanco(uid);
    double total = 0;
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbPagamentos.lerDadosBanco('Fretes', uid: uid!);
    final anoAtual = DateTime.now().year.toString();
    if (dados?['Concluido'] != null) {
      dados?['Concluido'][anoAtual][mesAtual].forEach((key, value) {
        if (double.tryParse(key)! > double.tryParse(ultimoFrete)!) {
          put(FreteCardDados(
              origem: value['origem'],
              compra: formatToReal(value['compra']),
              destino: value['destino'],
              venda: formatToReal(value['venda']),
              data: value['data'].substring(0, 5),
              placaCaminhao: value['placaCaminhao'],
              status: 'Concluido',
              freteId: key));

          total += (double.tryParse(value['venda'])! -
              double.tryParse(value['compra'])!);
        }
      });
    }

    organizar();
    return total;
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> pagamentosOrdenados = {};

    List<String> chavesOrdenadas = pagamentosUsuarios.keys.toList();
    chavesOrdenadas.sort((b, a) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      pagamentosOrdenados[chave] = pagamentosUsuarios[chave]!;
    }
    pagamentosUsuarios.clear();
    put(FreteCardDados(
        freteId: '0',
        origem: 'De',
        compra: 'Compra',
        destino: 'Para',
        data: 'Data',
        venda: 'Venda',
        placaCaminhao: '',
        status: ''));

    pagamentosUsuarios.addAll(pagamentosOrdenados);
    notifyListeners();
  }

  String formatToReal(
    String valor,
  ) {
    String texto = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(double.parse(valor));
    if (texto.substring(texto.length - 2) == '00') {
      return texto.substring(0, texto.length - 3);
    } else {
      return texto;
    }
  }
}

class PagamentosConcluidosProvider with ChangeNotifier {
  final Map<String, PagamentoDados> pagamentosUsuariosConcluidos = {};

  bool vazio = true;

  List<PagamentoDados> get all {
    return [...pagamentosUsuariosConcluidos.values];
  }

  int get count {
    return pagamentosUsuariosConcluidos.length;
  }

  PagamentoDados byIndex(int i) {
    return pagamentosUsuariosConcluidos.values.elementAt(i);
  }

  Future<void> put(PagamentoDados pagamento) async {
    if (pagamento.uid.trim().isNotEmpty &&
        pagamentosUsuariosConcluidos.containsKey(pagamento.uid)) {
      pagamentosUsuariosConcluidos.update(pagamento.uid, (_) => pagamento);
    } else {
      final id = pagamento.uid;
      pagamentosUsuariosConcluidos.putIfAbsent(
          id,
          () => PagamentoDados(
              data: pagamento.data,
              ultimoFrete: pagamento.ultimoFrete,
              valorTotal: pagamento.valorTotal,
              valorComissao: pagamento.valorComissao,
              uid: pagamento.uid));
    }

    notifyListeners();
  }

  Future<String> carregarDadosDoBanco(String? uid) async {
    pagamentosUsuariosConcluidos.clear();
    final dados = await _dbPagamentos.lerDadosBanco('Pagamentos', uid: uid);
    final anoAtual = DateTime.now().year.toString();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    if (dados != null) {
      Future<void> processarDados() async {
        for (var key in dados.keys) {
          var value = dados[key];
          await put(PagamentoDados(
            data: value['data'],
            ultimoFrete: value['ultimoFrete'],
            valorTotal: value['valorTotal'],
            valorComissao: value['valorComissao'],
            uid: key,
          ));
        }
      }

      await processarDados();
    }

    return organizar();
  }

  Future<String> organizar() async {
    Map<String, PagamentoDados> pagamentosConcluidosOrdenados = {};

    List<String> chavesOrdenadas = pagamentosUsuariosConcluidos.keys.toList();
    chavesOrdenadas.sort((b, a) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      pagamentosConcluidosOrdenados[chave] =
          pagamentosUsuariosConcluidos[chave]!;
    }
    pagamentosUsuariosConcluidos.clear();
    pagamentosUsuariosConcluidos.addAll(pagamentosConcluidosOrdenados);

    notifyListeners();
    if (pagamentosUsuariosConcluidos.isNotEmpty) {
      vazio = false;
      return pagamentosUsuariosConcluidos.values.last.ultimoFrete;
    }
    vazio = true;
    return '0';
  }

  Future<void> remover(PagamentoDados pagamento, uid) async {
    pagamentosUsuariosConcluidos.remove(pagamento.uid);
    if (pagamentosUsuariosConcluidos.values.isEmpty) {
      vazio == true;
    }
    notifyListeners();
  }

  Future<bool> pagamentoEfetuado(PagamentoDados pagamento, String uid) async {
    carregarDadosDoBanco(uid);
    PagamentosProvider().carregarDadosDoBanco(uid);
    return true;
  }
}
