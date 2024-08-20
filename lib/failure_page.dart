import 'package:flutter/material.dart';

class FailurePage extends StatelessWidget {
  final String errorMessage;

  FailurePage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hata'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 16),
            Text(
              'Bir hata oluştu!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
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
