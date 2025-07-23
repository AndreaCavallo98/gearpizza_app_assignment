import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gearpizza/core/storage/token_storage.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';
import 'package:go_router/go_router.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 210,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 15,
                child: ClipPath(
                  clipper: CustomCardClipper(),
                  child: Image.network(
                    "https://gearpizza.revod.services/assets/10205b8c-33ae-4c42-9f77-9f25b811e787?access_token=${TokenStorage.accessToken}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 3,
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/restaurant/${restaurant.id}',
                      extra: restaurant,
                    );
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF101F22).withAlpha(80),
                      ),
                      child: Text(
                        "${restaurant.totalPizzas} tipi di pizze",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          restaurant.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            // 5 stelle fai un ciclo for
            ...List.generate(
              4,
              (index) => Icon(Icons.star, color: Colors.yellow),
            ),
            Icon(Icons.star, color: Colors.grey),
            Spacer(),
            Icon(Icons.location_on_outlined, color: Colors.grey),
            Text("10 km", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 30;
    double curveRadius = 20;
    Path path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - (curveRadius + 60));
    path.quadraticBezierTo(
      size.width,
      size.height - 60,
      size.width - curveRadius,
      size.height - 60,
    );
    path.quadraticBezierTo(
      size.width - 70,
      size.height - 65,
      size.width - 75,
      size.height - curveRadius,
    );
    path.quadraticBezierTo(
      size.width - 75,
      size.height,
      size.width - (75 + curveRadius),
      size.height,
    );
    path.lineTo(radius, size.height);

    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
