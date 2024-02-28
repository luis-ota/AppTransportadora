class PagamentoDados {
  final String uid;
  final String data;
  final String ultimoFrete;
  final String valorTotal;
  final String valorComissao;

  PagamentoDados(
      {required this.data,
      required this.ultimoFrete,
      required this.valorTotal,
      required this.valorComissao,
      required this.uid});
}
