import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'order_validation_screen.dart';
import '../data/global_data.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (scanned) return;
    scanned = true;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        try {
          final Map<String, dynamic> data = jsonDecode(code);
          
          final String tokenId = data['timestamp'].toString();
          final String orderDate = data['date'] ?? '';
          
          DateTime now = DateTime.now();
          final String todayDate = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

          if (orderDate != todayDate) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid token date')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) setState(() => scanned = false);
            });
            return;
          }

          if (GlobalData.servedTokens.contains(tokenId)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token already used')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) setState(() => scanned = false);
            });
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderValidationScreen(
                tokenId: tokenId,
                rollNumber: data['rollNumber'] ?? 'Unknown',
                foodName: data['foodName'] ?? 'Unknown',
                quantity: data['quantity'] ?? 1,
                date: orderDate,
                price: data['price'] ?? 0,
              ),
            ),
          ).then((_) {
            // Reset to allow scanning again when we return from validation screen
            setState(() {
              scanned = false;
            });
          });
        } catch (e) {
          // If the QR is not JSON or parsing fails, we ignore or delay reset
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) setState(() => scanned = false);
          });
        }
      } else {
        scanned = false;
      }
    } else {
      scanned = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Token'),
        backgroundColor: Colors.red[400],
      ),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
