import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String text;

  const Logo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          SizedBox(
            width: 210,
            height: 230,
            child: Image.asset(
              'assets/Logo_iniciodesesion.png',
              fit: BoxFit.contain,
            ),
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'ESPE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' Book',
                  style: TextStyle(
                    color: Color(0xFF1F5545),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
