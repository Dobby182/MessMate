import 'package:flutter/material.dart';
import 'dart:io';
import '../data/global_data.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';

class FoodScreen extends StatefulWidget {
  final String rollNumber;
  const FoodScreen({super.key, required this.rollNumber});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> with WidgetsBindingObserver {
  Map<String, int> quantity = {};
  Map<String, String> selectedDate = {};

  DateTime parseDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return DateTime.now();
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  void _removePastDates() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    for (var food in GlobalData.availableFoods) {
      food.availableDates.removeWhere((dateStr) {
        DateTime date = parseDate(dateStr);
        DateTime onlyDate = DateTime(date.year, date.month, date.day);
        return onlyDate.isBefore(today);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _removePastDates();
    _initializeState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _removePastDates();
        _initializeState();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removePastDates();
    _initializeState();
  }

  @override
  void didUpdateWidget(covariant FoodScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _removePastDates();
    _initializeState();
  }

  void _initializeState() {
    for (var food in GlobalData.availableFoods) {
      if (!quantity.containsKey(food.id)) {
        quantity[food.id] = 0;
      }
      if (!selectedDate.containsKey(food.id)) {
        selectedDate[food.id] = food.availableDates.isNotEmpty ? food.availableDates.first : "";
      } else {
        if (food.availableDates.isNotEmpty && !food.availableDates.contains(selectedDate[food.id])) {
          selectedDate[food.id] = food.availableDates.first;
        } else if (food.availableDates.isEmpty) {
          selectedDate[food.id] = "";
        }
      }
    }
  }

  Widget foodCard(FoodItem food) {
    String keyName = food.id;

    int currentQuantity = quantity[keyName] ?? 0;
    String currentDate = selectedDate[keyName] ?? "";

    if (!food.availableDates.contains(currentDate) && food.availableDates.isNotEmpty) {
      currentDate = food.availableDates.first;
      selectedDate[keyName] = currentDate;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "PER ₹${food.price}",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: food.imagePath.startsWith('assets/')
                  ? Image.asset(
                      food.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    )
                  : Image.file(
                      File(food.imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, size: 20, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      setState(() {
                        if (currentQuantity > 0) {
                          quantity[keyName] = currentQuantity - 1;
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    "$currentQuantity",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 20, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      setState(() {
                        quantity[keyName] = currentQuantity + 1;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: food.availableDates.contains(currentDate) ? currentDate : null,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        items: food.availableDates.map((String date) {
                          return DropdownMenuItem<String>(
                            value: date,
                            child: Text(
                              date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (currentQuantity > 0 && currentDate.isNotEmpty) ? () {
                  setState(() {
                    int index = GlobalData.cartItems.indexWhere(
                      (item) => item.foodName == food.name && item.date == currentDate
                    );

                    if (index != -1) {
                      final existing = GlobalData.cartItems[index];
                      GlobalData.cartItems[index] = CartItem(
                        foodName: existing.foodName,
                        quantity: existing.quantity + currentQuantity,
                        date: existing.date,
                        price: existing.price + (food.price * currentQuantity),
                      );
                    } else {
                      GlobalData.cartItems.add(CartItem(
                        foodName: food.name,
                        quantity: currentQuantity,
                        date: currentDate,
                        price: food.price * currentQuantity,
                      ));
                    }
                    
                    quantity[keyName] = 0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${food.name} added to cart!"),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } : null,
                icon: const Icon(Icons.shopping_cart, size: 18),
                label: const Text("Add", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Token"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: GlobalData.availableFoods.isEmpty
          ? const Center(child: Text("No food items available."))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.48,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: GlobalData.availableFoods.length,
              itemBuilder: (context, index) {
                return foodCard(GlobalData.availableFoods[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(rollNumber: widget.rollNumber),
            ),
          ).then((_) {
            setState(() {
              _removePastDates();
              _initializeState();
            });
          });
        },
        backgroundColor: Colors.green[700],
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: Text(
          "Go to Cart (${GlobalData.cartItems.length})", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}
