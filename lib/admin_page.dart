import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  Future<void> updateStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Orderan')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada order.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
              final total = data['totalPrice'] ?? 0;
              final status = data['status'] ?? 'pending';

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Total: Rp$total'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in items)
                        Text('${item['name']} x ${item['quantity']} (Rp${item['price']})'),
                      const SizedBox(height: 8),
                      Text('Status: $status'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => updateStatus(order.id, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'pending', child: Text('Pending')),
                      const PopupMenuItem(value: 'diproses', child: Text('Diproses')),
                      const PopupMenuItem(value: 'selesai', child: Text('Selesai')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
