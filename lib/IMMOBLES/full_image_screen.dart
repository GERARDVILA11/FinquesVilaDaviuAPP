import 'package:flutter/material.dart';

import '../models/immoble.dart';

class FullImageScreen extends StatelessWidget {
  final Immoble immobleSeleccionat;
  final List<String> imageLinks;
  final int initialPage;

  const FullImageScreen({
    Key? key,
    required this.imageLinks,
    required this.initialPage,
    required this.immobleSeleccionat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          immobleSeleccionat.title ?? immobleSeleccionat.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: imageLinks.length,
            controller: PageController(initialPage: initialPage),
            itemBuilder: (context, index) {
              if (index == 0) {
                // Mostrar la imagen de portada primero
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Image.network(
                        immobleSeleccionat
                            .imagePortada, // Usar la imagen de portada
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Text(
                        "1/${imageLinks.length}", // Solo una imagen
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                );
              } else {
                // Mostrar las demás imágenes
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Image.network(
                        imageLinks[index - 1], // Usar las demás imágenes
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Text(
                        "${index + 1}/${imageLinks.length}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Image.asset(
                        "assets/logo.png",
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
