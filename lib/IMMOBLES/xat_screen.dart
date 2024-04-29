import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ChatPage extends StatefulWidget {
  final String inmuebleId;
  final String inmuebleLink;

  const ChatPage(
      {Key? key, required this.inmuebleId, required this.inmuebleLink})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Missatge:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: 'Telèfon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: enviarMensaje,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  void enviarMensaje() async {
    String mensaje =
        "Hola, estic interessat en el següent immoble (${widget.inmuebleId}, ${widget.inmuebleLink}), m'agradaria saber més informació.\n";
    mensaje += "Nombre: ${nombreController.text}\n";
    mensaje += "Email: ${emailController.text}\n";
    mensaje += "Telf: ${telefonoController.text}\n";
    mensaje += "Moltes gràcies";

    final Email email = Email(
      body: mensaje,
      subject: 'Consulta sobre inmueble',
      recipients: ['gerardvila11@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
      // Si el correo se envía con éxito, puedes mostrar un mensaje de éxito o navegar a otra pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missatge enviat correctament'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Si hay un error al enviar el correo, puedes mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enviar el mensaje'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
