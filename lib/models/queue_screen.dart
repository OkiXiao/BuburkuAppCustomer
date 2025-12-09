import 'package:flutter/material.dart';

class QueueScreen extends StatelessWidget {
  final int queueNumber;

  const QueueScreen({super.key, required this.queueNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nomor Antrian")),
      body: Center(
        child: Text(
          "Nomor Antrian Anda\n$queueNumber",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
