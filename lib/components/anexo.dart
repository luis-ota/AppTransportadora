import 'dart:io';
import 'package:apprubinho/models/despesas_model.dart';
import 'package:flutter/material.dart';

class Anexo extends StatelessWidget {
  final File file;

  Anexo({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
