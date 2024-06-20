// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:espe_book/widgets/home/table_alertas_comunidad.dart';
import 'package:espe_book/widgets/home/table_alertas_seguridad.dart';

class AlertsScreen extends StatelessWidget {
  static const String routeName = 'alertas';
  const AlertsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Reportar", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 255, 0, 0), // Personaliza el color de la línea indicadora
            tabs: [
              Tab(
                child: Text("Historias Personales", style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text("Interacciones y Comunidad", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(2, 79, 49, 1),
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const TableAlertsSeguridad(),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const TableAlertsCompunidad(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
