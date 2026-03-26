import 'package:flutter/material.dart';
import 'food_screen.dart';
import 'my_tokens_screen.dart';
import 'data/global_data.dart';

class StudentHomeScreen extends StatefulWidget {
  final String rollNumber;
  const StudentHomeScreen({super.key, required this.rollNumber});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FoodScreen(rollNumber: widget.rollNumber),
      const MyTokensScreen(),
    ];
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text("Completed Orders", style: TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.history),
            children: GlobalData.completedOrders.isEmpty
                ? [const Padding(padding: EdgeInsets.all(16.0), child: Text("No completed orders yet."))]
                : GlobalData.completedOrders.map((order) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green.shade200, width: 1),
                      ),
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                          title: Text(order.foodName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text("Date: ${order.date} | Qty: ${order.quantity}"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Served",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 2 ? _buildProfileTab() : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Book Token"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "My Tokens"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
