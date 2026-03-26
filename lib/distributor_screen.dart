import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class DistributorScreen extends StatelessWidget {
  const DistributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distributor Panel"),
        backgroundColor: Colors.orange[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Open Scanner"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.orange[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
