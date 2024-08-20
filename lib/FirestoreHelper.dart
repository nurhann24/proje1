import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final CollectionReference itemsCollection =
  FirebaseFirestore.instance.collection('items');
  final CollectionReference transactionsCollection =
  FirebaseFirestore.instance.collection('transactions');

  Future<void> insertItem(Map<String, dynamic> item) async {
    await itemsCollection.add(item);
  }

  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    await transactionsCollection.add(transaction);
  }

  Future<List<Map<String, dynamic>>> getAvailableItems() async {
    QuerySnapshot querySnapshot = await itemsCollection
        .where('status', isEqualTo: 'available')
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'] ?? 'N/A',
        'brand': data['brand'] ?? 'N/A',
        'model': data['model'] ?? 'N/A',
        'shelfNumber': data['shelfNumber'] ?? 'N/A',
        'count': data['count'] ?? 0,
        'arrivalDate': data['arrivalDate'] ?? 'N/A',
        'status': data['status'] ?? 'N/A',
      };
    }).toList();
  }

  Future<void> updateItemStatus(String itemId, String status) async {
    await itemsCollection.doc(itemId).update({'status': status});
  }

}
