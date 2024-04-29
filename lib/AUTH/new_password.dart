import 'package:finques_viladaviu_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/constant_color.dart';

class PantallaCanviContrasenya extends StatefulWidget {
  const PantallaCanviContrasenya({super.key});

  @override
  State<PantallaCanviContrasenya> createState() =>
      _PantallaCanviContrasenyaState();
}

class _PantallaCanviContrasenyaState extends State<PantallaCanviContrasenya> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _password = '';
  String _newPassword = '';
  String _confirmPassword = '';

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Si us plau, introdueix la teva contrasenya actual';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Si us plau, introdueix la teva nova contrasenya';
    }
    if (value.length < 6) {
      return 'La nova contrasenya ha de tenir almenys 6 caràcters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Si us plau, confirma la teva nova contrasenya';
    }
    if (value != _newPasswordController.text) {
      return 'Les contrasenyes no coincideixen';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Reautenticar al usuari
          final credential = EmailAuthProvider.credential(
              email: user.email!, password: _password);
          await user.reauthenticateWithCredential(credential);

          // Canviar la contrasenya
          await user.updatePassword(_newPassword);

          // Mostrar missatge d'èxit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contrasenya canviada amb èxit')),
          );

          // Netegem els camps
          _passwordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al canviar la contrasenya: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFinques.gris,
      appBar: AppBar(
        title: const Text(
          'Canvi de Contrasenya',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(
              'assets/logo.png',
              height: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Contrasenya actual',
              ),
              validator: _validatePassword,
              onSaved: (value) => _password = value!,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              validator: _validateNewPassword,
              onSaved: (value) => _newPassword = value!,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Contrasenya nova',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Confirmar nova contrasenya',
              ),
              validator: _validateConfirmPassword,
              onSaved: (value) => _confirmPassword = value!,
            ),
            const SizedBox(height: 20),
            WidgetButton(
              text: "Actualitzar contrasenya",
              onTap: _submitForm,
            ),
          ]),
        ),
      ),
    );
  }
}
