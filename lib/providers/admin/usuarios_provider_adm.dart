import 'package:apprubinho/models/usuario_model.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:flutter/material.dart';

final FirebaseService _dbUsuarios = FirebaseService();

class UsuariosProvider with ChangeNotifier {
  final Map<String, UsuariosDados> _usuariosCards = {};

  List<UsuariosDados> get all {
    return [..._usuariosCards.values];
  }

  int get count {
    return _usuariosCards.length;
  }

  UsuariosDados byIndex(int i) {
    return _usuariosCards.values.elementAt(i);
  }

  Future<void> put(UsuariosDados usuariosDados) async {
    if (usuariosDados.uid.trim().isNotEmpty &&
        _usuariosCards.containsKey(usuariosDados.uid)) {
      _usuariosCards.update(usuariosDados.uid, (_) => usuariosDados);
    } else {
      final id = usuariosDados.uid;
      _usuariosCards.putIfAbsent(
          id,
          () => UsuariosDados(
              nome: usuariosDados.nome, uid: id, caminhaoPadrao: 'placa'));
    }
    notifyListeners();
  }

  Future<void> remover(UsuariosDados usuariosDados) async {
    _usuariosCards.remove(usuariosDados.uid);
    notifyListeners();
  }

  Future<void> carregarDadosDoBanco() async {
    _usuariosCards.clear();
    final dados = await _dbUsuarios.lerDadosBanco('Users', uid: '');

    if (dados != null) {
      dados.forEach((key, value) {
        put(UsuariosDados(nome: key, caminhaoPadrao: '', uid: value['uid']));
      });
    }
    organizar();
  }

  Future<void> organizar() async {
    Map<String, UsuariosDados> usuariosOrdenados = {};

    List<String> chavesOrdenadas = _usuariosCards.keys.toList();
    chavesOrdenadas.sort((a, b) => b.compareTo(a));
    for (var chave in chavesOrdenadas) {
      usuariosOrdenados[chave] = _usuariosCards[chave]!;
    }
    _usuariosCards.clear();
    _usuariosCards.addAll(usuariosOrdenados);
    notifyListeners();
  }
}
