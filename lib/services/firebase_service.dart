import 'dart:async';
import 'dart:io';

import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/models/pagamento_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _fretesRef = FirebaseDatabase.instance.ref('Fretes');
  final _custosref = FirebaseDatabase.instance.ref('Custos');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('Users');
  final DatabaseReference _porcentagemComissaoRef =
      FirebaseDatabase.instance.ref('PorcentagemComisao');
  final DatabaseReference _pagamentosRef =
      FirebaseDatabase.instance.ref('Pagamentos');

  Future<String?> acessar(
      {required String usuario, required String senha}) async {
    try {
      usuario = "$usuario@apprubinho.com";
      await _firebaseAuth.signInWithEmailAndPassword(
          email: usuario, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sair() async {
    return await _firebaseAuth.signOut();
  }

  Future cadastrarFrete({
    required FreteCardDados card,
    required String status,
    required String? uid,
  }) async {
    try {
      if (status == 'Em andamento') {
        await _fretesRef.child('$uid/$status/${card.freteId}').set({
          'origem': card.origem,
          'compra': card.compra,
          'destino': card.destino,
          'venda': card.venda,
          'data': card.data,
          'placaCaminhao': card.placaCaminhao,
        });
      } else {
        List<String> partes = card.data.split('/');
        String anoMes = '${partes[2]}/${partes[1]}';
        await _fretesRef.child('$uid/$status/$anoMes/${card.freteId}').set({
          'origem': card.origem,
          'compra': card.compra,
          'destino': card.destino,
          'venda': card.venda,
          'data': card.data,
          'placaCaminhao': card.placaCaminhao,
        });
      }
    } catch (error) {
      // Trate os erros aqui
      if (kDebugMode) {
        print('Erro ao cadastrar frete: $error');
      }
      rethrow;
    }
  }

  Future<void> attDadosFretes(FreteCardDados card, String data,
      {required String? uid}) async {
    if (card.data != data) {
      await excluirFrete(card: card, status: card.status, data: data, uid: uid);
    }
    if (card.status == "Em andamento") {
      return await _fretesRef
          .child('$uid/${card.status}/${card.freteId}')
          .update({
        'origem': card.origem,
        'compra': card.compra,
        'destino': card.destino,
        'venda': card.venda,
        'data': card.data,
        'placaCaminhao': card.placaCaminhao,
      });
    } else {
      List<String> partes = card.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      return await _fretesRef
          .child('$uid/${card.status}/$anoMes/${card.freteId}')
          .update({
        'origem': card.origem,
        'compra': card.compra,
        'destino': card.destino,
        'venda': card.venda,
        'data': card.data,
        'placaCaminhao': card.placaCaminhao,
      });
    }
  }

  Future<String?> excluirFrete(
      {required FreteCardDados card,
      required String status,
      required String data,
      required String? uid}) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';
    if (status == 'Em andamento') {
      _fretesRef.child('$uid/${card.status}/${card.freteId}').remove();
    } else {
      _fretesRef.child('$uid/${card.status}/$anoMes/${card.freteId}').remove();
    }
    return null;
  }

  Future<String?> moverFrete({
    required String status,
    required FreteCardDados card,
    required String paraOnde,
    required String? uid,
  }) async {
    excluirFrete(status: status, card: card, data: card.data, uid: uid);
    cadastrarFrete(card: card, status: paraOnde, uid: uid);
    return null;
  }

  Future<void> cadastrarDespesa({
    required DespesasDados despesa,
    required String? uid,
  }) async {
    try {
      List<String> partes = despesa.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      await _custosref.child('$uid/Despesas/$anoMes/${despesa.despesaId}').set({
        'despesa': despesa.despesa,
        'valor': despesa.valor,
        'data': despesa.data,
        'descricao': despesa.descricao,
      });
    } catch (error) {
      // Trate os erros aqui
      if (kDebugMode) {
        print('Erro ao cadastrar despesa: $error');
      }
      rethrow;
    }
  }

  Future<void> attDadosDespesa(DespesasDados despesa, String data,
      {required String? uid}) async {
    var partes = despesa.data.split('/');
    var anoMes = '${partes[2]}/${partes[1]}';
    if ('${partes[1]}/${partes[2]}' != data.substring(3)) {
      await excluirDespesa(despesa, data, uid: uid);
    }
    await _custosref
        .child('$uid/Despesas/$anoMes/${despesa.despesaId}')
        .update({
      'despesa': despesa.despesa,
      'valor': despesa.valor,
      'data': despesa.data,
      'descricao': despesa.descricao,
    });
  }

  Future<String?> excluirDespesa(DespesasDados despesa, String data,
      {required String? uid}) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';

    await _custosref
        .child('$uid/Despesas/$anoMes/${despesa.despesaId}')
        .remove();

    return null;
  }

  Future<void> cadastrarAbastecimento({
    required AbastecimentoDados abastecimento,
    required String? uid}) async {
    try {
      List<String> partes = abastecimento.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      await _custosref
          .child('$uid/Abastecimento/$anoMes/${abastecimento.abastecimentoId}')
          .set({
        'quantidadeAbastecida': abastecimento.quantidadeAbastecida,
        'data': abastecimento.data,
        'imageLink': abastecimento.imageLink,
        'volumeBomba': abastecimento.volumeBomba,
      });
    } catch (error) {
      // Trate os erros aqui
      if (kDebugMode) {
        print('Erro ao cadastrar despesa: $error');
      }
      rethrow;
    }
  }

  Future<void> attDadosAbastecimento(
      AbastecimentoDados abastecimento, String data,
      {required String? uid}) async {
    var partes = abastecimento.data.split('/');
    var anoMes = '${partes[2]}/${partes[1]}';
    if ('${partes[1]}/${partes[2]}' != data.substring(3)) {
      await excluirAbastecimento(abastecimento, data, uid: uid);
    }
    await _custosref
        .child('$uid/Abastecimento/$anoMes/${abastecimento.abastecimentoId}')
        .update({
      'quantidadeAbastecida': abastecimento.quantidadeAbastecida,
      'data': abastecimento.data,
      'imageLink': abastecimento.imageLink,
      'volumeBomba': abastecimento.volumeBomba,
    });
  }

  Future<String?> excluirAbastecimento(
      AbastecimentoDados abastecimento, String data,
      {required String? uid}) async {
    List<String> partes = data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';

    await _custosref
        .child('$uid/Abastecimento/$anoMes/${abastecimento.abastecimentoId}')
        .remove();

    return null;
  }

  Future<UploadTask> subirImagemAbastecimento(
      String filePath, String id, String refRepo,
      {required String? uid}) async {
    try {
      String ref = 'images/$refRepo/$uid/img-$id.jpg';
      return _storage.ref(ref).putFile(File(filePath));
    } catch (e) {
      throw Exception('Erro ao subir imagem:  $e');
    }
  }

  Future<void> excluirImagem(String? id, String? refRepo,
      {required String? uid}) async {
    await _storage.ref('images/$refRepo/$uid/img-$id.jpg').delete();
  }

  Future<String> pegarLinkImagens(String id, String ref,
      {required String? uid}) async {
    var refs = (await _storage.ref('images/$ref/$uid').listAll()).items;
    String link = '';
    for (var ref in refs) {
      await ref.getDownloadURL().then((value) {
        if (id == value.split('img-')[1].split('.')[0]) {
          link = value;
        }
      });
    }
    return link;
  }

  Future<Map?> lerDadosBanco(String ref, {required String? uid}) async {
    if (ref == 'Fretes') {
      DatabaseEvent snapshot = await _fretesRef.child(uid!).once();
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
      return data;
    }
    if (ref == 'Custos') {
      DatabaseEvent snapshot = await _custosref.child(uid!).once();
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
      return data;
    }

    if (ref == 'Users') {
      DatabaseEvent snapshot = await _usersRef.once();
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
      return data;
    }

    if (ref == 'Pagamentos') {
      DatabaseEvent snapshot = await _pagamentosRef.child(uid!).once();
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
      return data;
    }

    if (ref == 'PorcentagemPagamentos') {
      DatabaseEvent snapshot = await _porcentagemComissaoRef.once();
      Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map?;
      return data;
    }

    return null;
  }

  Future<void> cadastrarPagamento(
      {required PagamentoDados pagamento, required String? uid}) async {
    try {
      List<String> partes = pagamento.data.split('/');
      String anoMes = '${partes[2]}/${partes[1]}';
      await _pagamentosRef.child('$uid/$anoMes/${pagamento.uid}').set({
        'data': pagamento.data,
        'ultimoFrete': pagamento.ultimoFrete,
        'valorTotal': pagamento.valorTotal,
        'valorComissao': pagamento.valorComissao,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao cadastrar pagamento: $error');
      }
      rethrow;
    }
  }

  Future<void> atualizarPorcentagemComissao(
      {required String porcentagemComissao}) async {
    try {
      await _porcentagemComissaoRef.update({
        'porcentagem': porcentagemComissao,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao cadastrar pagamento: $error');
      }
      rethrow;
    }
  }

  Future<String?> excluirPagamento(PagamentoDados pagamento,
      {required String? uid}) async {
    List<String> partes = pagamento.data.split('/');
    String anoMes = '${partes[2]}/${partes[1]}';

    await _pagamentosRef.child('$uid/$anoMes/${pagamento.uid}').remove();

    return null;
  }
}
