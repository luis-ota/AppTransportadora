import 'package:flutter/material.dart';
import '../home_page/nested_tab_bar.dart';
import 'package:intl/intl.dart';

class FreteCard extends StatefulWidget {
  const FreteCard({Key? key, required this.texto}) : super(key: key);
  final String texto;

  @override
  State<FreteCard> createState() {
    return FreteCardState();
  }
}

class FreteCardState extends State<FreteCard> {
  late Future<void> imageLoading;
  bool concluido = false; // Renomeie de 'Concluido' para 'concluido'
  late bool switchValue; // Adicione um estado local para o Switch

  @override
  void initState() {
    super.initState();
    // Load the image only once when the widget is created
    imageLoading = loadImage();
    switchValue = concluido; // Inicialize o estado do Switch com o valor de 'concluido'
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.lightBlueAccent,
        child: SizedBox(
          width: 380,
          height: 170,
          child: Row(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: FutureBuilder(
                      future: imageLoading,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator (e.g., CircularProgressIndicator)
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const ImageIcon(
                                AssetImage("lib/assets/img/caminhao.png"),
                                size: 70,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // Handle error
                          return const ImageIcon(
                            AssetImage("lib/assets/img/caminhao.png"),
                            size: 70,
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const ImageIcon(
                                AssetImage("lib/assets/img/caminhao.png"),
                                size: 70,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Switch(
                    value: switchValue, // Use switchValue em vez de 'concluido'
                    onChanged: callMoveCard,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 7.0,
                      left: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Destino: ${widget.texto}', style: const TextStyle(fontSize: 20),),
                        const SizedBox(height: 8),
                        const Text('Valor: ', style: TextStyle(fontSize: 17),),
                        const SizedBox(height: 8),
                        Text('Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}', style: const TextStyle(fontSize: 17),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadImage() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void callMoveCard(bool value) {
    setState(() {
      switchValue = value; // Atualize o estado local do Switch
      concluido = switchValue; // Atualize 'concluido' conforme necessário

      if (concluido) {
        // Mova o card para a tab "Concluído"
        final NestedTabBarState? tabBarState =
        context.findAncestorStateOfType<NestedTabBarState>();
        if (tabBarState != null) {
          tabBarState.addConcluidoCard(widget);
          tabBarState.andamentoCards.remove(widget);
        }
      } else {
        // Mova o card para a tab "Em andamento"
        final NestedTabBarState? tabBarState =
        context.findAncestorStateOfType<NestedTabBarState>();
        if (tabBarState != null) {
          tabBarState.addAndamentoCard(widget);
          tabBarState.concluidoCards.remove(widget);
        }
      }
    });
  }
}
