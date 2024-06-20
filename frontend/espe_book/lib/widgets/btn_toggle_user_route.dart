import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({super.key, Key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.02),
      child: Material(
        elevation: 0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: MediaQuery.of(context).size.width * 0.06,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.route, color: Colors.grey[800]),
            iconSize: MediaQuery.of(context).size.width * 0.04,
            onPressed: () {
              mapBloc.add(OpToggleUserRouteEvent());
            },
          ),
        ),
      ),
    );
  }
}
