import 'dart:io';

import 'package:apprubinho/models/despesas_model.dart';
import 'package:apprubinho/providers/despesas_provider.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';

import '../components/anexo.dart';
import 'foto_preview_page.dart';

class FormAbastecimentoPage extends StatefulWidget {
  final AbastecimentoDados? card;
  final String? action;

  const FormAbastecimentoPage({super.key, this.card, this.action});

  @override
  State<StatefulWidget> createState() {
    return _FormAbastecimentoPageState();
  }
}

class _FormAbastecimentoPageState extends State<FormAbastecimentoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _carregando = false;
  late File? arquivo = File('');

  late TextEditingController _dataController;
  late TextEditingController _quantAbastController;
  late TextEditingController _volumeBombaController;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.card?.data ?? '');
    _quantAbastController =
        TextEditingController(text: widget.card?.quantidadeAbastecida ?? '');
    _volumeBombaController =
        TextEditingController(text: widget.card?.volumeBomba ?? '');
  }

  @override
  void dispose() {
    _dataController.dispose();
    _quantAbastController.dispose();
    _volumeBombaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.action == 'editar') {
      _formData['data'] = widget.card!.data;
      _formData['volumeBomba'] = widget.card!.volumeBomba;
      _formData['quantAbast'] = widget.card!.quantidadeAbastecida;
      _formData['imageLink'] = widget.card!.imageLink;
    }

    if (widget.action != 'editar') {
      _formData['imageLink'] = arquivo!.path;
      _dataController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Row(children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.local_gas_station,
              size: 40,
            ),
          ]),
          title: const Text(
            'Informações do abastecimento',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: const Color(0xFF43A0E4),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Preencha com as informações do abastecimento',
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
                      TextFormField(
                        controller: _quantAbastController,
                        maxLength: 8,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade abastecida',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira a quantidade abastecida';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['quantAbast'] = value!,
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
                                labelText: 'Data do abastecimento',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira a data do abastecimento';
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
                                lastDate:
                                    DateTime((DateTime.now().year).toInt() + 1),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
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
                        controller: _volumeBombaController,
                        maxLength: 8,
                        maxLines: null,
                        // Para permitir várias linhas de texto
                        decoration: const InputDecoration(
                          labelText: 'Volume da bomba',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira o volume da bomba';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['volumeBomba'] = value!,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => CameraCamera(
                                        onFile: (file) => showPreview(file)))),
                            icon: Column(
                              children: [
                                const Icon(Icons.camera_alt_outlined),
                                Text((arquivo != null &&
                                        arquivo!.path.isNotEmpty)
                                    ? 'Tirar foto novamente'
                                    : 'insira uma imagem'),
                              ],
                            ),
                            iconSize: 40,
                          ),
                          Visibility(
                            visible:
                                arquivo != null && arquivo!.path.isNotEmpty,
                            child: Anexo(file: arquivo!),
                          ),
                        ],
                      )
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
                      criarAbastecimentoCard(
                          abastecimentoId: (_formData['despesaId']).toString(),
                          att: true);
                      print(_formData['despesaId']);
                    } else {
                      await criarAbastecimentoCard(
                          abastecimentoId: (DateTime.now())
                              .toString()
                              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''));
                    }
                  },
                  child: Text(
                      (widget.action == 'editar') ? 'Salvar' : 'Cadastrar'),
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
                          minimumSize: const Size(
                              double.maxFinite, 40), // set width and height
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

  criarAbastecimentoCard(
      {String abastecimentoId = '', bool att = false}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _carregando = true;
      });
      AbastecimentoDados abastecimentoDados = AbastecimentoDados(
        _formData['quantAbast']!,
        'Abastecimento',
        _formData['data']!,
        _formData['imageLink']!,
        _formData['volumeBomba']!,
        abastecimentoId: abastecimentoId,
      );

      await Provider.of<AbastecimentoProvider>(context, listen: false)
          .put(abastecimentoDados);
      try {} catch (err) {
        debugPrint(err.toString());
      }

      Navigator.of(context).pop();
    } else {
      print('inválido');
    }
  }

  excluiCard() async {
    setState(() {
      _carregando = true;
    });
    await Provider.of<AbastecimentoProvider>(context, listen: false)
        .remover(widget.card!);
    Navigator.of(context).pop();
  }

  showPreview(file) async {
    file = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PreviewPage(file: file)));

    if (file != null) {
      setState(() {
        arquivo = file;
        Navigator.of(context).pop();
      });
    }
  }
}
