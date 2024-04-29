import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

// ignore: use_key_in_widget_constructors
class PasswordResetScreen extends StatefulWidget {
  @override
  PasswordResetScreenState createState() => PasswordResetScreenState();
}

class PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Muestra un mensaje al usuario de que se envió un correo para restablecer la contraseña
      _showSuccessDialog(
          "S'ha enviat un correu electrònic per restablir la contrasenya");
    } catch (e) {
      // Maneja errores, por ejemplo, si el correo electrónico no está registrado
      _showErrorDialog("Upps... Sembla que alguna cosa ha fallat");
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fet!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFinques.gris,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                //logo
                Image.asset(
                  'assets/logo.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 50),
                const Text("Introduïu el correu per reiniciar la contrasenya"),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = RegExp(pattern);
                    if (value != null && !regex.hasMatch(value)) {
                      return 'Format del correu invàlid';
                    } else {
                      return null;
                    }
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => _validate(),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Correu',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                //Boto Inici sessio
                WidgetButton(
                  onTap: _validate,
                  text: "Recuperar contrasenya",
                ),
                const SizedBox(
                  height: 50,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ja ets membre? "),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      child: const Text(
                        "Inicia sessió",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }
}
