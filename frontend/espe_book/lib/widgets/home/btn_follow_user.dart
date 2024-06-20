import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Seguir Usuario', // Descripción emergente del botón
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<SearchBloc>(context).add(const ToggloUpdateTypeMapEvent());
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Sombreado más suave
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Icon(
            FontAwesomeIcons.layerGroup, // Ícono original del botón
            color: Colors.grey[800], // Color del icono
            size: MediaQuery.of(context).size.width * 0.04, // Tamaño original del icono
          ),
        ),
      ),
    );
  }
}
