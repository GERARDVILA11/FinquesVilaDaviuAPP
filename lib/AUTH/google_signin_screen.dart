import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInScreen {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      // Imprime los detalles del usuario
      /* print("Usuario: ${user?.displayName}");
      print("Email: ${user?.email}");
      print("UID: ${user?.uid}"); */

      // Crea el usuario en Firestore
      // ignore: use_build_context_synchronously
      await createUserInFirestore(context, user?.email, user?.uid);
      //Navegar a home
      Navigator.pushReplacementNamed(context, "/home");

      return user;
    } catch (error) {
      _showErrorDialog(context, "Error al iniciar sesión con Google: $error");
      return null;
    }
  }

  Future<void> createUserInFirestore(
      BuildContext context, String? email, String? uid) async {
    try {
      if (email != null && uid != null) {
        // Verifica si el usuario ya existe en Firestore
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!userDoc.exists) {
          // El usuario no existe en Firestore, crea el documento
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set({'email': email});
        }
      }
    } catch (error) {
      _showErrorDialog(context, "Error al crear usuario en Firestore: $error");
    }
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
}
