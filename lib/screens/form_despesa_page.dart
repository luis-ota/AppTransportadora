import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';

class FormDespesaPage extends StatefulWidget {
  final DespesasDados? card;
  final String? action;

  const FormDespesaPage({super.key, this.card, this.action});

  @override
  State<StatefulWidget> createState() {
    return _FormDespesaPageState();
  }
}

class _FormDespesaPageState extends State<FormDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final FirebaseService _dbDespesa = FirebaseService();

  bool _carregando = false;

  late TextEditingController _dataController;
  late TextEditingController _valorController;
  late TextEditingController _despesaController;
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.card?.data ?? '');
    _valorController = TextEditingController(text: widget.card?.valor ?? '');
    _despesaController =
        TextEditingController(text: widget.card?.despesa ?? '');
    _descricaoController =
        TextEditingController(text: widget.card?.descricao ?? '');
  }

  @override
  void dispose() {
    _dataController.dispose();
    _valorController.dispose();
    _despesaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.action == 'editar') {
      _formData['data'] = widget.card!.data;
      _formData['valor'] = widget.card!.valor;
      _formData['despesa'] = widget.card!.despesa;
      _formData['descricao'] = widget.card!.descricao;
      _formData['despesaId'] = widget.card!.despesaId;
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
              AssetImage("lib/assets/img/despesas_icon.png"),
              size: 40,
            )
          ]),
          title: const Text(
            'Informações da Despesa',
            style: TextStyle(fontSize: 20),
          ),
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
                        'Preencha com as informações da despesa',
                        style: TextStyle(fontSize: 16),
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
                              controller: _despesaController,
                              maxLength: 8,
                              decoration: const InputDecoration(
                                      labelText: 'Despesa',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.name,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Insira a despesa';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['despesa'] = value!,
                                  ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: _valorController,
                              maxLength: 7,
                              decoration: const InputDecoration(
                                labelText: 'R\$ Valor',
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
                                        return 'Insira o valor da despesa';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _formData['valor'] = value!,
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
                              controller: _dataController,
                              mask: '##/##/####',
                              maxLength: 10,
                              decoration: const InputDecoration(
                                labelText: 'Data da despesa',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira a data da despesa';
                                }
                                if (value.length < 10) {
                                  return 'Insira uma data válida';
                                }
                                return null;
                              },
                              onSaved: (value) => _formData['data'] = value!,
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
                      TextFormField(
                        controller: _descricaoController,
                        maxLength: 100,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira a descrição da despesa';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['descricao'] = value!,
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
                            criarDespesaCard(
                                despesaId: (_formData['despesaId']).toString(),
                                att: true);
                          } else {
                            await criarDespesaCard(
                                despesaId: (DateTime.now())
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
                                  title:
                                                const Text('Excluir despesa'),
                                            content: const Text(
                                                'Deseja excluir o registro de despesa?'),
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

  criarDespesaCard({String despesaId = '', bool att = false}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData['valor'] = _formData['valor'].toString().replaceAll(',', '.');
      setState(() {
        _carregando = true;
      });
      DespesasDados despesasDados = DespesasDados(
        despesa: _formData['despesa']!,
        descricao: _formData['descricao']!,
        valor: _formData['valor']!,
        data: _formData['data']!,
        despesaId: despesaId,
      );

      await Provider.of<DespesasProvider>(context, listen: false)
          .put(despesasDados);
      try {
        if (widget.action == 'editar') {
          await _dbDespesa.attDadosDespesa(despesasDados, widget.card!.data);
        } else {
          await _dbDespesa.cadastrarDespesa(despesa: despesasDados);
        }
      } catch (err) {
        debugPrint(err.toString());
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
    await Provider.of<DespesasProvider>(context, listen: false)
        .remover(widget.card!);
    if (mounted) {
      Navigator.of(context).pop();
    }
    await _dbDespesa.excluirDespesa(widget.card!, widget.card!.data);
  }
}
