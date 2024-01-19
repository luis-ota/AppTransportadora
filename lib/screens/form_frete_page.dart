import 'package:app_caminhao/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:intl/intl.dart';

class FormFretePage extends StatefulWidget {
  const FormFretePage({Key? key});

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

  firebaseService _dbFrete = firebaseService();

  @override
  Widget build(BuildContext context) {
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
        body: Padding(
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira o valor da compra';
                                }
                                return null;
                              },
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Insira o valor da venda';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime((DateTime.now().year).toInt() + 1),
                                locale: const Locale('pt', 'BR'),
                              );

                              if (pickedDate != null) {
                                String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                setState(() {
                                  _dataController.text = formattedDate;
                                });
                              }
                            },
                            icon: Icon(Icons.calendar_month),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
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
                    await criarFreteCard();
                  },
                  child: const Text('Cadastrar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(
                        double.maxFinite, 40), // set width and height
                  ),
                  onPressed: () => Navigator.pushNamed(context, "/home"),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  criarFreteCard() {
    String origem = _origemController.text;
    String compra = _compraController.text;
    String destino = _destinoController.text;
    String venda = _vendaController.text;
    String data = _dataController.text;
    String placa = _placaController.text;

    if (_formKey.currentState!.validate()) {
      _dbFrete.cadastrarFrete(
          origem: origem,
          compra: compra,
          destino: destino,
          venda: venda,
          data: data,
          placaCaminhao: placa);
    } else {
      print('inválido');
    }
  }
}
