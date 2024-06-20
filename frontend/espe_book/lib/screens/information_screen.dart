import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/helpers/page_route.dart';
import 'package:espe_book/screens/information_family_screen.dart';

class InformationScreen extends StatefulWidget {
  static const String information = 'information';
  const InformationScreen({super.key, Key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final TextEditingController telefonoController = TextEditingController(text: '09');
  bool areFieldsEmpty = true;
  NavigatorBloc navigatorBloc = NavigatorBloc();

  @override
  void initState() {
    super.initState();
    telefonoController.addListener(updateFieldsState);
    navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
  }

  @override
  void dispose() {
    telefonoController.removeListener(updateFieldsState);
    telefonoController.dispose();
    super.dispose();
  }

  void updateFieldsState() {
    setState(() {
      areFieldsEmpty = telefonoController.text.trim().isEmpty ||
          !isValidPhoneNumber(telefonoController.text.trim());
    });
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double imageWidth = screenWidth * 0.20;
    final double imageHeight = screenHeight * 0.10;
    final double labelWidth = screenWidth * 0.15;
    final double textFieldWidth = screenWidth * 0.6;
    final double buttonHeight = screenHeight * 0.07;

    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.04,
                horizontal: screenWidth * 0.1,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6AA28E),
                    Color(0xFF024F31),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Text(
                    "Número de Teléfono",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Agrega tu teléfono celular para poder interactuar con otros usuarios a través de las salas.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.782),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/ecuador.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: labelWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // gradient: LinearGradient(
                          //   colors: [Color(0xFF6AA28E), Color(0xFF024F31)],
                          // ),
                        ),
                        
                        child: const Center(
                          child: Text(
                            'EC +593',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: -1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          width: textFieldWidth,
                          height: imageHeight,
                          child: TextField(
                            controller: telefonoController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: 'Teléfono',
                              labelStyle: TextStyle(
                                color: Colors.green.shade700,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade700,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: areFieldsEmpty
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              await authBloc.addTelefono(telefonoController.text.trim());
                              navigatorBloc.add(const NavigatorIsNumberFamilyEvent(isNumberFamily: true));
                              Navigator.of(context).push(CreateRoute.createRoute(const InformationFamily()));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF024F31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
