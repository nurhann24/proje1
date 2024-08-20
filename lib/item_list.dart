import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class item_list extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<item_list> {
  late Future<List<Map<String, dynamic>>> _items;

  @override
  void initState() {
    super.initState();
    _items = _fetchItemsFromFirestore();
  }

  Future<List<Map<String, dynamic>>> _fetchItemsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('status', isEqualTo: 'available')
          .get();

      final groupedItems = <String, Map<String, dynamic>>{};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final key = '${data['name']}_${data['brand']}_${data['model']}_${data['shelfNumber']}';

        if (!groupedItems.containsKey(key)) {
          groupedItems[key] = {
            'name': data['name'],
            'brand': data['brand'],
            'model': data['model'],
            'shelfNumber': data['shelfNumber'],
            'count': 0,
          };
        }

        groupedItems[key]!['count'] = (groupedItems[key]!['count'] as int) + (data['count'] ?? 0);
      }

      return groupedItems.values.toList();
    } catch (e) {
      throw Exception('Veri getirme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıtlı Eşyalar'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Kayıtlı eşya bulunmamaktadır.'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    'Eşya: ${item['name']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text('Marka: ${item['brand']}'),
                      Text('Model: ${item['model']}'),
                      Text('Raf Numarası: ${item['shelfNumber']}'),
                      Text('Depodaki Miktar: ${item['count']}'),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
