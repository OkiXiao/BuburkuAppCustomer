import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'models/cart_item.dart';
import 'models/cart_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final String orderType;

  const CartPage({super.key, required this.cartItems, required this.orderType});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  int? _queueNumber;

  String serverUrl = "https://margaric-nonfeelingly-herman.ngrok-free.dev";  // ⬅ ganti nanti

  double get totalPrice =>
      widget.cartItems.fold(0, (sum, item) => sum + (item.menuItem.price * item.quantity));

  Future<void> _submitOrder() async {
    if (widget.cartItems.isEmpty) return;
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.orderType == "Take Away") {
        _queueNumber = await _generateQueueNumber();
      }

      List<Map<String, dynamic>> items = widget.cartItems.map((cartItem) {
        return {
          'name': cartItem.menuItem.name,
          'price': cartItem.menuItem.price,
          'quantity': cartItem.quantity,
        };
      }).toList();

      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'items': items,
        'totalPrice': totalPrice,
        'orderType': widget.orderType,
        'customerName': _nameController.text,
      };

      if (widget.orderType == "Dine In") {
        orderData['tableNumber'] = _tableController.text;
      } else {
        orderData['queueNumber'] = _queueNumber;
      }

      // POST ke backend
      final redirectUrl = await _createMidtransTransaction(orderData);

      if (redirectUrl != null) {
        await launchUrl(
          Uri.parse(redirectUrl),
          mode: LaunchMode.externalApplication,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan selesaikan pembayaran di Midtrans.'),
          ),
        );

        setState(() {
          CartManager.cartItems.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
  widget.orderType == "Dine In" ? '/orderTypePage' : '/queuePage',
  (route) => false,
  arguments: _queueNumber,
);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memproses pesanan: $e')));
    }
  }

  Future<String?> _createMidtransTransaction(Map<String, dynamic> orderData) async {
    try {
      final uri = Uri.parse("$serverUrl/create-transaction");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'items': orderData['items'],
          'totalPrice': orderData['totalPrice'].toInt(),
          'orderType': orderData['orderType'],
          'customerName': orderData['customerName'],
          'tableNumber': orderData['tableNumber'] ?? null,
          'queueNumber': orderData['queueNumber'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['redirect_url'];
      } else {
        throw Exception("Gagal membuat transaksi Midtrans: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error pembayaran: $e")));
      return null;
    }
  }

  Future<int> _generateQueueNumber() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('orderType', isEqualTo: 'Take Away')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return 1;

    final lastQueue = snapshot.docs.first.data()['queueNumber'] ?? 0;
    return (lastQueue as int) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Nama'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Nama wajib diisi'
                              : null,
                        ),
                        if (widget.orderType == "Dine In")
                          TextFormField(
                            controller: _tableController,
                            decoration:
                                const InputDecoration(labelText: 'Nomor Meja'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Nomor meja wajib diisi'
                                : null,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Image.network(
                            item.menuItem.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.menuItem.name),
                          subtitle: Text('Rp ${item.menuItem.price}'),
                          trailing: SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        CartManager.cartItems.removeAt(index);
                                      }
                                    });
                                  },
                                ),
                                Text('${item.quantity}',
                                    style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Total: Rp $totalPrice',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Bayar Sekarang'),
                  ),
                ],
              ),
            ),
    );
  }
}
