import 'package:flutter/material.dart';
import '../data/global_data.dart';
import '../models/order.dart';

class CartScreen extends StatefulWidget {
  final String rollNumber;
  const CartScreen({super.key, required this.rollNumber});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _buyItems() {
    if (GlobalData.cartItems.isEmpty) return;

    for (var i = 0; i < GlobalData.cartItems.length; i++) {
      var item = GlobalData.cartItems[i];
      GlobalData.userOrders.add(
        Order(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          rollNumber: widget.rollNumber,
          foodName: item.foodName,
          quantity: item.quantity,
          date: item.date,
          price: item.price,
          timestamp: DateTime.now(),
        ),
      );
    }
    GlobalData.cartItems.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = GlobalData.cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.green,
      ),
      body: GlobalData.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: GlobalData.cartItems.length,
              itemBuilder: (context, index) {
                final item = GlobalData.cartItems[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Date: ${item.date} | Qty: ${item.quantity}"),
                    trailing: Text("₹${item.price}", style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
      bottomNavigationBar: GlobalData.cartItems.isEmpty ? null : Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: ₹$totalPrice", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _buyItems();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("Buy", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
