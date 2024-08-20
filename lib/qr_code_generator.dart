import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QrCodeGenerator extends StatefulWidget {
  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController shelfController = TextEditingController();

  String _data = '';

  void _updateData() {
    setState(() {
      _data = 'Name: ${nameController.text}, '
          'Brand: ${brandController.text}, '
          'Model: ${modelController.text}, '
          'Shelf: ${shelfController.text}';
    });
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Depolama izni verildi')),
      );
      _saveQrCode();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Depolama izni verilmedi')),
      );
    }
  }

  Future<void> _saveQrCode() async {
    try {
      final qrPainter = QrPainter(
        data: _data,
        version: QrVersions.auto,
        color: Colors.black,
        gapless: false,
        emptyColor: Colors.white,
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/qr_code.png';

      final picData = await qrPainter.toImageData(2048);
      final buffer = picData!.buffer.asUint8List();
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      final result = await GallerySaver.saveImage(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Kodu başarıyla kaydedildi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Kodu kaydedilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kodu Üretici'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Eşya Adı',
              ),
              onChanged: (value) {
                _updateData();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Marka',
              ),
              onChanged: (value) {
                _updateData();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Model',
              ),
              onChanged: (value) {
                _updateData();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: shelfController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Raf Numarası',
              ),
              onChanged: (value) {
                _updateData();
              },
            ),
            const SizedBox(height: 20),
            if (_data.isNotEmpty)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: QrPainter(
                        data: _data,
                        version: QrVersions.auto,
                        color: Colors.black,
                        gapless: false,
                        emptyColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _requestStoragePermission,
                    child: const Text('QR Kodunu İndir'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
