import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';

class PasswordScreen extends StatefulWidget {
  static const String passwordroute = 'password';
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  AuthBloc authBloc = AuthBloc();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isEmpty = true;
  bool _passwordsMatch = true;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();

    _currentPasswordController.addListener(_checkPasswordRequirements);
    _newPasswordController.addListener(_checkPasswordRequirements);
    _confirmPasswordController.addListener(_checkPasswordRequirements);
  }

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(106, 162, 142, 1),
        actions: [
          IconButton(
            onPressed: () async {
              if (_newPasswordController.text.length < 6) {
                _showAlertDialog(
                  title: 'Error',
                  content: 'La contraseña debe tener al menos 6 caracteres.',
                );
                return;
              }

              if (_newPasswordController.text != _confirmPasswordController.text) {
                _passwordsMatch = false;
                _showPasswordMismatchDialog();
                return;
              }

              final result = await authBloc.cambiarContrasena(
                authBloc.state.usuario!.email,
                _currentPasswordController.text,
                _newPasswordController.text,
              );

              if (!result) {
                _showAlertDialog(
                  title: 'Error',
                  content: 'No se pudo cambiar la contraseña. Por favor, asegúrate de que la contraseña actual sea correcta.',
                );
                return;
              }

              Navigator.pop(context);
            },
            icon: Icon(
              Icons.check,
              color: _isEmpty || !_passwordsMatch ? Colors.grey : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _currentPasswordController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Contraseña Actual',
                  labelStyle: const TextStyle(color: Color.fromRGBO(106, 162, 142, 1)),
                  prefixIcon: const Icon(Icons.lock, color: Color.fromRGBO(106, 162, 142, 1)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty ? Color.fromRGBO(2, 79, 49, 1) : Color.fromRGBO(106, 162, 142, 1),
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _newPasswordController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                  labelStyle: const TextStyle(color: Color.fromRGBO(106, 162, 142, 1)),
                  prefixIcon: const Icon(Icons.lock_open, color: Color.fromRGBO(106, 162, 142, 1)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty ? Color.fromRGBO(2, 79, 49, 1) : Color.fromRGBO(106, 162, 142, 1),
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _confirmPasswordController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Confirmar Nueva Contraseña',
                  labelStyle: const TextStyle(color: Color.fromRGBO(106, 162, 142, 1)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color.fromRGBO(106, 162, 142, 1)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty ? Color.fromRGBO(2, 79, 49, 1) : Color.fromRGBO(106, 162, 142, 1),
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Color.fromRGBO(106, 162, 142, 1))),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordMismatchDialog() {
    _showAlertDialog(
      title: 'Contraseñas no coinciden',
      content: 'Las contraseñas no coinciden. Por favor, asegúrate de que sean iguales.',
    );
  }

  void _checkPasswordRequirements() {
    final newPassword = _newPasswordController.text;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(newPassword);
    final hasNumber = RegExp(r'[0-9]').hasMatch(newPassword);
    final meetsLengthRequirement = newPassword.length >= 6;

    setState(() {
      _passwordsMatch = _newPasswordController.text == _confirmPasswordController.text;
      _isEmpty = _currentPasswordController.text.isEmpty ||
          newPassword.isEmpty ||
          _confirmPasswordController.text.isEmpty;
      _passwordsMatch = _passwordsMatch && meetsLengthRequirement && hasUpperCase && hasNumber;
    });
  }
}
