import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_state.dart';
import 'package:gearpizza/features/cart/presentation/widgets/card_item_widget.dart';
import 'package:go_router/go_router.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF5F5F5),
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            // (opzionale) gestione notifiche
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Il mio carrello",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final carts = state.items;

                      if (carts.isEmpty) {
                        return const Center(
                          child: Text(
                            "Il carrello è vuoto.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(carts.length, (index) {
                            final cartItem = carts[index];
                            return Container(
                              height: 145,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                top: index == 0 ? 30 : 0,
                                right: 25,
                                left: 25,
                                bottom: 30,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  FadeInUp(
                                    delay: Duration(
                                      milliseconds: (index + 1) * 200,
                                    ),
                                    child: CartItemCard(cartItem: cartItem),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
                if (state.totalItems > 0)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 30,
                    ),
                    child: BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Consegna",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DottedLine(
                                    dashLength: 10,
                                    dashColor: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "€5.99",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text(
                                  "Totale ordine",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DottedLine(
                                    dashLength: 10,
                                    dashColor: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  "€${(state.totalPrice + 5.99).round()}",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            MaterialButton(
                              onPressed: () {
                                context.push("/checkout");
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.black,
                              height: 75,
                              minWidth: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                " Paga \€${(state.totalPrice + 5.99).round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
