import 'package:flutter/material.dart';
import 'package:address_search_field/address_search_field.dart';

class CreateBusquedaScreen extends StatefulWidget {
  const CreateBusquedaScreen({super.key});

  @override
  _CreateBusquedaScreenState createState() => _CreateBusquedaScreenState();
}

class _CreateBusquedaScreenState extends State<CreateBusquedaScreen> {
  GeoMethods geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyCcqE0jA7vaGZsHoCQ72gfWw3cYTEJBtCY', 
    language: 'en',
    country: 'Ecuador');
  TextEditingController controller = TextEditingController();
  late Address destinationAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
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
          ),
        ],
      ),
    );
  }
}
