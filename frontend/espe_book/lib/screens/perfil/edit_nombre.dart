import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/auth/auth_bloc.dart';

class EditNombreScreen extends StatefulWidget {
  static const String editNombreroute = 'editNombre';
  const EditNombreScreen({Key? key});

  @override
  State<EditNombreScreen> createState() => _EditNombreScreenState();
}

class _EditNombreScreenState extends State<EditNombreScreen> {
  AuthBloc authBloc = AuthBloc();
  bool _isEmpty = true; // Variable para controlar si el TextField está vacío

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _textController.text = authBloc.state.usuario!.nombre;

    _textController.addListener(() {
      setState(() {
        _isEmpty = _textController.text.isEmpty;
      });
    });
  }

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Cambiar Nombre',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(106, 162, 142, 1),
        actions: [
          IconButton(
            onPressed: () {
              if (_isEmpty) return;
              authBloc.updateUsuario(_textController.text, authBloc.state.usuario!.telefono ?? '');
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.check,
              color: _isEmpty ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Color.fromRGBO(106, 162, 142, 1),
          //         Color.fromRGBO(106, 162, 142, 1),
          //       ],
          //     ),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         IconButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           icon: const Icon(Icons.arrow_back, color: Colors.white),
          //         ),
          //         const SizedBox(width: 50), // Espacio para centrar el texto
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                maxLength: 50,
                onChanged: (value) {
                  setState(() {
                    _isEmpty = value.isEmpty;
                  });
                },
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromRGBO(106, 162, 142, 1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty ? Colors.red : Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
