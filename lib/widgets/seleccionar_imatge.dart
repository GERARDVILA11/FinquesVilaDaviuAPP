import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSelector extends StatefulWidget {
  final String image;

  const ImageSelector({Key? key, required this.image}) : super(key: key);

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  int requestCount = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: widget.image.isEmpty
          ? Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            )
          : FutureBuilder(
              future: _getImage(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                } else {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  );
                }
              },
            ),
    );
  }

  Future<String> _getImage() async {
    if (++requestCount % 5 == 0) {
      // Si es la quinta petición, esperar 1 segundo
      await Future.delayed(const Duration(seconds: 1));
    }
    return widget.image;
  }
}
