import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';

final FirebaseService _dbFrete = FirebaseService();

class VerUsuarioFreteCardAndamentoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _verUsuarioAdamentoCards = {};
  late String porcentagem;

  List<FreteCardDados> get all {
    return [..._verUsuarioAdamentoCards.values];
  }

  int get count {
    return _verUsuarioAdamentoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _verUsuarioAdamentoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        _verUsuarioAdamentoCards.containsKey(freteCard.freteId)) {
      _verUsuarioAdamentoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      _verUsuarioAdamentoCards.putIfAbsent(
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
    organizar();
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    _verUsuarioAdamentoCards.remove(freteCard.freteId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco(String? uid) async {
    _verUsuarioAdamentoCards.clear();
    Map? dadosPor =
        await _dbFrete.lerDadosBanco('PorcentagemPagamentos', uid: '');
    porcentagem = dadosPor?['porcentagem'];
    final dados = await _dbFrete.lerDadosBanco('FretesA', uid: uid!);

    if (dados != null) {
      dados.forEach((key, value) {
        put(FreteCardDados(
            origem: value['origem'],
            compra: value['compra'],
            destino: value['destino'],
            venda: value['venda'],
            data: value['data'],
            placaCaminhao: value['placaCaminhao'],
            status: 'Em andamento',
            freteId: key));
      });
    }
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = _verUsuarioAdamentoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _verUsuarioAdamentoCards[chave]!;
    }
    _verUsuarioAdamentoCards.clear();
    _verUsuarioAdamentoCards.addAll(fretesOrdenados);
    notifyListeners();
  }
}

class VerUsuarioFreteCardConcluidoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _verUsuarioConcluidoCards = {};
  late String porcentagem;

  List<FreteCardDados> get all {
    return [..._verUsuarioConcluidoCards.values];
  }

  int get count {
    return _verUsuarioConcluidoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _verUsuarioConcluidoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        _verUsuarioConcluidoCards.containsKey(freteCard.freteId)) {
      _verUsuarioConcluidoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      _verUsuarioConcluidoCards.putIfAbsent(
          id,
          () => FreteCardDados(
              origem: freteCard.origem,
              compra: freteCard.compra,
              destino: freteCard.destino,
              venda: freteCard.venda,
              data: freteCard.data,
              placaCaminhao: freteCard.placaCaminhao,
              status: 'Concluido',
              freteId: id));
    }

    notifyListeners();
  }

  Future<void> carregarDadosDoBanco(String? uid) async {
    _verUsuarioConcluidoCards.clear();
    Map? dadosPor =
        await _dbFrete.lerDadosBanco('PorcentagemPagamentos', uid: '');
    porcentagem = dadosPor?['porcentagem'];
    final dados = await _dbFrete.lerDadosBanco('FretesC', uid: uid!);
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final anoAtual = DateTime.now().year.toString();
    print(dados);
    if (dados != null) {
      dados.forEach((key, value) {
        put(FreteCardDados(
            origem: value['origem'],
            compra: value['compra'],
            destino: value['destino'],
            venda: value['venda'],
            data: value['data'],
            placaCaminhao: value['placaCaminhao'],
            status: 'Concluido',
            freteId: key));
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = _verUsuarioConcluidoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _verUsuarioConcluidoCards[chave]!;
    }
    _verUsuarioConcluidoCards.clear();
    _verUsuarioConcluidoCards.addAll(fretesOrdenados);
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    _verUsuarioConcluidoCards.remove(freteCard.freteId);
    notifyListeners();
  }
}
