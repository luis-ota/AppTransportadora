import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';

final FirebaseService _dbDespesas = FirebaseService();

class VerUsuarioDespesaProvider with ChangeNotifier {
  final Map<String, DespesasDados> _usuarioDespesasCards = {};

  List<DespesasDados> get all {
    return [..._usuarioDespesasCards.values];
  }

  int get count {
    return _usuarioDespesasCards.length;
  }

  DespesasDados byIndex(int i) {
    return _usuarioDespesasCards.values.elementAt(i);
  }

  Future<void> put(DespesasDados despesaCard) async {
    if (despesaCard.despesaId.trim().isNotEmpty &&
        _usuarioDespesasCards.containsKey(despesaCard.despesaId)) {
      _usuarioDespesasCards.update(despesaCard.despesaId, (_) => despesaCard);
    } else {
      final id = despesaCard.despesaId;
      _usuarioDespesasCards.putIfAbsent(
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
    _usuarioDespesasCards.remove(despesaCard.despesaId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco(String? uid) async {
    _usuarioDespesasCards.clear();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final anoAtual = DateTime.now().year.toString();
    final dados = await _dbDespesas.lerDadosBanco('Custos', uid: uid!);
    if (dados?['Despesas'] != null) {
      dados?['Despesas'][anoAtual][mesAtual].forEach((key, value) {
        put(DespesasDados(
            despesaId: key,
            despesa: value['despesa'],
            valor: value['valor'],
            descricao: value['descricao'],
            data: value['data']));
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, DespesasDados> despesasOrdenados = {};
    List<String> chavesOrdenadas = _usuarioDespesasCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      despesasOrdenados[chave] = _usuarioDespesasCards[chave]!;
    }
    _usuarioDespesasCards.clear();
    _usuarioDespesasCards.addAll(despesasOrdenados);
    notifyListeners();
  }
}

class VerUsuarioAbastecimentoProvider with ChangeNotifier {
  final Map<String, AbastecimentoDados> _usuarioAbastecimentoCards = {};

  List<AbastecimentoDados> get all {
    return [..._usuarioAbastecimentoCards.values];
  }

  int get count {
    return _usuarioAbastecimentoCards.length;
  }

  AbastecimentoDados byIndex(int i) {
    return _usuarioAbastecimentoCards.values.elementAt(i);
  }

  Future<void> put(AbastecimentoDados abastecimentoCard) async {
    if (abastecimentoCard.abastecimentoId.trim().isNotEmpty &&
        _usuarioAbastecimentoCards
            .containsKey(abastecimentoCard.abastecimentoId)) {
      _usuarioAbastecimentoCards.update(
          abastecimentoCard.abastecimentoId, (_) => abastecimentoCard);
    } else {
      final id = abastecimentoCard.abastecimentoId;
      _usuarioAbastecimentoCards.putIfAbsent(
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
    _usuarioAbastecimentoCards.remove(abastecimentoDados.abastecimentoId);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco(String? uid) async {
    _usuarioAbastecimentoCards.clear();
    final mesAtual = DateTime.now().month.toString().padLeft(2, '0');
    final anoAtual = DateTime.now().year.toString();
    final dados = await _dbDespesas.lerDadosBanco('Custos', uid: uid!);
    if (dados?['Abastecimento'] != null) {
      dados?['Abastecimento'][anoAtual][mesAtual].forEach((key, value) {
        put(AbastecimentoDados(
            quantidadeAbastecida: value['quantidadeAbastecida'],
            data: value['data'],
            imageLink: value['imageLink'],
            volumeBomba: value['volumeBomba'],
            abastecimentoId: key));
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, AbastecimentoDados> abastecimentoOrdenados = {};

    List<String> chavesOrdenadas = _usuarioAbastecimentoCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      abastecimentoOrdenados[chave] = _usuarioAbastecimentoCards[chave]!;
    }
    _usuarioAbastecimentoCards.clear();
    _usuarioAbastecimentoCards.addAll(abastecimentoOrdenados);
    notifyListeners();
  }
}
