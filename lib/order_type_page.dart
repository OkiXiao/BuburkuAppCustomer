import 'package:flutter/material.dart';
import 'menu_page.dart';

class OrderTypePage extends StatelessWidget {
  const OrderTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget optionCard({
      required String label,
      required String imagePath,
      required String orderType,
    }) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuPage(orderType: orderType),
            ),
          );
        },
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 3,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 45,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 40),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo utama
            Image.asset(
              'assets/images/bubur.png', // pastikan ini sesuai nama file logo kamu
              height: 160,
              errorBuilder: (c, e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 10),

            // Dua tombol pilihan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                optionCard(
                  label: 'Dine In',
                  imagePath:
                      'assets/images/dine_in.png', // ganti sesuai file kamu
                  orderType: 'Dine In',
                ),
                const SizedBox(width: 24),
                optionCard(
                  label: 'Take Away',
                  imagePath:
                      'assets/images/takeaway.png', // ganti sesuai file kamu
                  orderType: 'Take Away',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
