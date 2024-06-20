// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:espe_book/models/reporte.dart';

class TableAlertsSeguridad extends StatelessWidget {
  const TableAlertsSeguridad({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mainAxisSpacing = screenWidth > 600 ? 16.0 : 80.0;

    return Table(
      defaultColumnWidth: FixedColumnWidth((screenWidth - 0.1 * mainAxisSpacing) / 3),
      children: [
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Logro Personal",
                      icon: "robo-a-casa.svg",
                      color: "58b368")),
              child: PhysicalModelCircleContainer(
                icon: "robo-a-casa.svg",
                text: "Logro Personal",
                color: const Color(0xFF58b368),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Anuncio de Compromiso",
                      icon: "robo-a-persona.svg",
                      color: "2C3E50")),
              child: PhysicalModelCircleContainer(
                icon: "robo-a-persona.svg",
                text: "Anuncio de Compromiso",
                color: const Color(0xFF2C3E50),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Graduación",
                      icon: "robo-de-vehiculo.svg",
                      color: "9C27B0")),
              child: PhysicalModelCircleContainer(
                icon: "robo-de-vehiculo.svg",
                text: "Graduación",
                color: const Color(0xFF9C27B0),
                screenWidth: screenWidth,
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(
              height: 100, // Ajusta el espacio vertical entre las filas
            ),
            SizedBox(
              height: 100, // Ajusta el espacio vertical entre las filas
            ),
            SizedBox(
              height: 100, // Ajusta el espacio vertical entre las filas
            ),
          ],
        ),
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Anuncio de Boda",
                      icon: "accidente.svg",
                      color: "3498DB")),
              child: PhysicalModelCircleContainer(
                icon: "accidente.svg",
                text: "Anuncio de Boda",
                color: const Color(0xFF3498DB),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Nuevo Trabajo",
                      icon: "emergencia-de-ambulancia.svg",
                      color: "E74C3C")),
              child: PhysicalModelCircleContainer(
                icon: "emergencia-de-ambulancia.svg",
                text: "Nuevo Trabajo",
                color: const Color(0xFFE74C3C),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Viaje",
                      icon: "emergencia-de-bomberos.svg",
                      color: "FFBC3B")),
              child: PhysicalModelCircleContainer(
                icon: "emergencia-de-bomberos.svg",
                text: "Viaje",
                color: const Color(0xFFFFBC3B),
                screenWidth: screenWidth,
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            SizedBox(
              height: 75, // Ajusta el espacio vertical entre las filas
            ),
            SizedBox(
              height: 75, // Ajusta el espacio vertical entre las filas
            ),
            SizedBox(
              height: 75, // Ajusta el espacio vertical entre las filas
            ),
          ],
        ),
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Nuevo Hobby",
                      icon: "drogas.svg",
                      color: "E67F22")),
              child: PhysicalModelCircleContainer(
                icon: "drogas.svg",
                text: "Nuevo Hobby",
                color: const Color(0xFFE67F22),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Familia",
                      icon: "actividad-sospechosa.svg",
                      color: "2980B9")),
              child: PhysicalModelCircleContainer(
                icon: "actividad-sospechosa.svg",
                text: "Familia",
                color: const Color(0xFF2980B9),
                screenWidth: screenWidth,
              ),
            ),
            //agrega un espacio vacio
            const TableCell(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}

class PhysicalModelCircleContainer extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  final double screenWidth;

  const PhysicalModelCircleContainer({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double itemWidth = screenWidth > 600 ? 100 : 85;
    final double itemHeight = itemWidth + 80; // Ajusta la altura del contenedor según el tamaño de la imagen y el texto

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          PhysicalModel(
            elevation: 4,
            shape: BoxShape.circle,
            color: color,
            child: Container(
              alignment: Alignment.center,
              width: itemWidth - 10,
              height: itemWidth - 10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/alertas/$icon",
                fit: BoxFit.cover,
                width: itemWidth * 0.4,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
