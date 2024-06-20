import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:espe_book/blocs/room/room_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupContenido extends StatelessWidget {
  final String textoTitulo;
  final String textoHint;
  final String textoButton;
  final String? textoInfo;

  const GroupContenido({super.key, 
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    Key,
    required this.textoTitulo,
    required this.textoHint,
    required this.textoButton,
    this.textoInfo,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomController = TextEditingController();
    final chatProvider = BlocProvider.of<RoomBloc>(context, listen: false);
    final blocRoom = BlocProvider.of<RoomBloc>(context);
    final FocusNode focusNode = FocusNode();
    focusNode.requestFocus();

    final bool permitirLetrasYNumeros = textoButton == 'Crear Grupo';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textoTitulo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Colors.black,
            focusNode: focusNode,
            maxLength: 35,
            inputFormatters: permitirLetrasYNumeros
                ? null
                : [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9-]'), // Solo permite dígitos y guion
                    ),
                    _CustomFormatter(),
                  ],
            decoration: InputDecoration(
              hintText: textoHint,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 162, 142, 1)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 162, 142, 1)),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
            controller: nomController,
          ),
          if (textoInfo != null) ...[
            const SizedBox(height: 10),
            Text(
              textoInfo!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.065,
            child: ElevatedButton(
              onPressed: () async {
                if (textoButton == 'Crear Grupo') {
                  chatProvider.add(SalaCreateEvent(nomController.text));
                  focusNode.unfocus();
                  Navigator.pop(context);
                } else {
                  final res = await chatProvider.joinSala(nomController.text);
                  if (!res) {
                    blocRoom.add(CargandoEventFalse());
                    Fluttertoast.showToast(
                      msg: 'No existe el grupo ${nomController.text}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    focusNode.unfocus();
                    Fluttertoast.showToast(
                      msg: 'Te uniste al grupo ${nomController.text}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromRGBO(2, 79, 49, 1),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(2, 79, 49, 1),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(14),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                textoButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 3 && newValue.text.substring(3, 4) != '-') {
      // Agrega un guion después del tercer dígito
      return TextEditingValue(
        text: '${newValue.text.substring(0, 3)}-${newValue.text.substring(3)}',
        selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
      );
    }
    return newValue;
  }
}