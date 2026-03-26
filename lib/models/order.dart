class Order {
  final String id;
  final String rollNumber;
  final String foodName;
  final int quantity;
  final String date;
  final int price;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.rollNumber,
    required this.foodName,
    required this.quantity,
    required this.date,
    required this.price,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': rollNumber,
      'foodName': foodName,
      'quantity': quantity,
      'date': date,
      'price': price,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
