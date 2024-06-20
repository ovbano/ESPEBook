import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/views/map_view.dart';
import 'package:espe_book/widgets/home/btn_follow_user.dart';
import 'package:espe_book/widgets/home/btn_report.dart';
import 'package:espe_book/widgets/btn_toggle_user_route.dart';
import 'package:espe_book/widgets/home/btn_sos.dart';
import 'package:espe_book/widgets/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const String routemap = 'map_screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc localtionBloc;
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    localtionBloc = BlocProvider.of<LocationBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    localtionBloc.startFollowingUser();
  }

  @override
  void dispose() {
    localtionBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocaltionState>(
        builder: (context, localtionState) {
          if (localtionState.lastKnownLocation == null) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: Text("No se ha encontrado la ubicación"),
              ),
            );
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);

              if (!mapState.showRoutePreview) {
                polylines.removeWhere((key, value) => key == 'myRoute');
              }

              return ScaffoldMessenger(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: localtionState.lastKnownLocation!,
                      polylines: polylines.values.toSet(),
                      markers: mapState.markers.values.toSet(),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.12,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BtnFollowUser(),
                          BtnToggleUserRoute(),
                          BtnCurrentLocation(),
                        ],
                      ),
                    ),
                    const BtnSOS(),
                    const BtnReport(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
