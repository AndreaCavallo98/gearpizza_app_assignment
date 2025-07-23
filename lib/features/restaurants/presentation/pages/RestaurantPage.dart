import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_state.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_state.dart';
import 'package:gearpizza/features/restaurants/presentation/widgets/restaurant_card.dart';
import 'package:go_router/go_router.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key, required this.title});
  final String title;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 👉 Header NON scrollabile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "La tua posizione",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Via Centallo 121",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/cart'),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black45,
                                size: 25,
                              ),
                            ),
                          ),
                          if (state.totalItems > 0)
                            Positioned(
                              right: -5,
                              top: -1,
                              child: Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Color(0xfff95f60),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  state.totalItems.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Trova le migliori pizzerie!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -.4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👉 Scrollabile solo la lista delle RestaurantCard
            Expanded(
              child: BlocConsumer<RestaurantsCubit, RestaurantsState>(
                listener: (context, state) {
                  if (state is RestaurantsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  print("🌀 BlocConsumer state: $state");
                  if (state is RestaurantsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }

                  if (state is RestaurantsLoaded) {
                    final restaurants = state.restaurants;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RestaurantCard(restaurant: restaurants[index]),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
