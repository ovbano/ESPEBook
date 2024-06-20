// ignore_for_file: unused_local_variable, unnecessary_null_comparison, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/models/publication.dart';
import 'package:espe_book/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionNews extends StatefulWidget {
  const OptionNews({
    super.key,
    required this.publicaciones,
    required this.state,
    required this.usuarioBloc,
    required this.i,
    required this.likes,
  });

  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;
  final List<String> likes;

  @override
  _OptionNewsState createState() => _OptionNewsState();
}

class _OptionNewsState extends State<OptionNews> {
  bool showReactionsMenu = false; // Estado para mostrar el menú de reacciones
  PublicationBloc publicationBloc = PublicationBloc();
  AuthBloc usuarioBloc = AuthBloc();
  IconData selectedReaction = FontAwesomeIcons
      .solidThumbsUp; // Reacción seleccionada inicialmente como Thumbs Up
  Color? selectedColor = Colors.blue; // Color de la reacción seleccionada

  void _toggleReactionsMenu() {
    setState(() {
      showReactionsMenu = !showReactionsMenu;
    });
  }

  void _selectReaction(IconData reactionIcon, Color color) {
    setState(() {
      selectedReaction = reactionIcon;
      selectedColor = color;
      showReactionsMenu =
          false; // Cerrar el menú de reacciones después de seleccionar una
    });
    _handleReaction(reactionIcon);
  }

  void _handleReaction(IconData reactionIcon) {
    // Aquí puedes manejar la lógica para guardar la reacción en la base de datos
    // y cambiar el icono según la reacción seleccionada
    // Ejemplo: publicationBloc.add(SaveReactionEvent(reactionIcon));
    // Llamar al método de manejo del like
    //_handleLike();
  }

  @override
  void initState() {
    super.initState();
    // Verificar si el usuario actual ya ha dado like en la publicación
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    usuarioBloc = BlocProvider.of<AuthBloc>(context);
  }

