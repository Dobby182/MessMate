import 'package:flutter/material.dart';
import '../data/global_data.dart';
import '../models/order.dart';

class OrderValidationScreen extends StatelessWidget {
  final String tokenId;
  final String rollNumber;
  final String foodName;
  final int quantity;
  final String date;
  final int price;

  const OrderValidationScreen({
    super.key,
    required this.tokenId,
    required this.rollNumber,
    required this.foodName,
    required this.quantity,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Validation'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Roll Number:', rollNumber),
                    const Divider(),
                    _buildDetailRow('Food Item:', foodName),
                    const Divider(),
                    _buildDetailRow('Quantity:', quantity.toString()),
                    const Divider(),
                    _buildDetailRow('Date:', date),
                    const Divider(),
                    _buildDetailRow('Price:', '₹$price'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // 🔹 FIX: clean date (gallery scans may add spaces/newline)
                String cleanedDate = date.trim();

                // 🔹 Convert string date → DateTime
                List parts = cleanedDate.split("-");
                DateTime orderDate = DateTime(
                  int.parse(parts[2]), // year
                  int.parse(parts[1]), // month
                  int.parse(parts[0]), // day
                );

                DateTime now = DateTime.now();

                // 🔹 Compare only date (ignore time)
                if (orderDate.year != now.year ||
                    orderDate.month != now.month ||
                    orderDate.day != now.day) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Invalid date')));
                  return;
                }

                // 🔹 Duplicate token check
                if (GlobalData.servedTokens.contains(tokenId)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token already used')),
                  );
                  return;
                }

                // 🔹 Mark token as served
                GlobalData.servedTokens.add(tokenId);

                int index = GlobalData.userOrders.indexWhere(
                  (order) => order.id == tokenId,
                );

                if (index != -1) {
                  Order completedOrder = GlobalData.userOrders.removeAt(index);
                  GlobalData.completedOrders.add(completedOrder);
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Food Served')));

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Serve Food',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
