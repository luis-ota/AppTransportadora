import 'package:apprubinho/models/custos_model.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

final FirebaseService _dbDespesas = FirebaseService();

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
              despesa: despesaCard.despesa,
              descricao: despesaCard.descricao,
              valor: despesaCard.valor,
              data: despesaCard.data,
              despesaId: id));
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
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbDespesas.lerDadosDespesas();
    if (dados?['Despesas'] != null) {
      dados?['Despesas'].forEach((ano, value) {
        dados['Despesas']['$ano'].forEach((mes, value) {
          dados['Despesas']['$ano']['$mes'].forEach((key, value) {
            if (mes == mesAtual && ano == DateTime.now().year.toString()) {
              put(DespesasDados(
                  despesaId: key,
                  despesa: value['despesa'],
                  valor: value['valor'],
                  descricao: value['descricao'],
                  data: value['data']));
            }
          });
        });
      });
    }
    organizar();
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
    if (abastecimentoCard.abastecimentoId.trim().isNotEmpty &&
        _abastecimentoCards.containsKey(abastecimentoCard.abastecimentoId)) {
      print("atualizou");
      _abastecimentoCards.update(
          abastecimentoCard.abastecimentoId, (_) => abastecimentoCard);
    } else {
      final id = abastecimentoCard.abastecimentoId;
      _abastecimentoCards.putIfAbsent(
          id,
          () => AbastecimentoDados(
              quantidadeAbastecida: abastecimentoCard.quantidadeAbastecida,
              data: abastecimentoCard.data,
              imageLink: abastecimentoCard.imageLink,
              volumeBomba: abastecimentoCard.volumeBomba,
              abastecimentoId: id));
    }
    organizar();
    notifyListeners();
  }

  Future<void> remover(AbastecimentoDados abastecimentoDados) async {
    _abastecimentoCards.remove(abastecimentoDados.abastecimentoId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    _abastecimentoCards.clear();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final dados = await _dbDespesas.lerDadosDespesas();

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
}
