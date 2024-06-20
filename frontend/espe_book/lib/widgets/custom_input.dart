import 'package:flutter/material.dart';

class CustonInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool obscurePassword;
  final Widget? suffixIcon;

  const CustonInput({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscurePassword = true,
    this.suffixIcon,
  });

  @override
  _CustonInputState createState() => _CustonInputState();
}

class _CustonInputState extends State<CustonInput> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscurePassword;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final inputPadding = screenWidth * 0.05;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: inputPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: widget.textController,
            autocorrect: false,
            maxLength: 50,
            obscureText: widget.isPassword ? _obscurePassword : false,
            keyboardType: widget.keyboardType,
            cursorColor: const Color(0xFF1F5545),
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color: Colors.black,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : widget.suffixIcon,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: const Color(0xFF1F5545),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              hintText: widget.placeholder,
              hintStyle: const TextStyle(color: Colors.grey),
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
