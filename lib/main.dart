import 'package:app_one/screens/CaptureScreen.dart';
import 'package:app_one/screens/CredentialListScreen.dart';
import 'package:app_one/screens/ViewDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
  printDatabasePath();
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CredentialListScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/capture') {
          return MaterialPageRoute(
            builder: (context) => CaptureScreen(cameras: cameras),
          );
        } else if (settings.name == '/view_data') {
          if (settings.arguments != null) {
            final Map<String, dynamic> credentialData =
                settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (context) => ViewDataScreen(credentialData: credentialData),
            );
          } else {
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: Text("Error")),
                    body: Center(
                      child: Text(
                        "No se proporcionaron datos de la credencial.",
                      ),
                    ),
                  ),
            );
          }
        }
        return null;
      },
    );
  }
}

Future<void> printDatabasePath() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = join(directory.path, 'ine_data.db');
  print("Ruta de la base de datos: $dbPath");
}
