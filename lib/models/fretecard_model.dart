class FreteCardDados {
  final String freteId;
  final String origem;
  final String compra;
  final String destino;
  final String venda;
  final String data;
  final String placaCaminhao;
  final String status;

  FreteCardDados(
      this.origem,
      this.compra,
      this.destino,
      this.venda,
      this.data,
      this.placaCaminhao,
      this.status,
      {required this.freteId});
}
