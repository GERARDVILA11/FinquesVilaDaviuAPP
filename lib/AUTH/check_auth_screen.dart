import 'package:finques_viladaviu_app/APP/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Usuari logejat
          if (snapshot.hasData) {
            //return const HomeScreen();
            return const HomeScreen();
          }
          // Usuari NO logejat
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
