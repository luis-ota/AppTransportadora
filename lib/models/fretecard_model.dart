class FreteCardDados {
  final String freteId;
  final String origem;
  final String compra;
  final String destino;
  final String venda;
  final String data;
  final String placaCaminhao;
  late final String status;

  FreteCardDados(
      {required this.freteId,
      required this.origem,
      required this.compra,
      required this.destino,
      required this.data,
      required this.venda,
      required this.placaCaminhao,
      required this.status});
}
