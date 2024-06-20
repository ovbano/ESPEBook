// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/auth/auth_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationFamilyAuth extends StatefulWidget {
  static const String informationFamilyAuth = 'information_familyauth';
  const InformationFamilyAuth({super.key});

  @override
  State<InformationFamilyAuth> createState() => _InformationFamilyAuthState();
}

class _InformationFamilyAuthState extends State<InformationFamilyAuth> {
  final TextEditingController telefonoController =
      TextEditingController(text: '09');
  bool areFieldsEmpty = true;
  List<String> telefonos = [];
  late SvgPicture image1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    telefonos =
        BlocProvider.of<AuthBloc>(context).state.usuario?.telefonos ?? [];
    telefonoController.addListener(updateFieldsState);

    image1 = SvgPicture.asset(
      "assets/info/numberfamily.svg",
      width: 75,
      height: 75,
      fit: BoxFit.contain,
    );
  }

  @override
  void dispose() {
    telefonoController.removeListener(updateFieldsState);
    telefonoController.dispose();
    super.dispose();
  }

  void updateFieldsState() {
    setState(() {
      areFieldsEmpty = telefonoController.text.trim().isEmpty ||
          !isValidPhoneNumber(telefonoController.text.trim());
    });
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authService = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(106, 162, 142, 1),
                  Color.fromRGBO(2, 79, 49, 1),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Mis contactos de emergencia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: image1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Agrega un listado de número de teéfonos como contactos, para poder interactuar atraves de los grupos.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _TextFieldAddTelefono(
                        telefonoController: telefonoController,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: areFieldsEmpty
                              ? null
                              : () {
                                  if (authService.state.usuario?.telefonos
                                          .contains(
                                              telefonoController.text.trim()) ??
                                      false) {
                                    mostrarAlerta(
                                      context,
                                      'Número ya registrado',
                                      'El número que estás intentando ingresar ya se encuentra registrado.',
                                    );
                                    return;
                                  }

                                  if (authService.state.usuario?.telefono ==
                                      telefonoController.text.trim()) {
                                    mostrarAlerta(
                                      context,
                                      'Número ya registrado',
                                      'No puedes agregar tu propio número de teléfono.',
                                    );
                                    return;
                                  }

                                  authService.addTelefonoFamily(
                                      telefonoController.text.trim());
                                  telefonoController.clear();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Agregar número',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ListContact(
                        authService: authService,
                        telefonos: telefonos,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(2, 79, 49, 1),
            ),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(2, 79, 49, 1),
              ),
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TextFieldAddTelefono extends StatelessWidget {
  const _TextFieldAddTelefono({
    required this.telefonoController,
  });

  final TextEditingController telefonoController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[200],
          ),
          child: Center(
            child: Image.asset(
              "assets/ecuador.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: telefonoController,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              labelStyle: TextStyle(
                color: Color.fromRGBO(106, 162, 142, 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(106, 162, 142, 1),
                ),
              ),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
        )
      ],
    );
  }
}

class _ListContact extends StatelessWidget {
  _ListContact({
    required this.authService,
    required this.telefonos,
  });

  List<String> telefonos;
  final AuthBloc authService;

  @override
  Widget build(BuildContext context) {
    final state = authService.state;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.usuario?.telefonos.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Color.fromRGBO(106, 162, 142, 1),
            ),
            title: Text(
              state.usuario?.telefonos[index] ?? '',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog(
                    context, state.usuario?.telefonos[index] ?? '');
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String telefono) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Eliminación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este número de teléfono?',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(180, 36, 20, 1),
              // color: ,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo sin eliminar
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                authService.deleteTelefonoFamily(telefono);
                Navigator.pop(context); // Cerrar el diálogo después de eliminar
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(2, 79, 49, 1),
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
