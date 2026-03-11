import 'package:flutter/material.dart';
import '../data/global_data.dart';
import '../models/food_item.dart';
import '../models/order.dart';
import 'qr_token_screen.dart';

class FoodScreen extends StatefulWidget {
  final String rollNumber;
  const FoodScreen({super.key, required this.rollNumber});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  Map<String, int> quantity = {};
  Map<String, String> selectedDate = {};

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    for (var food in GlobalData.availableFoods) {
      if (!quantity.containsKey(food.id)) {
        quantity[food.id] = 0;
      }
      if (!selectedDate.containsKey(food.id)) {
        selectedDate[food.id] = food.availableDates.isNotEmpty ? food.availableDates.first : "";
      }
    }
  }

  Widget foodCard(FoodItem food) {
    String keyName = food.id;

    // Default values if keys are somehow missing
    int currentQuantity = quantity[keyName] ?? 0;
    String currentDate = selectedDate[keyName] ?? "";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "PER ₹${food.price}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Image.asset(
                food.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      if (currentQuantity > 0) {
                        quantity[keyName] = currentQuantity - 1;
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "$currentQuantity",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      quantity[keyName] = currentQuantity + 1;
                    });
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: food.availableDates.contains(currentDate) ? currentDate : (food.availableDates.isNotEmpty ? food.availableDates.first : null),
              isExpanded: true,
              items: food.availableDates.map((String date) {
                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(date, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedDate[keyName] = value;
                  }
                });
              },
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (currentQuantity > 0 && currentDate.isNotEmpty) {
                    Order order = Order(
                      rollNumber: widget.rollNumber,
                      foodName: food.name,
                      quantity: currentQuantity,
                      date: currentDate,
                      price: food.price * currentQuantity,
                      timestamp: DateTime.now(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRTokenScreen(order: order),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a quantity and date.")),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart, size: 16),
                label: const Text("Add", style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Re-initialize state in case available foods changed since we were last here
    _initializeState();

    return Scaffold(
      appBar: AppBar(
        title: const Text("MessMate - Book Food"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: GlobalData.availableFoods.isEmpty
          ? const Center(child: Text("No food items available."))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
              ),
              itemCount: GlobalData.availableFoods.length,
              itemBuilder: (context, index) {
                return foodCard(GlobalData.availableFoods[index]);
              },
            ),
    );
  }
}