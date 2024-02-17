class DespesasDados {
  final String despesaId;
  final String despesa;
  final String descricao;
  final String valor;
  final String data;

  DespesasDados(
      {required this.despesa,
      required this.descricao,
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

  AbastecimentoDados(
      {required this.quantidadeAbastecida,
      required this.data,
      required this.imageLink,
      required this.volumeBomba,
      required this.abastecimentoId});
}
