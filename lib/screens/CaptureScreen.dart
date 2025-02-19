// ignore: file_names
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CaptureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CaptureScreen({super.key, required this.cameras});

  @override
  // ignore: library_private_types_in_public_api
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController _controller;
  bool isInitialized = false;
  String extractedText = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) return;
    setState(() => isInitialized = true);
  }

  Future<void> _captureAndAnalyze() async {
    if (!_controller.value.isInitialized) return;
    final image = await _controller.takePicture();
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      extractedText = recognizedText.text;
    });

    textRecognizer.close();
    _saveToDatabase(extractedText);
  }

  Future<void> _saveToDatabase(String text) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'ine_data.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ine_info(id INTEGER PRIMARY KEY, text TEXT)",
        );
      },
      version: 1,
    );

    final db = await database;
    await db.insert('ine_info', {
      'text': text,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Captura INE")),
      body: Center(
        child: Column(
          children: [
            isInitialized
                ? Expanded(child: CameraPreview(_controller))
                : Center(child: CircularProgressIndicator()),
            ElevatedButton(
              onPressed: _captureAndAnalyze,
              child: Text("Capturar y Analizar"),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  extractedText.isNotEmpty
                      ? "Texto Extraído:\n\n$extractedText"
                      : "No hay texto capturado",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
