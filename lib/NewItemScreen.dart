import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/qr_code_scanner.dart';

class NewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Eşya Ekle'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('QR Kodunu Tara'),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrCodeScanner(isCheckOut: false),
              ),
            );

            if (result != null && result is Map) {
              final qrData = result['data'] ?? '';

              final itemDetails = {
                'name': qrData.split(',')[0].split(': ')[1], // Name
                'brand': qrData.split(',')[1].split(': ')[1], // Brand
                'model': qrData.split(',')[2].split(': ')[1], // Model
                'shelfNumber': qrData.split(',')[3].split(': ')[1], // Shelf Number
                'count': 1, // Yeni eklenen eşyanın adeti
                'arrivalDate': DateTime.now().toIso8601String(),
                'status': 'available',
              };

              try {
                await FirebaseFirestore.instance.collection('items').add(itemDetails);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Eşya başarıyla kaydedildi.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Eşya kaydedilemedi: $e')),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
