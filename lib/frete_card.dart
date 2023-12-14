import 'package:flutter/material.dart';



class FreteCard extends StatefulWidget {
  const FreteCard({super.key});

  @override
  State<FreteCard> createState() {
    return FreteCardState();
  }
}

class FreteCardState extends State<FreteCard> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 380,
          height: 170,
          child: Center(child: Text('Frete')),
        ),
      ),
    );
  }
}
