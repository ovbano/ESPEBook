import 'package:espe_book/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/auth/auth_bloc.dart';
import 'package:espe_book/global/environment.dart';
import 'package:espe_book/screens/perfil/edit_nombre.dart';
import 'package:espe_book/screens/perfil/edit_telefono.dart';
import 'package:espe_book/screens/perfil/password_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPerfilScreen extends StatefulWidget {
  static const String editPerfilroute = 'editPerfil';
  const EditPerfilScreen({Key? key}) : super(key: key);

  @override
  State<EditPerfilScreen> createState() => _EditPerfilScreenState();
}

class _EditPerfilScreenState extends State<EditPerfilScreen> {
  final picker = ImagePicker();
  File? _imageFile;
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(106, 162, 142, 1),
        automaticallyImplyLeading: false,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!state.usuario!.google) {
                            _seleccionarFoto();
                          }
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : state.usuario!.google
                                  ? NetworkImage(state.usuario!.img!)
                                  : NetworkImage(
                                      '${Environment.apiUrl}/uploads/usuario/usuarios/${state.usuario!.uid}',
                                    ),
                        ),
                      ),
                      if (!state.usuario!.google)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _seleccionarFoto,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(106, 162, 142, 1),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                buildListTile(
                  title: 'Nombres',
                  subtitle: state.usuario!.nombre,
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRoute(EditNombreScreen()));
                  },
                ),
                buildListTile(
                  title: 'Correo',
                  subtitle: state.usuario!.email,
                  onTap: () {
                    // Add functionality for email onTap
                  },
                ),
                buildListTile(
                  title: 'Teléfono',
                  subtitle: state.usuario!.telefono!,
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRoute(EditTelefonoScreen()));
                  },
                ),
                buildListTile(
                  title: 'Contraseña',
                  subtitle: '**********',
                  onTap: () {
                    Navigator.of(context).push(_createRoute(PasswordScreen()));
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Esta información es privada y no será compartida con nadie.',
                    style: TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(106, 162, 142, 1),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Icon(
              Icons.edit,
              color: Color.fromRGBO(106, 162, 142, 1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _seleccionarFoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await authBloc.updateUsuarioImage(imageFile.path);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
