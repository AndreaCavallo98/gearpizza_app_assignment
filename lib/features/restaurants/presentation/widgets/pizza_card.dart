import 'package:flutter/material.dart';
import 'package:gearpizza/core/storage/token_storage.dart';
import 'package:gearpizza/features/restaurants/models/pizza.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;
  const PizzaCard({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: [
          Image.network(
            '${pizza.coverImageUrl}?access_token=${TokenStorage.accessToken}',
            width: 100,
            height: 100,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pizza.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  pizza.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),

          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            // padding esterno
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                // Azione
              },
            ),
          ),
        ],
      ),
    );
  }
}
