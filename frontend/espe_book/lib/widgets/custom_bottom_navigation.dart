import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/blocs/notification/notification_bloc.dart';
import 'package:espe_book/blocs/room/room_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key});

  @override
  Widget build(BuildContext context) {
    final navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final authService = BlocProvider.of<AuthBloc>(context, listen: false);
    // ignore: unused_local_variable
    final publicationBloc =
        BlocProvider.of<PublicationBloc>(context, listen: false);
    final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
    final notificationBloc =
        BlocProvider.of<NotificationBloc>(context, listen: false);
    return BlocBuilder<NavigatorBloc, NavigatorStateInit>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(106, 162, 142, 1),
                Color.fromRGBO(2, 79, 49, 1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // ignore: unused_local_variable
                  final iconSize = constraints.maxWidth / 10; // Tamaño del icono en función del ancho del contenedor
                  return BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.white, // Color del icono seleccionado
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent, // Fondo transparente para que se muestre el gradiente
                    elevation: 0.0,
                    unselectedItemColor: Colors.white54,
                    currentIndex: state.index,
                    onTap: (int i) async {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigatorIndexEvent(index: i));

                      mapBloc.add(OnMapMovedEvent());
                      BlocProvider.of<SearchBloc>(context)
                          .add(OnDeactivateManualMarkerEvent());

                      if (i == 0) {
                        await notificationBloc.loadNotification();
                      }
                      if (i == 1) {
                        authService
                            .add(const MarcarPublicacionPendienteFalse(false));
                        // await publicationBloc.getAllPublicaciones();
                      }

                      if (i == 2) {
                        authService.add(const MarcarSalasPendienteFalse());
                        roomBloc.salasInitEvent();
                      }

                      if (i == 3) {
                        navigatorBloc.add(
                            const NavigatorIsPlaceSelectedEvent(isPlaceSelected: false));
                      }
                    },
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(
                          FontAwesomeIcons.user,
                        ),
                        label: 'Mi perfil',
                      ),
                      BottomNavigationBarItem(
                        icon: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, states) {
                            return Stack(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.newspaper,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: states.usuario!.isPublicacionPendiente == true
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 2,
                                            bottom: 2,
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 9,
                                            minHeight: 9,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            );
                          },
                        ),
                        label: 'Noticias',
                      ),
                      BottomNavigationBarItem(
                        icon: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, states) {
                            return Stack(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.users,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: states.usuario!.isSalasPendiente == true
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                            left: 1,
                                            right: 5,
                                            top: 2,
                                            bottom: 2,
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 9,
                                            minHeight: 9,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            );
                          },
                        ),
                        label: 'Grupos',
                      ),
                      // const BottomNavigationBarItem(
                      //   icon: Icon(
                      //     FontAwesomeIcons.mapPin,
                      //   ),
                      //   label: 'Lugares',
                      // ),
                      const BottomNavigationBarItem(
                        icon: Icon(
                          FontAwesomeIcons.bars,
                        ),
                        label: 'Menú',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
