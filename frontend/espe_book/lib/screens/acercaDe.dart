import 'package:flutter/material.dart';

class AcercaDeScreen extends StatelessWidget {
  static const String routeAcercaDe = 'acercaDe';

  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
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
                  'Acerca de',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/Logo_iniciodesesion.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "¡Bienvenido a ESPE Book!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "La nueva plataforma desarrollada por la Universidad De Las Fuerzas Armadas 'ESPE' para facilitar la interacción y el intercambio de conocimientos entre la comunidad educativa. ESPE Book te ofrece un espacio digital dinámico donde puedes conectarte con tus compañeros.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Sobre ESPE Book",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "En ESPE Book, el enfoque principal es fortalecer la comunidad educativa y fomentar un ambiente de aprendizaje colaborativo. Con ESPE Book, puedes acceder a la plataforma que integra herramientas avanzadas de chat y grupos de estudio, garantizando conversaciones seguras y productivas. Únete a ESPE Book y construye un entorno educativo más conectado para todos.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
