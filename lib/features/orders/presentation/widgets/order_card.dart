import 'package:flutter/material.dart';
import 'package:gearpizza/features/orders/models/order.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  // Funzione per ottenere il colore della chip in base allo stato
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange; // Arancione per pending
      case 'preparing':
        return Colors.yellow; // Giallo per preparing
      case 'delivered':
        return Colors.green; // Verde per delivered
      case 'completed':
        return Colors.blue; // Blu per completed
      default:
        return Colors.grey; // Grigio di default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Dettagli ordine
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo Ordine
                  Text(
                    'Ordine #${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Indirizzo
                  Text('Indirizzo:', style: const TextStyle(fontSize: 14)),
                  Text(
                    order.address,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Numero pizze
                  Text(
                    'N° Pizze: ${order.pizzas.length}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            // Chip per lo stato a destra
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Chip(
                padding: EdgeInsets.all(1),
                label: Text(
                  order.status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getStatusColor(order.status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
