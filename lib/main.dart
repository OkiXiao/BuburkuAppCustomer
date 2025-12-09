import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/queue_screen.dart';

// Halaman internal
import 'order_type_page.dart';
import 'menu_page.dart';
import 'cart_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BuburKuApp());
}

class BuburKuApp extends StatelessWidget {
  const BuburKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuburKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // halaman awal
      home: const OrderTypePage(),

      // Routes dengan argument handling
      routes: {
        '/orderTypePage': (context) => const OrderTypePage(),
  '/queuePage': (context) {
    final queueNumber = ModalRoute.of(context)!.settings.arguments as int;
    return QueueScreen(queueNumber: queueNumber);
  },
        '/menu': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final orderType = args?['orderType'] ?? 'Dine In';
          return MenuPage(orderType: orderType);
        },
        '/cart': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final cartItems = args?['cartItems'] as List<dynamic>? ?? [];
          final orderType = args?['orderType'] ?? 'Dine In';
          return CartPage(
            cartItems: List.from(cartItems),
            orderType: orderType,
          );
        },
      },
    );
  }
}
