// ignore_for_file: unused_import, unused_field

import 'package:espe_book/screens/alerts_screen.dart';
import 'package:espe_book/widgets/home/table_alertas_seguridad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/global/environment.dart';
import 'package:espe_book/models/publication.dart';
import 'package:espe_book/screens/news_detalle.dart';
import 'package:espe_book/widgets/option_publication.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:espe_book/widgets/home/btn_report.dart';

class NewsScreen extends StatefulWidget {
  static const String newsroute = 'news';
  final Function onNewPublication;

  const NewsScreen({super.key, required this.onNewPublication});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late PublicationBloc _publicationBloc;
  bool _isLoading = false;
  double _lastOffset = 0.0; 
  final ScrollController _firstController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _publicationBloc = BlocProvider.of<PublicationBloc>(context);
    _firstController.addListener(() {
      final currentOffset = _firstController.offset;
      if (currentOffset > _lastOffset) {
        setState(() {
          _lastOffset = currentOffset; 
        });
      } else {
        setState(() {
          _lastOffset = currentOffset; 
        });
      }
      if (!_isLoading &&
          _firstController.position.pixels >=
              _firstController.position.maxScrollExtent - 500) {
        _isLoading = true;
        _publicationBloc.getNextPublicaciones().then((_) {
          _isLoading = false;
        });
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<PublicationBloc, PublicationState>(
        builder: (context, state) {
          if (state.firstController == true) {
            _firstController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await _publicationBloc.getAllPublicaciones();
            },
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
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
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                          centerTitle: false,
                          title: const Text(
                            'Mis Direcciones',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(_createRouteToTableAlertsSeguridad());
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Scrollbar(
                              thumbVisibility: true,
                              controller: _firstController,
                              child: _ListNews(
                                publicaciones: state.publicaciones,
                                firstController: _firstController,
                                size: size,
                                publicationBloc: _publicationBloc,
                                usuarioBloc: usuarioBloc,
                                state: state,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListNews extends StatelessWidget {
  const _ListNews({
    required this.publicaciones,
    required ScrollController firstController,
    required this.size,
    required PublicationBloc publicationBloc,
    required this.usuarioBloc,
    required this.state,
  })  : _firstController = firstController,
        _publicationBloc = publicationBloc;

  final List<Publicacion> publicaciones;
  final ScrollController _firstController;
  final Size size;
  final PublicationBloc _publicationBloc;
  final AuthBloc usuarioBloc;
  final PublicationState state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: publicaciones.length,
      controller: _firstController,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromARGB(255, 228, 223, 223),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(
                        int.parse("0xFF${publicaciones[i].color}"),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: publicaciones[i].imgAlerta.endsWith('.png')
                            ? Image.asset(
                                'assets/alertas/${publicaciones[i].imgAlerta}',
                                color: Colors.white,
                              )
                            : SvgPicture.asset(
                                'assets/alertas/${publicaciones[i].imgAlerta}',
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
                            publicaciones[i].titulo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(
                              DateTime.parse(publicaciones[i].createdAt!),
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
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  publicaciones[i].contenido,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (publicaciones[i].imagenes != null &&
                  publicaciones[i].imagenes!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildCachedImage(
                      "${Environment.apiUrl}/uploads/publicaciones/${publicaciones[i].uid!}?imagenIndex=${publicaciones[i].imagenes!.first}",
                      double.infinity,
                      size.height * 0.35,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  _publicationBloc
                      .add(PublicacionSelectEvent(publicaciones[i]));
                  Navigator.of(context)
                      .push(_createRoute(publicaciones[i]));
                },
                child: Text(
                  '${publicaciones[i].ciudad} - ${publicaciones[i].barrio}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
              OptionNews(
                publicaciones: publicaciones,
                state: state,
                usuarioBloc: usuarioBloc,
                i: i,
                likes: publicaciones[i].likes!,
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 1);
      },
    );
  }

  Widget _buildCachedImage(String imageUrl, double width, double height) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          Image.asset('assets/loading.gif'),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      width: width,
      height: height,
      fit: BoxFit.cover,
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

Route _createRouteToTableAlertsSeguridad() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AlertsScreen(),
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