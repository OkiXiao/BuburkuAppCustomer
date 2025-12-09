import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'payment_success_page.dart';
import 'payment_fail_page.dart';

class PaymentQRPage extends StatefulWidget {
  final int totalHarga;

  const PaymentQRPage({Key? key, required this.totalHarga}) : super(key: key);

  @override
  State<PaymentQRPage> createState() => _PaymentQRPageState();
}

class _PaymentQRPageState extends State<PaymentQRPage> {
  String qrData = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    generateNewQR();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      generateNewQR();
    });
  }

  void generateNewQR() {
    setState(() {
      qrData = 'PAY-${Random().nextInt(999999).toString().padLeft(6, '0')}';
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        // ✅ Biar semua elemen di tengah layar
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (pastikan file-nya ada)
              Image.asset(
                'assets/images/bubur.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.bubble_chart,
                  size: 80,
                  color: Colors.brown,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentSuccessPage(),
                    ),
                  );
                },
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Total Yang Harus Dibayarkan",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentFailPage(),
                    ),
                  );
                },
                child: Text(
                  "Rp ${widget.totalHarga}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
