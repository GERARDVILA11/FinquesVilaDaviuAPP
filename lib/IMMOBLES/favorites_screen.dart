import 'package:finques_viladaviu_app/APP/info_immoble.dart';
import 'package:finques_viladaviu_app/models/favorits.dart';
import 'package:finques_viladaviu_app/models/immoble.dart';
import 'package:finques_viladaviu_app/services/db_service.dart';
import 'package:finques_viladaviu_app/widgets/bottomnavigationbar.dart';
import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/seleccionar_imatge.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
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
      backgroundColor: ColorFinques.gris,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Els teus favorits',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          _user != null
              ? Expanded(
                  child: FavoriteProductList(user: _user!, userId: _user!.uid))
              : const Center(child: Text('Usuario no autenticado')),
        ],
      ),
      bottomNavigationBar: const WidgetBottomAppBar(),
    );
  }
}

class FavoriteProductList extends StatefulWidget {
  final User user;
  final String userId;

  const FavoriteProductList(
      {required this.userId, Key? key, required this.user})
      : super(key: key);

  @override
  State<FavoriteProductList> createState() => _FavoriteProductListState();
}

class _FavoriteProductListState extends State<FavoriteProductList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Favorits>>(
      stream: DBService.getFavorites(widget.userId),
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
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Favorits> favorites = snapshot.data!;
        if (favorites.isEmpty) {
          return const Center(
            child: Text("Actualment no tens cap immoble marcat com a favorit"),
          );
        }
        return StreamBuilder<List<Immoble>>(
            stream: DBService.immoblesFavoritsStream(favorites),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Immoble product = snapshot.data![index];
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
                      formattedPrice = '${product.price.toStringAsFixed(2)} €';
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
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
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: ImageSelector(image: product.imagePortada),
                            ),
                            Container(
                              color: ColorFinques.verd,
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
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    formattedPrice,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _borrarProducte(product.id);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Desat",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          sendEmail(context, product.id,
                                              product.name, product.reference);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.mail_outline_rounded,
                                              color: ColorFinques.verd,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Contactar",
                                              style: TextStyle(
                                                  color: ColorFinques.verd),
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
                                              color: Colors.green,
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
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
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
        'mailto': widget.user.email!,
        'body': '''
Benvolguts,

Estic interessat/da en el següent immoble:
  Títol: $title
  Referència: $referencia

Dades de contacte:
  Nom:
  Telèfon:
  Correu: ${widget.user.email}

Moltes gràcies
'''
      }),
    );

    launchUrl(emailLaunchUri);
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

  void _borrarProducte(String product) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: const Text("Desmarcar de favorits?"),
            actions: [
              TextButton(
                onPressed: () {
                  DBService.deleteFavorite(
                      Favorits(UID: widget.userId, idproducte: product));
                  Navigator.of(context).pop();
                },
                child: const Text('SI'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('NO'),
              )
            ],
          ),
        );
      },
    );
  }
}
