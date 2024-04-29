import 'package:cached_network_image/cached_network_image.dart';
import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/favorits.dart';
import '../models/immoble.dart';
import '../services/db_service.dart';
import 'full_image_screen.dart';
import 'package:flutter_share/flutter_share.dart';

class InfoImmoble extends StatefulWidget {
  final Immoble immobleSeleccionat;
  const InfoImmoble({Key? key, required this.immobleSeleccionat})
      : super(key: key);

  @override
  State<InfoImmoble> createState() => _InfoImmobleState();
}

class _InfoImmobleState extends State<InfoImmoble> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.immobleSeleccionat.title ?? widget.immobleSeleccionat.name,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: ImmobleSeleccionat(
          immoble: widget.immobleSeleccionat,
          userId: _user!,
        ),
      ),
      bottomNavigationBar: FloatingButtons(
        immoble: widget.immobleSeleccionat,
        userId: _user!,
      ),
    );
  }
}

class FloatingButtons extends StatefulWidget {
  final Immoble immoble;
  final User userId;

  const FloatingButtons({
    Key? key,
    required this.immoble,
    required this.userId,
  }) : super(key: key);

  @override
  State<FloatingButtons> createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
  List<Favorits> favorites = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Favorits>>(
      stream: DBService.getFavorites(widget.userId.uid),
      builder: (BuildContext context, AsyncSnapshot<List<Favorits>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        favorites = snapshot.data!;
        bool isFavorite = favorites.contains(
          Favorits(UID: widget.userId.uid, idproducte: widget.immoble.id),
        );

        return Container(
          width: 400,
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      // Cambiar el estado localmente al hacer clic en el botón
                      if (isFavorite) {
                        DBService.deleteFavorite(
                          Favorits(
                            UID: widget.userId.uid,
                            idproducte: widget.immoble.id,
                          ),
                        );
                      } else {
                        DBService.addFavorite(
                          Favorits(
                            UID: widget.userId.uid,
                            idproducte: widget.immoble.id,
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    isFavorite ? 'Desat' : 'Desar',
                    style: TextStyle(
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      sendEmail(context, widget.immoble.id, widget.immoble.name,
                          widget.immoble.reference);
                    },
                  ),
                  const Text(
                    "Contactar",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      FlutterShare.share(
                          title:
                              "Dona un cop d'ull en aquest immoble:\n${widget.immoble.name} ");
                    },
                  ),
                  const Text(
                    "Compartir",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void sendEmail(BuildContext context, String inmuebleId, String title,
      String referencia) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'finquesviladaviu@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject':
            'Sol·licito més informació sobre el següent immoble $referencia',
        'mailto': widget.userId.email!,
        'body': '''
Benvolguts,

Estic interessat/da en el següent immoble:
  Títol: $title
  Referència: $referencia

Dades de contacte:
  Nom:
  Telèfon:
  Correu: ${widget.userId.email}

Moltes gràcies
'''
      }),
    );

    launchUrl(emailLaunchUri);
  }
}

class ImmobleSeleccionat extends StatefulWidget {
  final Immoble immoble;
  final User userId;

  const ImmobleSeleccionat(
      {super.key, required this.immoble, required this.userId});

