import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  final Map<String, dynamic> credentialData;
  const ViewDataScreen({super.key, required this.credentialData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de Credencial")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Información: \n\n\${credentialData['text']}",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
