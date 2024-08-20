import 'package:flutter/material.dart';
import 'package:proje1/CheckOutForm.dart';
import 'package:proje1/CheckInForm.dart';
import 'package:proje1/NewItemScreen.dart';
import 'package:proje1/item_list.dart';
import 'package:proje1/qr_code_generator.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Management App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.orange,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/resim.jpg'), // Arka plan resmi
            fit: BoxFit.cover, // Resmi kaplama tarzı
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                title: Text('Depo Yönetim Sistemi'),
                centerTitle: true,
                backgroundColor: Colors.transparent, // Şeffaf arka plan
                elevation: 0, // Gölge kaldırma
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _buildListTile(
                      context,
                      title: 'Eşyayı Al',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckOutForm(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      title: 'Eşyayı İade Et',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckInForm(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      title: 'QR Kodu Oluştur',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrCodeGenerator(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      title: 'Kayıtlı Eşyalar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item_list(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      title: 'Yeni Eşya Ekle',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewItemScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.secondary),
        onTap: onTap,
      ),
    );
  }
}
