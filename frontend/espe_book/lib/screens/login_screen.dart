import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/blocs/room/room_bloc.dart';
import 'package:espe_book/helpers/mostrar_alerta.dart';
import 'package:espe_book/screens/screens.dart';
import 'package:espe_book/widgets/boton_login.dart';
import 'package:espe_book/widgets/custom_input.dart';
import 'package:espe_book/widgets/labels_login.dart';
import 'package:espe_book/widgets/logo_login.dart';

class LoginScreen extends StatelessWidget {
  static const String loginroute = 'login';

  const LoginScreen({super.key, Key});

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(text: "ESPE Book"),
              _Form(),
              Labels(
                ruta: 'register',
                text: "¿No tienes cuenta?",
                text2: "Crea una",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final roomBloc = BlocProvider.of<RoomBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    final double buttonWidth = MediaQuery.of(context).size.width * 0.4;

    return Column(
      children: [
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
        ),
        SizedBox(
          width: buttonWidth,
          height: 70,
          child: BotonForm(
            text: "Ingrese",
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                final result = await authBloc.login(
                    emailController.text, passwordController.text);
                if (result) {
                  await roomBloc.salasInitEvent();
                  await publicationBloc.getAllPublicaciones();
                  Navigator.pushReplacementNamed(
                      context, LoadingLoginScreen.loadingroute);
                } else {
                  mostrarAlerta(context, "Login incorrecto",
                      "Revise sus credenciales nuevamente");
                }
              } else {
                mostrarAlerta(context, "Campos vacíos",
                    "Por favor, complete todos los campos");
              }
            },
          ),
        ),
      ],
    );
  }
}
