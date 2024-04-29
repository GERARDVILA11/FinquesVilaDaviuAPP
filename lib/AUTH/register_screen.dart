import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/button.dart';
import '../widgets/constant_color.dart';
import '../widgets/quadrat.dart';
import 'google_signin_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _createUserWithEmailAndPassword() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((userCredential) {
      // Crear usuario en la base de datos
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
      }).then((_) {
        _showSuccessDialog(context, 'Usuari creat correctament');
      }).catchError((error) {
        _showErrorDialog(context, 'Error: $error');
      });
    }, onError: (error) {
      if (error is FirebaseAuthException) {
        _showErrorDialog(context, "Error: ${error.message}");
      }
    });
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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

  /* void _createUserWithEmailAndPassword() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((userCredential) {
      //Envia correu de verificació
      userCredential.user!.sendEmailVerification().then((_) {
        _showVerificationDialog(context);
      }).catchError((error) {
        _showErrorDialog(
            context, 'Error en enviar el correu de verificació: $error');
      });

      // Crear usuari a la base de dades
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'emailVerified': userCredential.user!.emailVerified,
      }).then((_) {
        print('Usuari creat correctament a Firestore');
        _checkEmailVerification(userCredential.user!);
      }).catchError((error) {
        _showErrorDialog(
            context, 'Error en desar l\'usuari a Firestore: $error');
      });
    }, onError: (error) {
      if (error is FirebaseAuthException) {
        _showErrorDialog(context, "Error ${error.message}");
      }
    });
  }

  void _checkEmailVerification(User user) {
    user.reload().then((_) {
      if (user.emailVerified) {
        // Actualitzar el camp emailVerified a Firestore
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'emailVerified': true,
        }).then((_) {
          print('Camp emailVerified actualitzat correctament a Firestore');
          _showSuccessDialog(
              context, 'Correu electrònic verificat correctament');
        }).catchError((error) {
          _showErrorDialog(context, 'Error verificar el correu: $error');
        });
      }
    });
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Èxit'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              "S'ha enviat un correu electrònic de verificació a la teva adreça de correu electrònic"),
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
  } */

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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  //logo
                  Image.asset(
                    "assets/logo.png",
                    height: 140,
                  ),

                  const SizedBox(height: 20),

                  //Text de benvinguda
                  const Text(
                    "Uneix-te a nosaltres",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),

                  const SizedBox(
                    height: 40,
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
                      hintText: 'Correu',
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
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != null && value.length >= 8) {
                        // Verificar si la contraseña contiene al menos una mayúscula y un número
                        if (RegExp(r'^(?=.*[A-Z])(?=.*[0-9])')
                            .hasMatch(value)) {
                          return null; // Contraseña válida
                        } else {
                          return 'La contrasenya ha de contenir com a mínim una majúscula i un número';
                        }
                      } else {
                        return 'La contrasenya ha de tenir com a mínim 8 caràcters';
                      }
                    },
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

                  //Confirmar contrasenya Textfield
                  TextFormField(
                    controller: _confirmpasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == _passwordController.text) return null;
                      return "Les contrasenyes no coincideixen";
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
                      hintText: 'Confirmar contrasenya',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Boto Registrar-se
                  WidgetButton(
                    onTap: _validate,
                    text: "Registrar-se",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetQuadrat(
                          onTap: () =>
                              GoogleSignInScreen().signInWithGoogle(context),
                          imatge: 'assets/google.png')
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  //Registrar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ja ets membre? "),
                      const SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Inicia sessió",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      _createUserWithEmailAndPassword();
    }
  }
}
