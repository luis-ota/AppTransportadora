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
  bool Concluido = false;

  @override
  void initState() {
    super.initState();
    // Load the image only once when the widget is created
    imageLoading = loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xD9D6D6B7),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                'https://encurtador.com.br/agCGN',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Switch(value: Concluido, onChanged: callMoveCard)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Destino: ${widget.texto}'),
                        const SizedBox(height: 8),
                        const Text('Valor: '),
                        const SizedBox(height: 8),
                        Text('Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
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
      Concluido = value;
    });

  }
}
