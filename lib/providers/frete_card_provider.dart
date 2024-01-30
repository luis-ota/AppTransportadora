import 'package:flutter/material.dart';
import '../models/fretecard_model.dart';

import '../services/firebase_service.dart';

final firebaseService _dbFrete = firebaseService();

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
      await _dbFrete.attDadosFretes(
        freteId: freteCard.freteId,
        origem: freteCard.origem,
        compra: freteCard.compra,
        destino: freteCard.destino,
        venda: freteCard.venda,
        data: freteCard.data,
        placaCaminhao: freteCard.placaCaminhao,
        status: 'Em andamento',
      );

      _andamentoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      try {
        await _dbFrete.cadastrarFrete(
          freteId: freteCard.freteId,
          origem: freteCard.origem,
          compra: freteCard.compra,
          destino: freteCard.destino,
          venda: freteCard.venda,
          data: freteCard.data,
          placaCaminhao: freteCard.placaCaminhao,
          status: 'Em andamento',
        );
      } catch (err) {
        debugPrint(err.toString());
      }
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
    carregarDadosDoBanco();
    notifyListeners();
  }

  Future<void> remover(FreteCardDados freteCard) async {
    await _dbFrete.excluirFrete(
        freteId: freteCard.freteId, status: freteCard.status);
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
      await _dbFrete.attDadosFretes(
        freteId: freteCard.freteId,
        origem: freteCard.origem,
        compra: freteCard.compra,
        destino: freteCard.destino,
        venda: freteCard.venda,
        data: freteCard.data,
        placaCaminhao: freteCard.placaCaminhao,
        status: 'Concluido',
      );

      _concluidoCards.update(freteCard.freteId, (_) => freteCard);
    } else {
      try {
        await _dbFrete.cadastrarFrete(
            freteId: freteCard.freteId,
            origem: freteCard.origem,
            compra: freteCard.compra,
            destino: freteCard.destino,
            venda: freteCard.venda,
            data: freteCard.data,
            placaCaminhao: freteCard.placaCaminhao,
            status: 'Concluido');
      } catch (err) {
        debugPrint(err.toString());
      }
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

  Future<void> remover(FreteCardDados freteCard) async {
    await _dbFrete.excluirFrete(
        freteId: freteCard.freteId, status: freteCard.status);
    _concluidoCards.remove(freteCard.freteId);
    notifyListeners();
  }
}
