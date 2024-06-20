import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/global/environment.dart';
import 'package:espe_book/models/publication.dart';
import 'package:espe_book/models/usuario.dart';
import 'package:espe_book/screens/screens.dart';

class PerfilDetalleScreen extends StatelessWidget {
  static const String perfilDetalleroute = 'perfilDetalle';

  const PerfilDetalleScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    publicationBloc.getPublicacionesUsuario();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(10),
              //   bottomRight: Radius.circular(30),
              // ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(106, 162, 142, 1),
                  Color.fromRGBO(106, 162, 142, 1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Stack(
              children: [
                // Positioned(
                //   left: 0,
                //   top: 0,
                //   child: IconButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     icon: const Icon(Icons.arrow_back, color: Colors.white),
                //   ),
                // ),
                Center(
                  child: Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   child: IconButton(
                //     onPressed: () {
                //       // Funcionalidad adicional si es necesaria
                //     },
                //     icon: const Icon(Icons.settings, color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserAvatar(authBloc.state.usuario),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authBloc.state.usuario!.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authBloc.state.usuario!.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Miembro desde ${timeago.format(DateTime.parse(authBloc.state.usuario!.createdAt), locale: 'es')}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, EditPerfilScreen.editPerfilroute);
                    },
                    icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                    label: const Text(
                      'Editar perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(106, 162, 142, 1),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shadowColor: Colors.black,
                      side: const BorderSide(
                        color: Color.fromARGB(73, 0, 0, 0),
                        width: 1,
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      minimumSize: const Size(150, 40),
                      alignment: Alignment.center,
                      visualDensity: VisualDensity.standard,
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CustomDivider(color: Colors.black26),
                  const Text(
                    'Mis Publicaciones',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CustomDivider(color: Colors.black26),
                  BlocBuilder<PublicationBloc, PublicationState>(
                    builder: (context, state) {
                      if (state.publicacionesUsuario.isEmpty) {
                        return const Center(
                          child: Text('No hay reportes',
                              style: TextStyle(fontSize: 16)),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.publicacionesUsuario.length,
                            itemBuilder: (context, i) => _buildPublicationCard(
                                context, state.publicacionesUsuario[i]),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(Usuario? usuario) {
    if (usuario!.img == null) {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/no-image.png'),
      );
    } else if (usuario.google) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(usuario.img!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
            '${Environment.apiUrl}/uploads/usuario/usuarios/${usuario.uid}'),
      );
    }
  }

  Widget _buildPublicationCard(BuildContext context, Publicacion publicacion) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PublicationBloc>(context)
            .add(PublicacionSelectEvent(publicacion));
        Navigator.pushNamed(context, DetalleScreen.detalleroute,
            arguments: {'publicacion': publicacion});
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, publicacion),
              const SizedBox(height: 10),
              Text(
                publicacion.contenido,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              if (publicacion.imagenes != null &&
                  publicacion.imagenes!.isNotEmpty)
                _buildImages(context, publicacion),
              const SizedBox(height: 10),
              Text(
                '${publicacion.ciudad} - ${publicacion.barrio}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Publicacion publicacion) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Color(int.parse("0xFF${publicacion.color}")),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: publicacion.imgAlerta.endsWith('.png')
                ? Image.asset(
                    'assets/alertas/${publicacion.imgAlerta}',
                    color: Colors.white,
                  )
                : SvgPicture.asset(
                    'assets/alertas/${publicacion.imgAlerta}',
                    color: Colors.white,
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                publicacion.titulo,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                timeago.format(
                  DateTime.parse(publicacion.createdAt!),
                  locale: 'es',
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImages(BuildContext context, Publicacion publicacion) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
            "${Environment.apiUrl}/uploads/publicaciones/${publicacion.uid!}?imagenIndex=${publicacion.imagenes!.first}",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final Color color;

  const CustomDivider({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1, // Altura del divisor
      margin: const EdgeInsets.symmetric(vertical: 5), // Margen vertical
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(
                0.2), // Color difuminado (puede ajustarse la opacidad)
            color.withOpacity(0.8), // Color principal
            color.withOpacity(
                0.2), // Color difuminado (puede ajustarse la opacidad)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5), // Color de sombra
            blurRadius: 1,
            offset: const Offset(0, 1), // Desplazamiento de la sombra
          ),
        ],
      ),
    );
  }
}
