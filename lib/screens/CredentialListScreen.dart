// ignore: file_names
import 'package:app_one/screens/ViewDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CredentialListScreen extends StatefulWidget {
  @override
  _CredentialListScreenState createState() => _CredentialListScreenState();
}

class _CredentialListScreenState extends State<CredentialListScreen> {
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'ine_data.db'),
    );

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ine_info');

    setState(() {
      _data = maps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Credenciales Registradas")),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("ID: \${_data[index]['id']}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDataScreen(credentialData: _data[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/capture');
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
