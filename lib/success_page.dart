import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Başarılı İşlem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 16),
            Text(
              'İşlem Başarıyla Tamamlandı!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
