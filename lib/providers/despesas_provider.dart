import 'package:apprubinho/models/despesas_model.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

final FirebaseService _dbFrete = FirebaseService();

class DespesasProvider with ChangeNotifier {
  final Map<String, DespesasDados> _despesasCards = {};

  List<DespesasDados> get all {
    return [..._despesasCards.values];
  }

  int get count {
    return _despesasCards.length;
  }

  DespesasDados byIndex(int i) {
    return _despesasCards.values.elementAt(i);
  }

  Future<void> put(DespesasDados despesaCard) async {
    if (despesaCard.despesaId.trim().isNotEmpty &&
        _despesasCards.containsKey(despesaCard.despesaId)) {
      _despesasCards.update(despesaCard.despesaId, (_) => despesaCard);
    } else {
      final id = despesaCard.despesaId;
      _despesasCards.putIfAbsent(
          id,
              () => DespesasDados(
                  despesaCard.despesa,
                  despesaCard.descricao,
                  despesaCard.valor,
                  despesaCard.tipo,
                  despesaCard.data,
                  despesaId: ''
              ));
    }
    organizar();
    notifyListeners();
  }

  Future<void> remover(DespesasDados despesaCard) async {
    _despesasCards.remove(despesaCard.despesaId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    _despesasCards.clear();
    final dados = await _dbFrete.lerDadosFretes();


  }

  Future<void> organizar() async {
    Map<String, DespesasDados> fretesOrdenados = {};
    List<String> chavesOrdenadas = _despesasCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _despesasCards[chave]!;
    }
    _despesasCards.clear();
    _despesasCards.addAll(fretesOrdenados);
    notifyListeners();
  }
}

class AbastecimentoProvider with ChangeNotifier {
  final Map<String, AbastecimentoDados> _abastecimentoCards = {};

  List<AbastecimentoDados> get all {
    return [..._abastecimentoCards.values];
  }

  int get count {
    return _abastecimentoCards.length;
  }

  AbastecimentoDados byIndex(int i) {
    return _abastecimentoCards.values.elementAt(i);
  }

  Future<void> put(AbastecimentoDados abastecimentoCard) async {
    if (abastecimentoCard.abastecimentoiD.trim().isNotEmpty &&
        _abastecimentoCards.containsKey(abastecimentoCard.abastecimentoiD)) {
      _abastecimentoCards.update(abastecimentoCard.abastecimentoiD, (_) => abastecimentoCard);
    } else {
      final id = abastecimentoCard.abastecimentoiD;
      _abastecimentoCards.putIfAbsent(
          id,
              () => AbastecimentoDados(
                  abastecimentoCard.valor,
                  abastecimentoCard.tipo,
                  abastecimentoCard.data,
                  abastecimentoCard.imageLink,
                  abastecimentoCard.nivelBomba,
                  abastecimentoiD: id));
    }

    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    _abastecimentoCards.clear();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbFrete.lerDadosFretes();

    organizar();
  }

  Future<void> organizar() async {
    Map<String, AbastecimentoDados> fretesOrdenados = {};

    List<String> chavesOrdenadas = _abastecimentoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      fretesOrdenados[chave] = _abastecimentoCards[chave]!;
    }
    _abastecimentoCards.clear();
    _abastecimentoCards.addAll(fretesOrdenados);
    notifyListeners();
  }

  Future<void> remover(DespesasDados despesaCard) async {
    _abastecimentoCards.remove(despesaCard.despesaId);
    notifyListeners();
  }
}
