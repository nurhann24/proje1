class Item {
  final int id;
  final String name;
  final String arrivalDate;
  final String qrData;
  final String status;
  final String brand;    // Marka bilgisi
  final String model;    // Model bilgisi
  final String shelfNumber; // Raf numarası
  final int count;       // Eşya adedi

  Item({
    required this.id,
    required this.name,
    required this.arrivalDate,
    required this.qrData,
    required this.status,
    required this.brand,
    required this.model,
    required this.shelfNumber,
    required this.count,
  });

  // Map'ten Item'a dönüştürme
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      arrivalDate: map['arrivalDate'],
      qrData: map['qrData'],
      status: map['status'],
      brand: map['brand'],
      model: map['model'],
      shelfNumber: map['shelfNumber'],
      count: map['count'],
    );
  }

  // Item'dan Map'e dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'arrivalDate': arrivalDate,
      'qrData': qrData,
      'status': status,
      'brand': brand,
      'model': model,
      'shelfNumber': shelfNumber,
      'count': count,
    };
  }
}
