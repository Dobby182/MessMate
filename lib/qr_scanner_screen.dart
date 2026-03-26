import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'order_validation_screen.dart';
import '../data/global_data.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;
  final MobileScannerController _controller = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    if (scanned) return;
    scanned = true;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      _processBarcode(code);
    } else {
      scanned = false;
    }
  }

  Future<void> _scanFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final BarcodeCapture? capture = await _controller.analyzeImage(image.path);
      if (capture != null && capture.barcodes.isNotEmpty) {
        if (!scanned) {
          scanned = true;
          _processBarcode(capture.barcodes.first.rawValue);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No QR code found in the image.')),
          );
        }
      }
    }
  }

  void _processBarcode(String? code) {
    if (code != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(code);
        
        final String tokenId = data['id']?.toString() ?? data['timestamp'].toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Token'),
        backgroundColor: Colors.red[400],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _scanFromGallery,
                icon: const Icon(Icons.image),
                label: const Text("Scan from Gallery"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
