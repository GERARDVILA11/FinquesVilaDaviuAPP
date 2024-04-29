import 'package:finques_viladaviu_app/APP/filtrar_screen.dart';
import 'package:finques_viladaviu_app/widgets/bottomnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/favorits.dart';
import '../models/immoble.dart';
import '../services/db_service.dart';
import '../widgets/constant_color.dart';
import '../widgets/seleccionar_imatge.dart';
import 'info_immoble.dart';

class ImmoblesFiltrats2 extends StatefulWidget {
  final User userId;
  final String operacioSeleccionat;
  final String tipusSeleccionat;
  final String poblacioSeleccionat;
  final double minPrice;
  final double maxPrice;
  final double minSurface;
  final double maxSurface;
  final List<String> numHabs;
  final List<String> features;

  const ImmoblesFiltrats2(
      {required this.userId,
      Key? key,
      required this.operacioSeleccionat,
      required this.tipusSeleccionat,
      required this.poblacioSeleccionat,
      required this.minPrice,
      required this.maxPrice,
      required this.minSurface,
      required this.maxSurface,
      required this.numHabs,
      required this.features})
      : super(key: key);

  @override
  State<ImmoblesFiltrats2> createState() => _ProductListState();
}

class _ProductListState extends State<ImmoblesFiltrats2> {
  List<Favorits> favorites = [];
  late List<Immoble> filteredImmobles = [];
  int Function(Immoble, Immoble)? compare;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.operacioSeleccionat,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              "${widget.tipusSeleccionat == 'Qualsevol' ? 'Qualsevol tipus' : widget.tipusSeleccionat} a ${widget.poblacioSeleccionat == 'Totes' ? 'Totes les poblacions' : widget.poblacioSeleccionat}",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        actions: [
          orderby(context),
          navigateToFiltersPage(
              context,
              widget.userId,
              widget.operacioSeleccionat,
              widget.tipusSeleccionat,
              widget.poblacioSeleccionat),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder<List<Immoble>>(
          stream: DBService.immoblesStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Immoble>> snapshot) {
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

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            filteredImmobles = snapshot.data!.where((immoble) {
              bool operacioMatch =
                  immoble.features["Operació"] == widget.operacioSeleccionat;

              bool tipusMatch = widget.tipusSeleccionat == "Qualsevol" ||
                  immoble.features["Tipus"] == widget.tipusSeleccionat;

              bool poblacioMatch = widget.poblacioSeleccionat == "Totes" ||
                  immoble.features["Població"] == widget.poblacioSeleccionat;

              bool preuMatch = (widget.minPrice == 0 ||
                      immoble.price >= widget.minPrice) &&
                  (widget.maxPrice == 0 || immoble.price <= widget.maxPrice);
              double? immobleSurface = double.tryParse(immoble.features["m2"]!);
              bool superficieMatch = (widget.minSurface == 0 ||
                      immobleSurface != null &&
                          immobleSurface >= widget.minSurface) &&
                  (widget.maxSurface == 0 ||
                      immobleSurface != null &&
                          immobleSurface <= widget.maxSurface);

              // Convertir el valor de habitacions a String
              List<String> habitacionsel =
                  immoble.features["Habitacions"]?.split(",") ?? [];
              bool habitacionsMatch = (widget.numHabs.isEmpty) ||
                  widget.numHabs.any((hab) => habitacionsel.contains(hab));

              bool featuresMatch = false;
              if (widget.features.isNotEmpty) {
                for (String feature in widget.features) {
                  if (immoble.features.containsKey(feature) &&
                          immoble.features[feature] == "Si" ||
                      immoble.features[feature] == "Sí") {
                    featuresMatch = true;
                    break;
                  }
                }
              } else {
                featuresMatch =
                    true; // Si no hay características seleccionadas, todas coinciden
              }

              return operacioMatch &&
                  tipusMatch &&
                  poblacioMatch &&
                  preuMatch &&
                  superficieMatch &&
                  habitacionsMatch &&
                  featuresMatch;
            }).toList();

            if (filteredImmobles.isEmpty) {
              return const Center(
                child: Text(
                    "No s'han trobat immobles amb aquestes característiques"),
              );
            }

            if (compare != null) filteredImmobles.sort(compare);

            return StreamBuilder<List<Favorits>>(
              stream: DBService.getFavorites(widget.userId.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Favorits>> snapshot) {
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

                favorites = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: filteredImmobles.length,
                  itemBuilder: (BuildContext context, int index) {
                    Immoble product = filteredImmobles[index];
                    String productId = product.id;
                    bool isFavorite = favorites.contains(Favorits(
                        UID: widget.userId.uid, idproducte: productId));

                    String formattedPrice;
                    if (product.features["Operació"] == "Lloguer") {
                      if (product.price >= 1000) {
                        formattedPrice =
                            '${(product.price / 1000).toStringAsFixed(3)} €/mes';
                      } else {
                        formattedPrice =
                            '${product.price.toStringAsFixed(2)} €/mes';
                      }
                    } else {
                      if (product.price >= 1000) {
                        formattedPrice =
                            '${(product.price / 1000).toStringAsFixed(3)} €';
                      } else {
                        formattedPrice =
                            '${product.price.toStringAsFixed(2)} €';
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoImmoble(
                                immobleSeleccionat: product,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child:
                                    ImageSelector(image: product.imagePortada),
                              ),
                              Container(
                                color: Colors.green,
                                width: 400,
                                child: Center(
                                  child: Text(
                                    product.title ?? product.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      formattedPrice,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        Text("${product.features["m2"]!} m²"),
                                        //const SizedBox(width: 10),
                                        mostrarHabitacions(product.features),
                                        //const SizedBox(width: 10),
                                        mostrarAscensor(product.features),
                                        //const SizedBox(width: 10),
                                        mostrarParking(product.features),
                                        //const SizedBox(width: 10),
                                        mostrarJardi(product.features)
                                      ],
                                    ),
                                    Text(product.subtitle ?? product.name),
                                    Text(
                                      product.features["Població"]!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (isFavorite) {
                                              DBService.deleteFavorite(Favorits(
                                                  UID: widget.userId.uid,
                                                  idproducte: product.id));
                                            } else {
                                              DBService.addFavorite(Favorits(
                                                  UID: widget.userId.uid,
                                                  idproducte: product.id));
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                isFavorite ? 'Desat' : 'Desar',
                                                style: TextStyle(
                                                  color: isFavorite
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            sendEmail(
                                                context,
                                                productId,
                                                product.name,
                                                product.reference);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.mail_outline_rounded,
                                                color: ColorFinques.verd,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "Contactar",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            FlutterShare.share(
                                                title:
                                                    "Dona un cop d'ull en aquest immoble:\n${product.name} ");
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: ColorFinques.verd,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Compartir",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const WidgetBottomAppBar(),
    );
  }

  Widget mostrarHabitacions(Map<String, dynamic> features) {
    if (features["Habitacions"] != null) {
      return Text("${features["Habitacions"]} habs.");
    } else {
      return const SizedBox();
    }
  }

  Widget mostrarParking(Map<String, dynamic> features) {
    if (features["Parking"] == "Sí" || features["Parking"] == "Si") {
      return const Text("Parking");
    } else {
      return const SizedBox();
    }
  }

  Widget mostrarJardi(Map<String, dynamic> features) {
    if (features["Jardí"] == "Sí" || features["Jardí"] == "Si") {
      return const Text("Jardí");
    } else {
      return const SizedBox();
    }
  }

  Widget mostrarAscensor(Map<String, dynamic> features) {
    if (features["Ascensor"] == "Sí" || features["Ascensor"] == "Si") {
      return const Text("Ascensor");
    } else {
      return const SizedBox();
    }
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

  Widget navigateToFiltersPage(BuildContext context, User user, String operacio,
      String tipus, String poblacio) {
    return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterScreen(
                userId: user,
                operacioSeleccionat: operacio,
                tipusSeleccionat: tipus,
                poblacioSeleccionat: poblacio,
              ),
            ),
          );
        },
        icon: const Icon(Icons.filter_alt));
  }

  Widget orderby(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        // Mostrar un diàleg o menú de opciones para que el usuario seleccione el criterio de ordenación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ordenar per'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Preu: Menys a més'),
                    onTap: () {
                      // Ordenar la lista de inmuebles por precio de menor a mayor
                      setState(() {
                        compare = (a, b) => a.price.compareTo(b.price);
                      });
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                  ),
                  ListTile(
                    title: const Text('Preu: Més a menys'),
                    onTap: () {
                      // Ordenar la lista de inmuebles por precio de mayor a menor
                      setState(() {
                        compare = (a, b) => b.price.compareTo(a.price);
                      });
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                  ),
                  ListTile(
                    title: const Text('Superfície: Menys a més'),
                    onTap: () {
                      // Ordenar la lista de inmuebles por superficie de menor a mayor
                      setState(() {
                        compare = (a, b) {
                          int m2a = int.tryParse(a.features["m2"]!) ?? 99999999;
                          int m2b = int.tryParse(b.features["m2"]!) ?? 99999999;
                          return m2a.compareTo(m2b);
                        };
                      });
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                  ),
                  ListTile(
                    title: const Text('Superfície: Més a menys'),
                    onTap: () {
                      // Ordenar la lista de inmuebles por superficie de mayor a menor
                      setState(() {
                        compare = (a, b) {
                          int m2a = int.tryParse(a.features["m2"]!) ?? 0;
                          int m2b = int.tryParse(b.features["m2"]!) ?? 0;
                          return m2b.compareTo(m2a);
                        };
                      });
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
