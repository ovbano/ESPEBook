import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/ui/custom_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key, Key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: MediaQuery.of(context).size.width * 0.06,
        child: IconButton(
          icon: Icon(FontAwesomeIcons.locationArrow, color: Colors.grey[800]),
          iconSize: MediaQuery.of(context).size.width * 0.04,
          onPressed: () {
            final userLocation = locationBloc.state.lastKnownLocation;
            if (userLocation == null) {
              final snack = CustomSnackbar(message: 'No hay ubicación');
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return;
            }
            mapBloc.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}
