import 'package:apprubinho/models/fretecard_model.dart';
import 'package:apprubinho/providers/admin/fretes_usuarios_provider.dart';
import 'package:apprubinho/providers/frete_card_provider.dart';
import 'package:apprubinho/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

class FormFretePage extends StatefulWidget {
  final FreteCardDados? card;
  final String? action;
  final String? uid;

  const FormFretePage({
    super.key,
    this.card,
    this.action,
    this.uid,
  });

  @override
  State<FormFretePage> createState() => _FormFretePageState();
}

class _FormFretePageState extends State<FormFretePage> {
  late TextEditingController _origemController;
  late TextEditingController _compraController;
  late TextEditingController _destinoController;
  late TextEditingController _vendaController;
  late TextEditingController _dataController;
  late TextEditingController _placaController;

  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final FirebaseService _dbFrete = FirebaseService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _origemController = TextEditingController(text: widget.card?.origem ?? '');
    _compraController = TextEditingController(text: widget.card?.compra ?? '');
    _destinoController =
        TextEditingController(text: widget.card?.destino ?? '');
    _vendaController = TextEditingController(text: widget.card?.venda ?? '');
    _dataController = TextEditingController(text: widget.card?.data ?? '');

    if (Provider.of<FreteCardAndamentoProvider>(context, listen: false)
        .andamentoCards
        .entries
        .isNotEmpty) {
      _placaController = TextEditingController(
          text: Provider.of<FreteCardAndamentoProvider>(context, listen: false)
              .andamentoCards
              .entries
              .first
              .value
              .placaCaminhao);
    } else {
      _placaController = TextEditingController(text: "");
    }
  }

  @override
  void dispose() {
    _origemController.dispose();
    _compraController.dispose();
    _destinoController.dispose();
    _vendaController.dispose();
    _dataController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.action == 'editar') {
      _formData['origem'] = widget.card!.origem;
      _formData['compra'] = widget.card!.compra;
      _formData['destino'] = widget.card!.destino;
      _formData['venda'] = widget.card!.venda;
      _formData['data'] = widget.card!.data;
      _formData['placaCaminhao'] = widget.card!.placaCaminhao;
      _formData['freteId'] = widget.card!.freteId;
    }

    if (widget.action != 'editar') {
      _dataController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      widget.card?.status == 'Em andamento';
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
                                      if (value.length < 10) {
                                        return 'Insira uma data válida';
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
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(
                              double.maxFinite, 40), // set width and height
                        ),
                        onPressed: () async {
                          if (widget.action == 'editar') {
                            criarFreteCard(
                                freteId: (_formData['freteId']).toString(),
                                att: true);
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
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: const Size(double.maxFinite, 40),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Excluir frete'),
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
                                child: const Text('Excluir'),
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
                                foregroundColor: Colors.white,
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

  criarFreteCard({String freteId = '', bool att = false}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData['compra'] = _formData['compra'].toString().replaceAll(',', '.');
      _formData['venda'] = _formData['venda'].toString().replaceAll(',', '.');
      setState(() {
        _carregando = true;
      });
      FreteCardDados freteCardDados = FreteCardDados(
        origem: _formData['origem']!,
        compra: _formData['compra']!,
        destino: _formData['destino']!,
        venda: _formData['venda']!,
        data: _formData['data']!,
        placaCaminhao: _formData['placaCaminhao']!,
        status: (null == widget.card?.status)
            ? 'Em andamento'
            : widget.card!.status,
        freteId: freteId,
      );

      if (widget.card?.status == 'Concluido') {
        await Provider.of<FreteCardConcluidoProvider>(context, listen: false)
            .put(freteCardDados);
        try {
          await _dbFrete.attDadosFretes(freteCardDados, widget.card!.data,
              uid: (widget.uid == null)
                  ? FirebaseAuth.instance.currentUser?.uid
                  : widget.uid);
        } catch (err) {
          debugPrint(err.toString());
        }
      } else {
        await Provider.of<FreteCardAndamentoProvider>(context, listen: false)
            .put(freteCardDados);
        try {
          (widget.action == 'editar')
              ? await _dbFrete.attDadosFretes(freteCardDados, widget.card!.data,
                  uid: (widget.uid == null)
                      ? FirebaseAuth.instance.currentUser!.uid
                      : widget.uid)
              : await _dbFrete.cadastrarFrete(
                  card: freteCardDados,
                  status: 'Em andamento',
                  uid: (widget.uid == null)
                      ? FirebaseAuth.instance.currentUser!.uid
                      : widget.uid);
        } catch (err) {
          debugPrint("erro ao cadastrar ou editar frete: $err");
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      if (kDebugMode) {
        print('inválido');
      }
    }
  }

  excluiCard() async {
    setState(() {
      _carregando = true;
    });
    if (widget.card?.status == 'Em andamento') {
      (widget.uid == null)
          ? await Provider.of<FreteCardAndamentoProvider>(context,
                  listen: false)
              .remover(widget.card!)
          : await Provider.of<VerUsuarioFreteCardAndamentoProvider>(context,
                  listen: false)
              .remover(widget.card!);
    } else {
      (widget.uid == null)
          ? await Provider.of<FreteCardConcluidoProvider>(context,
                  listen: false)
              .remover(widget.card!)
          : await Provider.of<VerUsuarioFreteCardConcluidoProvider>(context,
                  listen: false)
              .remover(widget.card!);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
    await _dbFrete.excluirFrete(
        card: widget.card!,
        status: widget.card!.status,
        data: widget.card!.data,
        uid: (widget.uid == null)
            ? FirebaseAuth.instance.currentUser?.uid
            : widget.uid);
  }
}