  Future<void> _handleLike() async {
    final publicationUid = widget.publicaciones[widget.i].uid!;
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;

    try {
      // Aquí puedes llamar al método para actualizar el like en la base de datos
      publicationBloc.add(PublicacionesUpdateEvent(publicationUid));
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      if (widget.likes.contains(currentUserUid)) {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length - 1,
        );
        widget.likes.remove(currentUserUid);
      } else {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length + 1,
        );
        widget.likes.add(currentUserUid);
        BlocProvider.of<PublicationBloc>(context)
            .add(UpdatePublicationEvent(newPublication));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _handleLike(); // Llamar al método de manejo del like
                    _handleReaction(
                        selectedReaction); // Llamar al método de manejo de la reacción
                  },
                  onLongPress:
                      _toggleReactionsMenu, // Mostrar menú de reacciones
                  child: Row(
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.1,
                        height: mediaQuery.size.height * 0.1,
                        margin:
                            EdgeInsets.only(left: mediaQuery.size.width * 0.05),
                        child: selectedReaction !=
                                null // Verificar si hay un icono seleccionado
                            ? Icon(
                                selectedReaction,
                                color:
                                    selectedColor, // Usar el color seleccionado
                                size: mediaQuery.size.width *
                                    0.035, // Tamaño del icono reducido
                              )
                            : widget.likes.contains(usuarioBloc.state.usuario!
                                    .uid) // Si no hay icono seleccionado, verificar si el usuario dio like
                                ? Icon(
                                    FontAwesomeIcons.solidThumbsUp,
                                    color: const Color(0xFF6165FA),
                                    size: mediaQuery.size.width * 0.035,
                                  ) // Si el usuario dio like, mostrar el icono de like sólido
                                : Container(), // Si no hay icono seleccionado y el usuario no dio like, mostrar un contenedor vacío
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.state.publicaciones[widget.i].likes!.length
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.zero,
                        width: mediaQuery.size.width * 0.1,
                        height: mediaQuery.size.height * 0.1,
                        child: const Icon(
                          FontAwesomeIcons.comment,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.state.publicaciones[widget.i].comentarios == null
                            ? '0'
                            : widget
                                .state.publicaciones[widget.i].countComentarios
                                .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    final publicationBloc =
                        BlocProvider.of<PublicationBloc>(context);
                    publicationBloc.add(
                        PublicacionSelectEvent(widget.publicaciones[widget.i]));
                    Navigator.of(context)
                        .push(_createRoute(widget.publicaciones[widget.i]));
                  },
                ),
              ],
            ),
            // Menú de reacciones
            if (showReactionsMenu)
              Positioned(
                top: mediaQuery.size.height * 0.025,
                left: mediaQuery.size.height * 0.005,
                // right: mediaQuery.size.width * 0.00,
                width: 320,
                child: Container(
                  width: mediaQuery.size.width * 0.9,
                  height: mediaQuery.size.height * 0.05,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidThumbsUp,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction ==
                                FontAwesomeIcons.solidThumbsUp
                            ? Colors
                                .blue // Usar color azul si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidThumbsUp, Colors.blue);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     FontAwesomeIcons.solidThumbsDown,
                      //     size: 12.0, // Tamaño del icono reducido
                      //   ),
                      //   color: selectedReaction ==
                      //           FontAwesomeIcons.solidThumbsDown
                      //       ? Colors
                      //           .red // Usar color rojo si es la reacción seleccionada
                      //       : Colors.grey,
                      //   onPressed: () {
                      //     _selectReaction(
                      //         FontAwesomeIcons.solidThumbsDown, Colors.red);
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidHeart,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidHeart
                            ? Colors
                                .pink // Usar color rosa si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidHeart, Colors.pink);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidLaughBeam,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction ==
                                FontAwesomeIcons.solidLaughBeam
                            ? Colors
                                .amber // Usar color ámbar si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidLaughBeam, Colors.amber);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidSurprise,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction ==
                                FontAwesomeIcons.solidSurprise
                            ? Colors
                                .orange // Usar color naranja si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidSurprise, Colors.orange);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidSadTear,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidSadTear
                            ? Colors
                                .blueGrey // Usar color gris azulado si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidSadTear, Colors.blueGrey);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidAngry,
                          size: 12.0, // Tamaño del icono reducido
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidAngry
                            ? Colors
                                .red // Usar color rojo si es la reacción seleccionada
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(
                              FontAwesomeIcons.solidAngry, Colors.red);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Route _createRoute(Publicacion publicacion) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DetalleScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


/**
 * // ignore_for_file: unused_local_variable, unnecessary_null_comparison, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/models/publication.dart';
import 'package:espe_book/screens/news_detalle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionNews extends StatefulWidget {
  const OptionNews({
    Key? key,
    required this.publicaciones,
    required this.state,
    required this.usuarioBloc,
    required this.i,
    required this.likes,
  }) : super(key: key);

  final List<Publicacion> publicaciones;
  final PublicationState state;
  final AuthBloc usuarioBloc;
  final int i;
  final List<String> likes;

  @override
  _OptionNewsState createState() => _OptionNewsState();
}

class _OptionNewsState extends State<OptionNews> {
  bool showReactionsMenu = false; // Estado para mostrar el menú de reacciones
  late PublicationBloc publicationBloc;
  late AuthBloc usuarioBloc;
  IconData selectedReaction =
      FontAwesomeIcons.solidThumbsUp; // Reacción seleccionada inicialmente como Thumbs Up
  late Color selectedColor; // Color de la reacción seleccionada

  @override
  void initState() {
    super.initState();
    // Inicializar los blocs y obtener el usuario actual
    publicationBloc = BlocProvider.of<PublicationBloc>(context);
    usuarioBloc = BlocProvider.of<AuthBloc>(context);
    selectedColor = Colors.blue; // Establecer el color inicial
  }

  void _toggleReactionsMenu() {
    setState(() {
      showReactionsMenu = !showReactionsMenu;
    });
  }

  void _selectReaction(IconData reactionIcon, Color color) {
    setState(() {
      selectedReaction = reactionIcon;
      selectedColor = color;
      showReactionsMenu = false; // Cerrar el menú de reacciones después de seleccionar una
    });
    _handleReaction(reactionIcon);
  }

  void _handleReaction(IconData reactionIcon) {
    // Aquí puedes manejar la lógica para guardar la reacción en la base de datos
    // y cambiar el icono según la reacción seleccionada
    // Ejemplo: publicationBloc.add(SaveReactionEvent(reactionIcon));
    //_handleLike(); // Llamar al método de manejo del like
  }

  Future<void> _handleLike() async {
    final publicationUid = widget.publicaciones[widget.i].uid!;
    final currentUserUid = widget.usuarioBloc.state.usuario!.uid;

    try {
      // Llamar al método para actualizar el like en la base de datos
      publicationBloc.add(PublicacionesUpdateEvent(publicationUid));
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      if (widget.likes.contains(currentUserUid)) {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length - 1,
        );
        widget.likes.remove(currentUserUid);
      } else {
        final newPublication = widget.publicaciones[widget.i].copyWith(
          countLikes: widget.likes.length + 1,
        );
        widget.likes.add(currentUserUid);
        BlocProvider.of<PublicationBloc>(context)
            .add(UpdatePublicationEvent(newPublication));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _handleLike(); // Llamar al método de manejo del like
                    _handleReaction(selectedReaction); // Llamar al método de manejo de la reacción
                  },
                  onLongPress: _toggleReactionsMenu, // Mostrar menú de reacciones
                  child: Row(
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.1,
                        height: mediaQuery.size.height * 0.1,
                        margin: EdgeInsets.only(left: mediaQuery.size.width * 0.05),
                        child: Icon(
                          selectedReaction,
                          color: selectedColor,
                          size: mediaQuery.size.width * 0.035,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.state.publicaciones[widget.i].likes!.length.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.zero,
                        width: mediaQuery.size.width * 0.1,
                        height: mediaQuery.size.height * 0.1,
                        child: const Icon(
                          FontAwesomeIcons.comment,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.state.publicaciones[widget.i].comentarios == null
                            ? '0'
                            : widget.state.publicaciones[widget.i].countComentarios.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
                    publicationBloc.add(PublicacionSelectEvent(widget.publicaciones[widget.i]));
                    Navigator.of(context).push(_createRoute(widget.publicaciones[widget.i]));
                  },
                ),
              ],
            ),
            // Menú de reacciones
            if (showReactionsMenu)
              Positioned(
                top: mediaQuery.size.height * 0.025,
                left: mediaQuery.size.height * 0.005,
                // right: mediaQuery.size.width * 0.00,
                width: 320,
                child: Container(
                  width: mediaQuery.size.width * 0.9,
                  height: mediaQuery.size.height * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidThumbsUp,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidThumbsUp
                            ? Colors.blue
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidThumbsUp, Colors.blue);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     FontAwesomeIcons.solidThumbsDown,
                      //     size: 12.0,
                      //   ),
                      //   color: selectedReaction == FontAwesomeIcons.solidThumbsDown
                      //       ? Colors.red
                      //       : Colors.grey,
                      //   onPressed: () {
                      //     _selectReaction(FontAwesomeIcons.solidThumbsDown, Colors.red);
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidHeart,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidHeart
                            ? Colors.pink
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidHeart, Colors.pink);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidLaughBeam,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidLaughBeam
                            ? Colors.amber
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidLaughBeam, Colors.amber);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidSurprise,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidSurprise
                            ? Colors.orange
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidSurprise, Colors.orange);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidSadTear,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidSadTear
                            ? Colors.blueGrey
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidSadTear, Colors.blueGrey);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.solidAngry,
                          size: 12.0,
                        ),
                        color: selectedReaction == FontAwesomeIcons.solidAngry
                            ? Colors.red
                            : Colors.grey,
                        onPressed: () {
                          _selectReaction(FontAwesomeIcons.solidAngry, Colors.red);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Route _createRoute(Publicacion publicacion) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const DetalleScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


 * 
 */