class DespesasDados {
  final String despesaId;
  final String despesa;
  final String descricao;
  final String valor;
  final String data;
  final String placaCaminhao;

  DespesasDados(
      {required this.despesa,
      required this.descricao,
      required this.placaCaminhao,
      required this.valor,
      required this.despesaId,
      required this.data});
}

class AbastecimentoDados {
  final String abastecimentoId;
  final String quantidadeAbastecida;
  final String data;
  final String imageLink;
  final String volumeBomba;
  final String placaCaminhao;

  AbastecimentoDados(
      {required this.placaCaminhao,
      required this.quantidadeAbastecida,
      required this.data,
      this.imageLink = 'vazio',
      required this.volumeBomba,
      required this.abastecimentoId});
}
