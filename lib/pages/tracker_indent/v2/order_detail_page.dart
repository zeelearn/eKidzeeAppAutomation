import 'package:flutter/material.dart';

import '../model/TrackerIndent.dart';

class OrderDetailPage extends StatelessWidget {
  final Indents order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Center(
        child: Hero(
          tag: order.indentId!,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 6,
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(order.indentId!,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(order.indentDescription ?? ''),
                  const SizedBox(height: 12),
                  Text(order.indentStatus ?? ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
