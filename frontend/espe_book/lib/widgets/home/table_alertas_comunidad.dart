// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:espe_book/models/reporte.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TableAlertsCompunidad extends StatelessWidget {
  const TableAlertsCompunidad({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mainAxisSpacing = screenWidth > 600 ? 16.0 : 80.0;

    // Variables de colores como cadenas
    const String greenColor = "0xFF8EB582"; // Green
    const String pinkColor = "0xFFff2e74"; // Pink
    const String purpleColor = "0xFF7f66ff"; // Purple
    const String blueColor = "0xFF43abcd"; // Blue

    return Table(
      defaultColumnWidth: FixedColumnWidth((screenWidth - 0.1 * mainAxisSpacing) / 3),
      children: [
        TableRow(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación sobre Problemas de Agua",
                      icon: "problemas-alcantarillado.svg",
                      color: "8EB582")),
              child: PhysicalModelCircleContainer(
                icon: "problemas-alcantarillado.svg",
                text: "Publicación sobre Problemas de Agua",
                color: Color(int.parse(greenColor)),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación sobre Problemas de Basura",
                      icon: "problemas-de-basura.svg",
                      color: "ff2e74")),
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-basura.svg",
                text: "Publicación sobre Problemas de Basura",
                color: Color(int.parse(pinkColor)),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación sobre Problemas de Energía",
                      icon: "problemas-de-energia.svg",
                      color: "7f66ff")),
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-energia.svg",
                text: "Publicación sobre Problemas de Energía",
                color: Color(int.parse(purpleColor)),
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
                      tipo: "Publicación sobre Problemas de Telecomunicaciones",
                      icon: "problemas-de-telecomunicaciones.svg",
                      color: "43abcd")),
              child: PhysicalModelCircleContainer(
                icon: "problemas-de-telecomunicaciones.svg",
                text: "Publicación sobre Problemas de Telecomunicaciones",
                color: Color(int.parse(blueColor)),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación sobre Problemas de Transporte Público",
                      icon: "problems-de-transporte-publico.svg",
                      color: "414073")),
              child: PhysicalModelCircleContainer(
                icon: "problems-de-transporte-publico.svg",
                text: "Publicación sobre Problemas de Transporte Público",
                color: const Color(0xFF414073),
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación de Buena Acción",
                      icon: "corazon.png",
                      color: "eea15f",
                      isSvg: false)),
              child: PhysicalModelCircleContainer(
                icon: "corazon.png",
                text: "Publicación de Buena Acción",
                color: const Color(0xFFeea15f),
                isSvg: false,
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
                      tipo: "Aviso Comunitario",
                      icon: "comunicar.png",
                      color: "ff2e74",
                      isSvg: false)),
              child: PhysicalModelCircleContainer(
                icon: "comunicar.png",
                text: "Aviso Comunitario",
                color: const Color(0xFFff2e74),
                isSvg: false,
                screenWidth: screenWidth,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pushNamed(context, 'reporte',
                  arguments: Reporte(
                      tipo: "Publicación de Mascota Perdida",
                      icon: "mascotas.png",
                      color: "FC9032",
                      isSvg: false)),
              child: PhysicalModelCircleContainer(
                icon: "mascotas.png",
                text: "Publicación de Mascota Perdida",
                color: const Color(0xFFFC9032),
                isSvg: false,
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
  final bool isSvg;
  final double screenWidth;

  const PhysicalModelCircleContainer({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.screenWidth,
    this.isSvg = true,
  });

  @override
  Widget build(BuildContext context) {
    final double itemWidth = screenWidth > 600 ? 100 : 80;
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
              // margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                shape: BoxShape.circle,
              ),
              child: isSvg
                  ? SvgPicture.asset(
                      "assets/alertas/$icon",
                      fit: BoxFit.cover,
                      width: itemWidth * 0.4,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    )
                  : Image.asset(
                      "assets/alertas/$icon",
                      fit: BoxFit.cover,
                      width: itemWidth * 0.45,
                      color: Colors.white,
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
