import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Importa il pacchetto Lottie
import 'package:gearpizza/features/orders/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  // Funzione per ottenere l'animazione Lottie in base allo stato
  String _getLottieAnimation(String status) {
    switch (status) {
      case 'pending':
        return 'assets/animations/pending.json'; // Inserisci il percorso della tua animazione Lottie
      case 'preparing':
        return 'assets/animations/preparing.json'; // Animazione per preparing
      case 'delivered':
        return 'assets/animations/delivered.json'; // Animazione per delivered
      case 'completed':
        return 'assets/animations/completed.json'; // Animazione per completed
      default:
        return 'assets/animations/pending.json'; // Animazione di default
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Lottie per lo stato a destra
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Lottie.asset(
                      _getLottieAnimation(order.status),
                      repeat: order.status == "completed" ? false : true,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Spacer(),
                  Text(order.status, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
