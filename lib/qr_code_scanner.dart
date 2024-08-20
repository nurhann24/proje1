import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class QrCodeScanner extends StatefulWidget {
  final bool isCheckOut;

  QrCodeScanner({required this.isCheckOut});

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  @override
  void reassemble() {
    super.reassemble();
    if (qrController != null) {
      if (Platform.isAndroid) {
        qrController!.pauseCamera();
      } else if (Platform.isIOS) {
        qrController!.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Kodu Tarayıcı'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      final qrData = scanData.code;
      print('QR Code Data: $qrData');
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context, {'data': qrData, 'isCheckOut': widget.isCheckOut});
      }
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
