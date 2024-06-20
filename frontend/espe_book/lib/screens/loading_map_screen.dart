// import 'package:espe_book/screens/perfil/perfil_detalle_screen.dart';
import 'package:espe_book/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/screens/gps_access_screen.dart';
// import 'package:espe_book/screens/map_screen.dart';

class LoadingMapScreen extends StatelessWidget {
  static const String loadingroute = 'loading';

  const LoadingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return !state.isAllGranted
            ? const GpsAccessScreen()
            //que dirija a la pantalla de mapaScren
             : const PerfilDetalleScreen();
            // : const MapScreen();
      },
    );
  }
}