  @override
  State<ImmobleSeleccionat> createState() => _ImmobleSeleccionatState();
}

class _ImmobleSeleccionatState extends State<ImmobleSeleccionat> {
  List<Favorits> favorites = [];
  @override
  Widget build(BuildContext context) {
    String formattedPrice;
    if (widget.immoble.features["Operació"] == "Lloguer") {
      if (widget.immoble.price >= 1000) {
        formattedPrice =
            '${(widget.immoble.price / 1000).toStringAsFixed(3)} €/mes';
      } else {
        formattedPrice = '${widget.immoble.price.toStringAsFixed(2)} €/mes';
      }
    } else {
      if (widget.immoble.price >= 1000) {
        formattedPrice =
            '${(widget.immoble.price / 1000).toStringAsFixed(3)} €';
      } else {
        formattedPrice = '${widget.immoble.price.toStringAsFixed(2)} €';
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ImageSlider(
          immoble: widget.immoble,
          imageLinks: widget.immoble.imageLinks,
          placeholderLink: widget.immoble.imagePortada,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.immoble.title ?? widget.immoble.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(widget.immoble.features["Població"]!),
              Text(
                formattedPrice,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text("${widget.immoble.features["m2"]!} m²"),
                  const SizedBox(
                    width: 10,
                  ),
                  mostrarHabitacions(widget.immoble.features),
                  const SizedBox(
                    width: 10,
                  ),
                  mostrarParking(widget.immoble.features),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Descripció",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorFinques.verd),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(widget.immoble.longDesc ??
                  widget.immoble.subtitle ??
                  widget.immoble.title ??
                  widget.immoble.name),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Característiques",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorFinques.verd),
              ),
              const SizedBox(
                height: 10,
              ),
              _mostrarFeatures(widget.immoble.features),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Galeria",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorFinques.verd),
              ),
              ImageList(
                imageUrls: widget.immoble.imageLinks,
                imagePortada: widget.immoble.imagePortada,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget mostrarHabitacions(Map<String, dynamic> features) {
  if (features["Habitacions"] != null) {
    return Text("${features["Habitacions"]} habs.");
  } else {
    return const SizedBox(); // Retorna un contenedor vacío si el valor es null
  }
}

Widget mostrarParking(Map<String, dynamic> features) {
  if (features["Parking"] == "Sí" || features["Parking"] == "Si") {
    return const Text("Amb pàrquing");
  } else if (features["Parking"] == "No" || features["Parking"] == "no") {
    return const Text("Sense pàrquing");
  } else {
    return const SizedBox();
  }
}

Widget _mostrarFeatures(Map<String, dynamic> features) {
  return Column(children: [
    _iconaText(const Icon(Icons.map_rounded), "Població", features["Població"]),
    Row(
      children: [
        _iconaText(const Icon(Icons.crop_square_outlined), "Superfície",
            features["m2"]),
        const Text(" m²")
      ],
    ),
    _iconaText(
        const Icon(Icons.bed_rounded), "Habitacions", features["Habitacions"]),
    _iconaText(
        const Icon(Icons.car_rental_rounded), "Parking", features["Parking"]),
    _iconaText(const Icon(Icons.nature_rounded), "Jardí", features["Jardí"]),
    _iconaText(const Icon(Icons.elevator), "Ascensor", features["Ascensor"]),
    _iconaText(
        const Icon(Icons.location_on), "Orientació", features["orientació"]),
    _iconaText(const Icon(Icons.pool_rounded), "Piscina", features["Piscina"]),
    _iconaText(const Icon(Icons.meeting_room_outlined), "Traster",
        features["Traster"]),
    _iconaText(const Icon(Icons.home), "Tipus", features["Tipus"]),
    _iconaText(const Icon(Icons.sell), "Operació", features["Operació"]),
  ]);
}

Widget _iconaText(Icon icona, String feature, String? valor) {
  return Row(
    children: [
      icona,
      const SizedBox(
        width: 5,
      ),
      Text("$feature: "),
      Text(valor ?? "No")
    ],
  );
}

class ImageSlider extends StatefulWidget {
  final Immoble immoble;
  final List<String> imageLinks;
  final String placeholderLink;

  const ImageSlider({
    Key? key,
    required this.imageLinks,
    required this.placeholderLink,
    required this.immoble,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;
  int requestCount = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          child: widget.imageLinks.isEmpty
              ? Image.network(
                  widget.placeholderLink,
                  fit: BoxFit.cover,
                )
              : PageView.builder(
                  itemCount: widget.imageLinks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FullImageScreen(
                            imageLinks: widget.imageLinks,
                            initialPage: index,
                            immobleSeleccionat: widget.immoble,
                          ),
                        ));
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FutureBuilder(
                            future: _getImage(index),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(child: Icon(Icons.error));
                              } else {
                                return CachedNetworkImage(
                                  imageUrl: snapshot.data!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                );
                              }
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              "assets/logo.png",
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
        ),
        if (widget.imageLinks.isNotEmpty)
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              "${_currentPage + 1}/${widget.imageLinks.length}",
              style: const TextStyle(
                fontSize: 10,
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
      ],
    );
  }

  Future<String> _getImage(int index) async {
    if (++requestCount % 5 == 0) {
      // Si es la quinta petición, esperar 1 segundo
      await Future.delayed(const Duration(seconds: 1));
    }
    return index == 0
        ? widget.immoble.imagePortada
        : widget.imageLinks[index - 1];
  }
}

class ImageList extends StatelessWidget {
  final String imagePortada;
  final List<String> imageUrls;

  const ImageList({
    Key? key,
    required this.imageUrls,
    required this.imagePortada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageUrls.isEmpty)
            Image.network(imagePortada)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: _getImage(index),
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
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        );
                      }
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<String> _getImage(int index) async {
    if ((index + 1) % 5 == 0) {
      // Si es la quinta petición, esperar 1 segundo
      await Future.delayed(const Duration(seconds: 1));
    }
    return index == 0 ? imagePortada : imageUrls[index - 1];
  }
}
