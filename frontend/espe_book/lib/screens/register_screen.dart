import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/auth/auth_bloc.dart';
import 'package:espe_book/helpers/mostrar_alerta.dart';
import 'package:espe_book/screens/screens.dart';
import 'package:espe_book/widgets/boton_login.dart';
import 'package:espe_book/widgets/custom_input.dart';
import 'package:espe_book/widgets/labels_login.dart';
import 'package:espe_book/widgets/logo_login.dart';

class RegisterScreen extends StatelessWidget {
  static const String registerroute = 'register';

  const RegisterScreen({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 90), // Ajuste de padding aquí
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightGreen.shade300,
                Colors.lightGreen.shade50,
              ],
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(text: ""),
              _From(),
              Labels(
                ruta: 'login',
                text: "¿Ya tienes cuenta?",
                text2: "Ingresa",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _From extends StatefulWidget {
  const _From();

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authServiceBloc = BlocProvider.of<AuthBloc>(context);

    return Column(
      children: [
        CustonInput(
          icon: Icons.perm_identity,
          placeholder: "Nombres",
          keyboardType: TextInputType.text,
          textController: nomController,
        ),
        CustonInput(
          icon: Icons.mail_outline,
          placeholder: "Email",
          keyboardType: TextInputType.emailAddress,
          textController: emailController,
        ),
        CustonInput(
          icon: Icons.lock_outline,
          placeholder: "Password",
          textController: passwordController,
          isPassword: true,
          obscurePassword: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        BotonForm(
          text: "Crear cuenta",
          onPressed: authServiceBloc.isLoggedInTrue
              ? () {}
              : () async {
                  FocusScope.of(context).unfocus();

                  String nombre = nomController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
                    mostrarAlerta(context, 'Campos vacíos',
                        'Todos los campos son obligatorios');
                    return;
                  }

                  if (!isValidEmail(email)) {
                    mostrarAlerta(context, 'Correo electrónico inválido',
                        'Ingrese un correo electrónico válido');
                    return;
                  }

                  if (password.length < 6) {
                    mostrarAlerta(context, 'Contraseña inválida',
                        'La contraseña debe tener al menos 6 caracteres');
                    return;
                  }

                  if (!containsNumber(password)) {
                    mostrarAlerta(context, 'Contraseña inválida',
                        'La contraseña debe contener al menos un número');
                    return;
                  }

                  if (!containsUppercaseLetter(password)) {
                    mostrarAlerta(context, 'Contraseña inválida',
                        'La contraseña debe contener al menos una letra en mayúscula');
                    return;
                  }

                  final resulta =
                      await authServiceBloc.register(nombre, email, password);

                  if (!resulta) {
                    mostrarAlerta(context, 'Correo electrónico en uso',
                        'El correo electrónico ya está en uso');
                    return;
                  }

                  if (authServiceBloc.isLoggedInTrue) {
                    Navigator.pushReplacementNamed(
                        context, LoadingLoginScreen.loadingroute);
                  } else {
                    mostrarAlerta(context, 'Registro incorrecto',
                        'Revise sus credenciales nuevamente');
                  }
                },
        ),
      ],
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

    return emailRegex.hasMatch(email);
  }

  bool containsNumber(String password) {
    return password.contains(RegExp(r'\d'));
  }

  bool containsUppercaseLetter(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }
}
