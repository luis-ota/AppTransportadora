import 'package:apprubinho/models/despesas_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';

class FormAbastecimentoPage extends StatefulWidget {
  final AbastecimentoDados? despesa;
  final String? action;

  const FormAbastecimentoPage({super.key, this.despesa, this.action});

  @override
  State<StatefulWidget> createState() {
    return _FormAbastecimentoPageState();
  }
}

class _FormAbastecimentoPageState extends State<FormAbastecimentoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  late final bool tipoDespesa;
  bool _carregando = false;


  late TextEditingController _dataController;
  late TextEditingController _valorController;
  late TextEditingController _despesaController;
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
// Use widget.tipo para acessar o tipo passado no construtor
    _dataController = TextEditingController(text: widget.despesa?.data ?? '');
    _valorController = TextEditingController(text: widget.despesa?.valor ?? '');

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

    }

    if (widget.action != 'editar') {
      _dataController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Row(children: [
            const SizedBox(
              width: 15,
            ),
            (tipoDespesa)
                ? const ImageIcon(
                    AssetImage("lib/assets/img/despesas_icon.png"),
                    size: 40,
                  )
                : const Icon(
                    Icons.local_gas_station,
                    size: 40,
                  ),
          ]),
          title: Text(
            'Informações do abastecimento',
            style: const TextStyle(fontSize: 20),
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
                Text(
                  'Preencha com as informações do abastecimento',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: tipoDespesa,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
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
                                    _formData['valorDespesa'] = value!,
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
                        SizedBox(
                          height: 150, // Defina a altura desejada aqui
                          child: TextFormField(
                            maxLength: 100,
                            maxLines:
                                null, // Para permitir várias linhas de texto
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
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !tipoDespesa,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                          maxLength: 8,
                          maxLines:
                              null, // Para permitir várias linhas de texto
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
                      ],
                    ),
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
                  onPressed: () {},
                  child: const Text((false) ? 'Salvar' : 'Cadastrar'),
                ),
                Row(
                  children: [
                    Visibility(
                      visible: false,
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
                    const Visibility(
                        visible: false,
                        child: SizedBox(
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
}
