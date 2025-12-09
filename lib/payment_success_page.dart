import 'package:flutter/material.dart';
// ignore: unused_import
import 'menu_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // ✅ Seluruh konten di tengah
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/bubur.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.bubble_chart,
                  size: 80,
                  color: Colors.brown,
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green, size: 120),
              const SizedBox(height: 20),
              const Text(
                "Payment Success",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text("Back To Menu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
