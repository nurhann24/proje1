import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proje1/qr_code_scanner.dart';

class CheckOutForm extends StatefulWidget {
  @override
  _CheckOutFormState createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _departmentController = TextEditingController();

  Future<void> _scanQRCode() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeScanner(isCheckOut: true),
        ),
      );

      if (result != null && result is Map) {
        final qrData = result['data'] ?? '';
        final itemDetails = _parseQRCodeData(qrData);

        if (itemDetails == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('QR kodu geçersiz.')),
          );
          return;
        }

        final name = itemDetails['name'];
        final brand = itemDetails['brand'];
        final model = itemDetails['model'];
        final shelfNumber = itemDetails['shelfNumber'];

        try {
          final firestore = FirebaseFirestore.instance;

          // Firestore'dan uygun eşya belgelerini alma
          final querySnapshot = await firestore.collection('items')
              .where('name', isEqualTo: name)
              .where('brand', isEqualTo: brand)
              .where('model', isEqualTo: model)
              .where('shelfNumber', isEqualTo: shelfNumber)
              .where('status', isEqualTo: 'available')
              .limit(1) // İlk bulduğunu al
              .get();

          if (querySnapshot.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Eşya veritabanında bulunmamaktadır.')),
            );
            return;
          }

          final doc = querySnapshot.docs.first;
          final itemId = doc.id;

          final employeeData = {
            'employeeId': _employeeIdController.text,
            'name': _nameController.text,
            'surname': _surnameController.text,
            'department': _departmentController.text,
            'itemId': itemId,
            'checkOutDate': DateTime.now().toIso8601String(),
          };

          // Eşyayı busy durumuna getirme
          await firestore.collection('items').doc(itemId).update({
            'status': 'busy',
            'count': FieldValue.increment(-1), // Miktarı 1 azaltın
          });

          // İşlem kaydını ekleme
          await firestore.collection('transactions').add(employeeData);

          // Başarıyla tamamlandığında Snackbar ile bilgi ver
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Eşya başarıyla alındı.')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Eşya alınamadı: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR kodu taranamadı.')),
        );
      }
    }
  }

  Map<String, dynamic>? _parseQRCodeData(String qrData) {
    final data = qrData.split(',');
    final Map<String, dynamic> itemDetails = {};

    for (var item in data) {
      final keyValue = item.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        final value = keyValue[1].trim();

        switch (key) {
          case 'Name':
            itemDetails['name'] = value;
            break;
          case 'Brand':
            itemDetails['brand'] = value;
            break;
          case 'Model':
            itemDetails['model'] = value;
            break;
          case 'Shelf':
            itemDetails['shelfNumber'] = value;
            break;
        }
      }
    }

    return itemDetails.isNotEmpty ? itemDetails : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eşya Çıkış Formu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: 'Sicil Numarası'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen sicil numaranızı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen isminizi giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Soyisim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyisminizi giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'Departman'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen departmanınızı giriniz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _scanQRCode,
                child: Text('QR Kodunu Tara ve Eşyayı Al'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
