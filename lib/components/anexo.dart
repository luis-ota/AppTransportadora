import 'dart:io';

import 'package:flutter/material.dart';

class Anexo extends StatelessWidget {
  final String path;

  const Anexo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    if (!path.contains('https')) {
      File file = File(path);
      return _buildImage(file);
    } else {
      return _buildNetworkImage(path);
    }
  }

  Widget _buildImage(File file) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
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

  Widget _buildNetworkImage(String path) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              path,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
