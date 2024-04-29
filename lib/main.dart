import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finques_viladaviu_app/AUTH/check_auth_screen.dart';
import 'package:finques_viladaviu_app/AUTH/new_password.dart';
import 'package:finques_viladaviu_app/APP/about_us_screen.dart';
import 'package:finques_viladaviu_app/APP/home_screen.dart';
import 'AUTH/forgetpassword_screen.dart';
import 'AUTH/login_screen.dart';
import 'APP/perfil_screen.dart';
import 'AUTH/register_screen.dart';
import 'APP/favorite_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dades/immobles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get immobleSeleccionat => null;

  @override
  Widget build(BuildContext context) {
    // executar nomes un cop per carregar valors a la BBDD
    //insertProductesFirebase();

    return MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white)),
            bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white)),
        debugShowCheckedModeBanner: false,
        //home: const AuthScreen(),

        initialRoute: "/checkauth",
        routes: {
          //RUTES AUTH
          "/checkauth": (context) => const AuthScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          "/forgetpassword": (context) => PasswordResetScreen(),
          "/signout": (context) => const PerfilScreen(),
          "/newpassword": (context) => const PantallaCanviContrasenya(),
          //RUTES APP
          "/home": (context) => const HomeScreen(),
          "/favorits": (context) => const FavoriteProductsScreen(),
          //RUTES PERFIL
          "Sobre nosaltres": (context) => const AboutUs(),
        });
  }

  void insertProductesFirebase() {
    for (Map<String, dynamic> i in immobles) {
      i['id'] = i['id'].toString();
      var id = i['id'];
      FirebaseFirestore.instance.collection('immobles').doc(id).set(i);
    }
  }
}
