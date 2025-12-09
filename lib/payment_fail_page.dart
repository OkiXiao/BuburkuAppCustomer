import 'package:flutter/material.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // ✅ Semua di tengah layar
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
              const Icon(Icons.cancel, color: Colors.red, size: 120),
              const SizedBox(height: 20),
              const Text(
                "Payment Fail",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
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
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
