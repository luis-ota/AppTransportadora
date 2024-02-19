import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String path;
  final bool vendo;

  const PreviewPage({super.key, required this.path, required this.vendo});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: (widget.path.contains('https'))
                      ? Image.network(
                          widget.path,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.path),
                          fit: BoxFit.cover,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !widget.vendo,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.black.withOpacity(.5),
                            child: IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pop(File(widget.path)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.black.withOpacity(.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
