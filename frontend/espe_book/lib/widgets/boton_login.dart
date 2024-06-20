import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BotonForm extends StatelessWidget {
  final String text;
  final Function onPressed;

  const BotonForm({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        shadowColor: Colors.grey.withOpacity(0.9),
        child: InkWell(
          onTap: () => text == "Google" ? _handleGoogleSignIn() : onPressed(),
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xFF1F5545), // Color azul típico de los botones en Android
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: text == "Google"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          text,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                  : Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Aquí puedes usar googleAuth.accessToken y googleAuth.idToken
      // para autenticarte con tu backend si es necesario.
      
      print('Google User ID: ${googleUser.id}');
      print('Google Auth Token: ${googleAuth.accessToken}');

      // Llamar a la función onPressed pasada como argumento
      onPressed();
    } catch (error) {
      print('Error en Google Sign-In: $error');
    }
  }
}
