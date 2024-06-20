import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String text;
  final String text2;

  const Labels({
    super.key,
    required this.ruta,
    required this.text,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: screenWidth * 0.5,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.transparent,
              ),
            ),
            child: Text(
              text2,
              style: TextStyle(
                color: const Color.fromARGB(255, 57, 57, 58),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
