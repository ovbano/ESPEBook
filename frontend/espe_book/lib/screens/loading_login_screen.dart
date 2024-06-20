// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/blocs/notification/notification_bloc.dart';
import 'package:espe_book/blocs/room/room_bloc.dart';
import 'package:espe_book/screens/gps_access_screen.dart';
import 'package:espe_book/screens/home_screen.dart';
import 'package:espe_book/screens/information_family_screen.dart';
import 'package:espe_book/screens/information_screen.dart';
import 'package:espe_book/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingLoginScreen extends StatelessWidget {
  static const String loadingroute = 'loadingLogin';

  const LoadingLoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Fondo transparente para que el Stack lo maneje
      body: Stack(
        children: [
          _buildBackground(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/Logo_iniciodesesion.png',
                    width: 200,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'ESPE',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Book',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xFF1F5545),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightGreen.shade300,
            Colors.lightGreen.shade50,
          ],
        ),
      ),
    );
  }
}

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  _CustomProgressIndicatorState createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }

  Future<void> checkLoginState(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool isFirstLaunch = sharedPreferences.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      navigateToReplacement(context, const LoginScreen());
      await sharedPreferences.setBool('isFirstLaunch', false);
    } else {
      final authService = BlocProvider.of<AuthBloc>(context, listen: false);
      final roomBloc = BlocProvider.of<RoomBloc>(context, listen: false);
      final publicationBloc = BlocProvider.of<PublicationBloc>(context, listen: false);
      final notificationBloc = BlocProvider.of<NotificationBloc>(context, listen: false);
      final result = await authService.init();
      BlocProvider.of<NavigatorBloc>(context).add(const NavigatorIndexEvent(index: 0));
      if (result) {
        if (authService.getUsuario()?.telefono == null || authService.getUsuario()?.telefonos == null) {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();
          if (authService.getUsuario()?.telefono == null) {
            navigateToReplacement(context, const InformationScreen());
          } else if (authService.getUsuario()?.telefonos == null) {
            const GpsAccessScreen();
            navigateToReplacement(context, const InformationFamily());
          } else {
            navigateToReplacement(context, const HomeScreen());
          }
        } else {
          await roomBloc.salasInitEvent();
          await publicationBloc.getAllPublicaciones();
          await notificationBloc.loadNotification();
          navigateToReplacement(context, const HomeScreen());
        }
      } else {
        await authService.logout();
        navigateToReplacement(context, const LoginScreen());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Color(0xFF1F5545), end: Colors.white).animate(_controller);
    checkLoginState(context); // Llamada a la función checkLoginState al inicializar el widget
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 300,
          height: 6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_animation.value!, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      },
    );
  }
}
