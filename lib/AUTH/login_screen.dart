import 'package:finques_viladaviu_app/widgets/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/button.dart';
import '../widgets/quadrat.dart';
import 'google_signin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signInWithEmailAndPassword() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then(
      (user) {
        Navigator.pushReplacementNamed(
          context,
          "/home",
        );
      },
      onError: (error) => _showErrorDialog(
        context,
        "${(error as FirebaseAuthException).message}",
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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

                  const SizedBox(height: 20),

                  //Text de benvinguda
                  const Text(
                    "Benvingut, et trobàvem a faltar!",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //Usuari TextField
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
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Correu electrònic',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //Contrasenya Textfield
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value != null && value.length >= 6) return null;
                      return 'La contrasenya ha de contenir 6 caràcters com a mínim';
                    },
                    onFieldSubmitted: (value) => _validate(),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Contrasenya',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Recordar Contrasenya
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, "/forgetpassword");
                        },
                        child: Text(
                          "No recordes la contrasenya?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  //Boto Inici sessio
                  WidgetButton(
                    onTap: _validate,
                    text: "Iniciar Sessió",
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //o continua amb
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 0.5,
                        width: 95,
                        color: Colors.black,
                      ),
                      const Text(
                        "  O continua amb  ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Container(
                        height: 0.5,
                        width: 95,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  //Google Sign in
                  WidgetQuadrat(
                      onTap: () =>
                          GoogleSignInScreen().signInWithGoogle(context),
                      imatge: 'assets/google.png'),

                  const SizedBox(
                    height: 35,
                  ),

                  //Registrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No ets membre? "),
                      const SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: const Text(
                          "Registra't",
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
        ),
      ),
    );
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      _signInWithEmailAndPassword();
    }
  }
}
