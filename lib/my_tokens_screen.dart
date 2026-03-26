import 'package:flutter/material.dart';
import '../data/global_data.dart';
import 'qr_token_screen.dart';

class MyTokensScreen extends StatefulWidget {
  const MyTokensScreen({super.key});

  @override
  State<MyTokensScreen> createState() => _MyTokensScreenState();
}

class _MyTokensScreenState extends State<MyTokensScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedOrderIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedOrderIds.clear();
    });
  }

  void _deleteSelected() {
    setState(() {
      GlobalData.userOrders.removeWhere((order) => _selectedOrderIds.contains(order.id));
      _isSelectionMode = false;
      _selectedOrderIds.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Selected orders deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tokens"),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          if (GlobalData.userOrders.isNotEmpty)
            IconButton(
              icon: Icon(_isSelectionMode ? Icons.close : Icons.playlist_remove),
              onPressed: _toggleSelectionMode,
              tooltip: _isSelectionMode ? "Cancel Selection" : "Delete Tokens",
            ),
        ],
      ),
      body: GlobalData.userOrders.isEmpty
          ? const Center(child: Text("No tokens available. Book a token!"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: GlobalData.userOrders.length,
              itemBuilder: (context, index) {
                final order = GlobalData.userOrders[index];
                final isSelected = _selectedOrderIds.contains(order.id);

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: _isSelectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedOrderIds.add(order.id);
                                } else {
                                  _selectedOrderIds.remove(order.id);
                                }
                              });
                            },
                          )
                        : const Icon(Icons.qr_code, color: Colors.blue, size: 30),
                    title: Text(order.foodName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text("Date: ${order.date} | Qty: ${order.quantity}"),
                    trailing: _isSelectionMode ? null : const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
                    onTap: () {
                      if (_isSelectionMode) {
                        setState(() {
                          if (isSelected) {
                            _selectedOrderIds.remove(order.id);
                          } else {
                            _selectedOrderIds.add(order.id);
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRTokenScreen(order: order),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    },
                  ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _isSelectionMode && _selectedOrderIds.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: ElevatedButton.icon(
                onPressed: _deleteSelected,
                icon: const Icon(Icons.delete),
                label: const Text("Delete Selected", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
