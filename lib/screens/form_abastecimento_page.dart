import 'dart:async';
import 'dart:io';

import 'package:apprubinho/models/custos_model.dart';
import 'package:apprubinho/providers/admin/custos_usuarios_provider.dart';
import 'package:apprubinho/providers/custos_provider.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';
import 'package:provider/provider.dart';
import '../components/anexo.dart';
import '../services/firebase_service.dart';
import 'foto_preview_page.dart';

class FormAbastecimentoPage extends StatefulWidget {
  final AbastecimentoDados? card;
  final String? action;
  final String? uid;

  const FormAbastecimentoPage({super.key, this.card, this.action, this.uid});

  @override
  State<StatefulWidget> createState() {
    return _FormAbastecimentoPageState();
  }
}

class _FormAbastecimentoPageState extends State<FormAbastecimentoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool _carregando = false;
  bool _anexoVisivel = false;
  final FirebaseService _dbAbastecimento = FirebaseService();

  late File _arquivo = File('');
  bool _temArquivoNovo = false;

  late TextEditingController _dataController;
  late TextEditingController _quantAbastController;
  late TextEditingController _volumeBombaController;

  late bool excluirImagemBanco = false;
  late bool editarFoto = false;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.card?.data ?? '');
    _quantAbastController =
        TextEditingController(text: widget.card?.quantidadeAbastecida ?? '');
    _volumeBombaController =
        TextEditingController(text: widget.card?.volumeBomba ?? '');
    if (widget.card?.imageLink != '' && widget.action == 'editar') {
      _anexoVisivel = true;
    }
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
      _formData['quantidadeAbastecida'] = widget.card!.quantidadeAbastecida;
      _formData['abastecimentoId'] = widget.card!.abastecimentoId;
      _formData['imageLink'] = widget.card!.imageLink;
    }

    if (widget.action != 'editar') {
      _formData['imageLink'] = '';
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
              AssetImage("lib/assets/img/local_gas_station.png"),
              size: 40,
            ),
          ]),
          title: const Text(
            'Informações do abastecimento',
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
                        'Preencha as informações do abastecimento',
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                      r'^\d*\.?\d*$'), // Expressão regular para permitir números, vírgulas e pontos
                                ),
                              ],
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira a quantidade abastecida';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _formData['quantidadeAbastecida'] = value!,
                            ),
                            const SizedBox(
                              height: 7,
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
                              height: 7,
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(
                                      r'^\d*\.?\d*$'), // Expressão regular para permitir números, vírgulas e pontos
                                ),
                              ],
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira o volume da bomba';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _formData['volumeBomba'] = value!,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  CameraCamera(onFile: (file) {
                                                    setState(() {
                                                      _arquivo = file;
                                                      _anexoVisivel = true;
                                                      _temArquivoNovo = true;
                                                    });
                                                    Navigator.of(context).pop();
                                                  }))),
                                      icon: Column(
                                        children: [
                                          const ImageIcon(
                                            AssetImage(
                                                "lib/assets/img/add_a_photo.png"),
                                            size: 45,
                                          ),
                                          Text((_temArquivoNovo ||
                                                  _formData['imageLink'] != '')
                                              ? 'Tirar foto novamente'
                                              : 'insira uma imagem'),
                                        ],
                                      ),
                                      iconSize: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Visibility(
                                      visible: _anexoVisivel,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              removerImagemTela();
                                            },
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Text("Remover")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Visibility(
                                  visible: _anexoVisivel,
                                  child: CupertinoButton(
                                    onPressed: () {
                                      (widget.action == 'editar' &&
                                              !excluirImagemBanco &&
                                              !_temArquivoNovo)
                                          ? showPreview(
                                              _formData['imageLink'], true)
                                          : showPreview(_arquivo.path, true);
                                    },
                                    child: Anexo(
                                        path: (widget.action == 'editar' &&
                                                !excluirImagemBanco &&
                                                !_temArquivoNovo)
                                            ? widget.card!.imageLink
                                            : _arquivo.path),
                                  ),
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
                                abastecimentoId:
                                    (_formData['abastecimentoId']).toString(),
                                att: true);
                          } else {
                            await criarAbastecimentoCard(
                                abastecimentoId: (DateTime.now())
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
                                            title: const Text(
                                                'Excluir Abastecimento'),
                                            content: const Text(
                                                'Excluir o registro de abastecimento?'),
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
                              onPressed: () {
                                try {
                                  _arquivo.exists().then((existe) {
                                    if (existe) {
                                      _arquivo.delete();
                                    }
                                  });
                                } finally {
                                  Navigator.of(context).pop();
                                }
                              },
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

  criarAbastecimentoCard({String abastecimentoId = '', bool att = false}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _carregando = true;
      });
      _formKey.currentState!.save();
      if (excluirImagemBanco) {
        await excluirImagemAbast();
      }
      if (_temArquivoNovo) {
        _formData['imageLink'] = await subirImagem(abastecimentoId);
      }

      _formData['volumeBomba'] =
          _formData['volumeBomba'].toString().replaceAll(',', '.');
      AbastecimentoDados abastecimentoDados = AbastecimentoDados(
        quantidadeAbastecida: _formData['quantidadeAbastecida']!,
        data: _formData['data']!,
        imageLink: _formData["imageLink"]!,
        volumeBomba: _formData['volumeBomba']!,
        abastecimentoId: abastecimentoId,
      );

      if (mounted) {
        (widget.uid == null)
            ? await Provider.of<AbastecimentoProvider>(context, listen: false)
                .put(abastecimentoDados)
            : await Provider.of<VerUsuarioAbastecimentoProvider>(context,
                    listen: false)
                .put(abastecimentoDados);
      }

      try {
        if (widget.action == 'editar') {
          await _dbAbastecimento.attDadosAbastecimento(
              abastecimentoDados, widget.card!.data,
              uid: (widget.uid == null)
                  ? FirebaseAuth.instance.currentUser?.uid
                  : widget.uid);
        } else {
          await _dbAbastecimento.cadastrarAbastecimento(
              abastecimento: abastecimentoDados,
              uid: (widget.uid == null)
                  ? FirebaseAuth.instance.currentUser?.uid
                  : widget.uid);
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
    if (_formData["imageLink"] != '') {
      await excluirImagemAbast();
    }
    if (mounted) {
      (widget.uid == null)
          ? await Provider.of<AbastecimentoProvider>(context, listen: false)
              .remover(widget.card!)
          : await Provider.of<VerUsuarioAbastecimentoProvider>(context,
                  listen: false)
              .remover(widget.card!);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
    await _dbAbastecimento.excluirAbastecimento(widget.card!, widget.card!.data,
        uid: (widget.uid == null)
            ? FirebaseAuth.instance.currentUser?.uid
            : widget.uid);
  }

  showPreview(path, vendo) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PreviewPage(
              path: path,
              vendo: vendo,
            )));
  }

  Future<String> subirImagem(String id) async {
    UploadTask task = await _dbAbastecimento.subirImagemAbastecimento(
        _arquivo, id, 'Abastecimento',
        uid: (widget.uid == null)
            ? FirebaseAuth.instance.currentUser?.uid
            : widget.uid);

    Completer<String> completer = Completer<String>();

    task.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.success) {
        String link = await snapshot.ref.getDownloadURL();
        completer.complete(link);
      }
    });

    String link = await completer.future;

    return link;
  }

  Future<void> excluirImagemAbast() async {
    await _dbAbastecimento.excluirImagem(
        widget.card?.abastecimentoId, 'Abastecimento',
        uid: (widget.uid == null)
            ? FirebaseAuth.instance.currentUser?.uid
            : widget.uid);
    _formData["imageLink"] = '';
  }

  void removerImagemTela() {
    setState(() {
      if (_arquivo.path.isNotEmpty) {
        _arquivo.delete();
        if (kDebugMode) {
          print('del');
        }
      }
      excluirImagemBanco = true;
      _formData['imageLink'] = '';
      _anexoVisivel = false;
      _temArquivoNovo = false;
    });
  }
}
