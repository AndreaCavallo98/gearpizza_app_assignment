import 'dart:math';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/core/di/injection.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/core/storage/token_storage.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_state.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/allergens_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/pizzas_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/pizzas_state.dart';
import 'package:gearpizza/features/restaurants/models/pizza.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';
import 'package:gearpizza/features/restaurants/presentation/widgets/allergen_bottom_sheet.dart';
import 'package:gearpizza/features/restaurants/presentation/widgets/pizza_card.dart';
import 'package:go_router/go_router.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool showHiddenWidget = true;
  List<int> selectedAllergensForFilter = [];

  @override
  void initState() {
    super.initState();
    context.read<PizzasCubit>().fetchPizzas(widget.restaurant.id, []);
    _scrollController.addListener(() {
      setState(() {
        showHiddenWidget = _scrollController.offset <= 50;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    //'https://gearpizza.revod.services/assets/10205b8c-33ae-4c42-9f77-9f25b811e787?access_token=${TokenStorage.accessToken}',
                    "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/a5/9a/e0/getlstd-property-photo.jpg?w=500&h=-1&s=1",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 53,
                  left: 20,
                  child: Container(
                    width: 51,
                    height: 51,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withAlpha(100),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),

                // ⚙️ Allergeni + 🛒 Carrello
                Positioned(
                  top: 53,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 51,
                        height: 51,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.no_food, color: Colors.black),
                          onPressed: () async {
                            final result =
                                await showModalBottomSheet<List<int>>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => BlocProvider(
                                    create: (_) => AllergensCubit(
                                      sl<GearPizzaDirectusApiService>(),
                                    ),
                                    child: AllergenBottomSheet(
                                      initialSelectedIds:
                                          selectedAllergensForFilter,
                                    ),
                                  ),
                                );

                            if (result != null) {
                              selectedAllergensForFilter = result;
                              print(
                                "selectedAllergensForFilter: " +
                                    selectedAllergensForFilter.toString(),
                              );
                              context.read<PizzasCubit>().fetchPizzas(
                                widget.restaurant.id,
                                selectedAllergensForFilter,
                              );
                            }
                          },
                        ),
                      ),
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Container(
                                width: 51,
                                height: 51,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => context.push('/cart'),
                                ),
                              ),
                              if (state.totalItems > 0)
                                Positioned(
                                  right: -5,
                                  top: -8,
                                  child: GestureDetector(
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
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  bottom: showHiddenWidget ? 10 : 17,
                  left: showHiddenWidget ? 20 : 100,
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
                          "${widget.restaurant.totalPizzas} tipi di pizze",
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
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.restaurant.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      // 5 stelle fai un ciclo for
                      ...List.generate(
                        4,
                        (index) => Icon(Icons.star, color: Colors.yellow),
                      ),
                      Icon(Icons.star, color: Colors.grey),
                      Spacer(),
                      Icon(Icons.delivery_dining_outlined, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "20 min",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),

                      Icon(Icons.location_on_outlined, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "10 km",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<PizzasCubit, PizzasState>(
            listener: (context, state) {
              if (state is PizzasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PizzasLoading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is PizzasLoaded) {
                final pizzas = state.pizzas;
                if (pizzas.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text("Nessuna pizza disponibile.")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FadeInUp(
                      delay: Duration(milliseconds: 200 + index * 300),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutExpo,
                      child: PizzaCard(pizza: pizzas[index]),
                    ),

                    childCount: pizzas.length,
                  ),
                );
              } else {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
    );
  }
}
