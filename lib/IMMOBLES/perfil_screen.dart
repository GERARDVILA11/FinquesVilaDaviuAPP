import 'package:finques_viladaviu_app/widgets/bottomnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
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
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Perfil",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            usuari(),
            const SizedBox(
              height: 20,
            ),
            HolaUsuari(user: _user),
            const SizedBox(
              height: 20,
            ),
            WidgetContainer(
                ontap: _navegarOficina,
                icona: const Icon(Icons.room_outlined),
                text: "La nostra oficina"),
            const SizedBox(
              height: 20,
            ),
            WidgetContainer(
                ontap: _navegarPaginaWeb,
                icona: const Icon(Icons.web_asset_rounded),
                text: "Visita la nostra pàgina web"),
            const SizedBox(
              height: 20,
            ),
            WidgetContainer(
                ontap: _trucar,
                icona: const Icon(Icons.phone),
                text: "Tens algun dubte? Truca'ns"),
            const SizedBox(
              height: 20,
            ),
            WidgetContainer(
                ontap: _navegarPantallaInfo,
                icona: const Icon(Icons.info),
                text: "Sobre Finques Vila Daviu"),
            const SizedBox(
              height: 20,
            ),
            WidgetContainer(
                ontap: _newPassword,
                icona: const Icon(Icons.edit),
                text: "Canviar contrasenya"),
            const SizedBox(
              height: 20,
            ),
            const SignOut(),
          ],
        ),
      ),
      bottomNavigationBar: const WidgetBottomAppBar(),
    );
  }

  void _navegarOficina() {
    final Uri url = Uri.parse("https://maps.app.goo.gl/NSArdvRNHe3bZfDE8");
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void _navegarPaginaWeb() {
    final Uri url = Uri.parse("https://finquesviladaviu.com/ca");
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void _trucar() async {
    const String numero = '973673045';
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Error al trucar  $url';
    }
  }

  void _navegarPantallaInfo() {
    Navigator.pushNamed(context, "Sobre nosaltres");
  }

  void _newPassword() {
    Navigator.pushNamed(context, "/newpassword");
  }

  Widget usuari() {
    return const CircleAvatar(
      radius: 60,
      backgroundColor: Colors.white,
      child: Center(
        child: Icon(
          Icons.person_outline_outlined,
          size: 80,
          color: Colors.black,
        ),
      ),
    );
  }
}

class HolaUsuari extends StatelessWidget {
  final User? user;
  const HolaUsuari({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: 400,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            "Hola ${user?.email ?? user?.displayName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final void Function() ontap;
  final Icon icona;
  final String text;
  const WidgetContainer(
      {super.key,
      required this.ontap,
      required this.icona,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white), // Borde superior verd
            bottom: BorderSide(color: Colors.white), // Borde inferior verd
          ),
          color: Colors.transparent,
        ),
        width: 400,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            icona,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}

class SignOut extends StatelessWidget {
  const SignOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarQuadreDialeg(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white), // Borde superior verd
            bottom: BorderSide(color: Colors.white), // Borde inferior verd
          ),
          color: Colors.transparent,
        ),
        width: 400,
        height: 40,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.logout,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Tancar Sessió",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarQuadreDialeg(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmació"),
          content: const Text("Esteu segur de tancar la sessió?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tancar el quadre de diàleg
              },
              child: const Text("Cancel·lar"),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("/checkauth");
              },
              child: const Text("Sí"),
            ),
          ],
        );
      },
    );
  }
}
