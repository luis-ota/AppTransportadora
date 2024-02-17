import 'package:flutter/material.dart';

import '../models/fretecard_model.dart';
import '../services/firebase_service.dart';

final FirebaseService _dbFrete = FirebaseService();

class FreteCardAndamentoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _andamentoCards = {};

  List<FreteCardDados> get all {
    return [..._andamentoCards.values];
  }

  int get count {
    return _andamentoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _andamentoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        _andamentoCards.containsKey(freteCard.freteId)) {
      _andamentoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      _andamentoCards.putIfAbsent(
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
    _andamentoCards.remove(freteCard.freteId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    _andamentoCards.clear();
    final dados = await _dbFrete.lerDadosFretes();

    if (dados?['Em andamento'] != null) {
      dados?['Em andamento'].forEach((key, value) {
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

    List<String> chavesOrdenadas = _andamentoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _andamentoCards[chave]!;
    }
    _andamentoCards.clear();
    _andamentoCards.addAll(fretesOrdenados);
    notifyListeners();
  }
}

class FreteCardConcluidoProvider with ChangeNotifier {
  final Map<String, FreteCardDados> _concluidoCards = {};

  List<FreteCardDados> get all {
    return [..._concluidoCards.values];
  }

  int get count {
    return _concluidoCards.length;
  }

  FreteCardDados byIndex(int i) {
    return _concluidoCards.values.elementAt(i);
  }

  Future<void> put(FreteCardDados freteCard) async {
    if (freteCard.freteId.trim().isNotEmpty &&
        _concluidoCards.containsKey(freteCard.freteId)) {
      _concluidoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      final id = freteCard.freteId;
      _concluidoCards.putIfAbsent(
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

  Future<void> carregarDadosDoBanco() async {
    _concluidoCards.clear();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbFrete.lerDadosFretes();
    if (dados?['Concluido'] != null) {
      dados?['Concluido'].forEach((ano, value) {
        dados['Concluido']['$ano'].forEach((mes, value) {
          dados['Concluido']['$ano']['$mes'].forEach((key, value) {
            if (mes == mesAtual && ano == DateTime.now().year.toString()) {
              put(FreteCardDados(
                  origem: value['origem'],
                  compra: value['compra'],
                  destino: value['destino'],
                  venda: value['venda'],
                  data: value['data'],
                  placaCaminhao: value['placaCaminhao'],
                  status: 'Concluido',
                  freteId: key));
            }
          });
        });
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, FreteCardDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = _concluidoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _concluidoCards[chave]!;
    }
    _concluidoCards.clear();
    _concluidoCards.addAll(fretesOrdenados);
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    _concluidoCards.remove(freteCard.freteId);
    notifyListeners();
  }
}
