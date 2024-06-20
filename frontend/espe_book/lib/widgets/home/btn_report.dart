// ignore_for_file: unused_import

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/blocs.dart';
import 'package:espe_book/screens/alerts_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:address_search_field/address_search_field.dart';


class CreateBusquedaScreen extends StatefulWidget {
  const CreateBusquedaScreen({super.key});

  @override
  _CreateBusquedaScreenState createState() => _CreateBusquedaScreenState();
}

class _CreateBusquedaScreenState extends State<CreateBusquedaScreen> {
  GeoMethods geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyB9U5m3zHAP6HfrlD46kLTzCa8yT6reU5Y',
    language: 'en',
    country: 'Ecuador',
  );
  TextEditingController controller = TextEditingController();
  Address? destinationAddress;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textFieldWidth = screenWidth * 0.8;

    return Center(
      child: Container(
        width: textFieldWidth * 0.5,
        child: TextField(
          controller: controller,
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AddressSearchDialog(
              geoMethods: geoMethods,
              controller: controller,
              onDone: (Address address) {
                setState(() {
                  destinationAddress = address;
                });
              },
            ),
          ),
          decoration: InputDecoration(
            hintText: 'Buscar dirección...',
            hintStyle: TextStyle(fontSize: 12), 
            suffixIcon: IconButton(
               icon: Icon(Icons.search, size: 20), // Ajustar el tamaño del icono
              onPressed: () {
                if (destinationAddress != null) {
                  print('Buscar: ${destinationAddress!.reference}');
                }
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          ),
        ),
      ),
    );
  }
}

class BtnReport extends StatelessWidget {
  const BtnReport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const CreateBusquedaScreen(),
                  ),
                  Spacer(),
                  FadeInUp(
                    duration: const Duration(milliseconds: 300),
                    child: const _BtnReport(),
                  ),
                ],
              );
      },
    );
  }
}

class _BtnReport extends StatelessWidget {
  const _BtnReport();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            width: width * 0.78,
            height: 40,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AlertsScreen.routeName);
              },
              icon: Image.asset(
                'assets/alertaIcon.png',
                width: 23,
                height: 23,
              ),
              label: const Text(
                "REPORTAR",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
