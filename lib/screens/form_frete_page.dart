import 'package:app_caminhao/models/fretecard_model.dart';
import 'package:app_caminhao/providers/frete_card_provider.dart';
import 'package:app_caminhao/screens/homepage.dart';
import 'package:app_caminhao/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormFretePage extends StatefulWidget {
  final FreteCardDados? cardDados;
  final String? action;

  const FormFretePage({
    Key? key,
    this.cardDados,
    this.action,
  }) : super(key: key);

  @override
  State<FormFretePage> createState() => _FormFretePageState();
}

class _FormFretePageState extends State<FormFretePage> {
  final TextEditingController _origemController = TextEditingController();
  final TextEditingController _compraController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _vendaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    if (widget.action == 'editar') {
      _origemController.text = widget.cardDados!.origem;
      _compraController.text = widget.cardDados!.compra;
      _destinoController.text = widget.cardDados!.destino;
      _vendaController.text = widget.cardDados!.venda;
      _dataController.text = widget.cardDados!.data;
      _placaController.text = widget.cardDados!.placaCaminhao;
      _formData['freteId'] = widget.cardDados!.freteId;
    }

    if (widget.action != 'editar') {
      _dataController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Row(children: [
            SizedBox(
              width: 15,
            ),
            ImageIcon(
              AssetImage("lib/assets/img/caminhao.png"),
              size: 40,
            ),
          ]),
          title: const Text('Informações do frete'),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: _carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Preencha com as informações do frete',
                        style: TextStyle(fontSize: 19),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 20,
                                    controller: _destinoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Destino',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira o destino do carga';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['destino'] = value!,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 117,
                                  child: TextFormField(
                                    maxLength: 7,
                                    controller: _vendaController,
                                    decoration: const InputDecoration(
                                      labelText: 'R\$ Venda',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                            r'^\d*\.?\d*$'), // Expressão regular para permitir números, vírgulas e pontos
                                      ),
                                    ],
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira o valor da venda';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['venda'] = value!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 25,
                                    controller: _origemController,
                                    decoration: const InputDecoration(
                                      labelText: 'Origem',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira a origem do carga';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['origem'] = value!,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 117,
                                  child: TextFormField(
                                    maxLength: 7,
                                    controller: _compraController,
                                    decoration: const InputDecoration(
                                      labelText: 'R\$ Compra',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                            r'^\d*\.?\d*$'), // Expressão regular para permitir números, vírgulas e pontos
                                      ),
                                    ],
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira o valor da compra';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['compra'] = value!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: MaskedTextField(
                                    mask: '##/##/####',
                                    maxLength: 10,
                                    controller: _dataController,
                                    decoration: const InputDecoration(
                                      labelText: 'Data do frete',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira a data do frete';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['data'] = value!,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(
                                          (DateTime.now().year).toInt() + 1),
                                      locale: const Locale('pt', 'BR'),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                      setState(() {
                                        _dataController.text = formattedDate;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_month),
                                  iconSize: 40,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            TextFormField(
                              maxLength: 8,
                              controller: _placaController,
                              decoration: const InputDecoration(
                                labelText: 'Placa do Caminhão',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira a placa do caminhão';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _formData['placaCaminhao'] = value!,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(
                              double.maxFinite, 40), // set width and height
                        ),
                        onPressed: () async {
                          if (widget.action == 'editar') {

                            criarFreteCard(
                                freteId: (_formData['freteId']).toString());
                          } else {
                            await criarFreteCard(
                                freteId: (DateTime.now())
                                    .toString()
                                    .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''));
                          }
                        },
                        child: Text((widget.action == 'editar')
                            ? 'Salvar'
                            : 'Cadastrar'),
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: widget.action == 'editar',
                            child: Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: const Size(double.maxFinite,
                                      40), // set width and height
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Exclir frete'),
                                            content: const Text(
                                                'Deseja excluir o registro de frete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  excluiCard();
                                                },
                                                child: const Text('Sim'),
                                              )
                                            ],
                                          ));
                                },
                                child: const Text('Exculir'),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: widget.action == 'editar',
                              child: const SizedBox(
                                width: 10,
                              )),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.maxFinite,
                                    40), // set width and height
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  criarFreteCard({String freteId = '', String status = 'Em andamento'}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData['compra'] = _formData['compra'].toString().replaceAll(',', '.');
      _formData['venda'] = _formData['venda'].toString().replaceAll(',', '.');
      setState(() {
        _carregando = true;
      });
      await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
          .put(FreteCardDados(
        _formData['origem']!,
        _formData['compra']!,
        _formData['destino']!,
        _formData['venda']!,
        _formData['data']!,
        _formData['placaCaminhao']!,
        status,
        freteId: freteId,
      ));
      Navigator.of(context).pop();

      /*

       */
    } else {
      print('inválido');
    }
  }

  excluiCard() async {
    setState(() {
      _carregando = true;
    });
    await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
        .remover(widget.cardDados!);
    Navigator.of(context).pop();
  }
}
