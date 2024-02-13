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
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              'Em andamento',
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
    final dados = await _dbFrete.lerDadosFretes();

    if (dados?['Em andamento'] != null) {
      dados?['Em andamento'].forEach((key, value) {
        put(FreteCardDados(
            value['origem'],
            value['compra'],
            value['destino'],
            value['venda'],
            value['data'],
            value['placaCaminhao'],
            'Em andamento',
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
              freteCard.origem,
              freteCard.compra,
              freteCard.destino,
              freteCard.venda,
              freteCard.data,
              freteCard.placaCaminhao,
              'Concluido',
              freteId: id));
    }

    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    final dados = await _dbFrete.lerDadosFretes();

    if (dados?['Concluido'] != null) {
      dados?['Concluido'].forEach((key, value) {
        put(FreteCardDados(value['origem'], value['compra'], value['destino'],
            value['venda'], value['data'], value['placaCaminhao'], 'Concluido',
            freteId: key));
      });
    }
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
