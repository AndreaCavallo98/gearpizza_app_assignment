import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/core/di/injection.dart';
import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:gearpizza/core/widgets/bottom_nav_with_animated_icons.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/customer_form_cubit.dart';
import 'package:gearpizza/features/cart/presentation/pages/CartPage.dart';
import 'package:gearpizza/features/cart/presentation/pages/CheckOutPage.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/pizzas_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_cubit.dart';
import 'package:gearpizza/features/restaurants/models/restaurant.dart';
import 'package:gearpizza/features/restaurants/presentation/pages/OrdersPage.dart';
import 'package:gearpizza/features/restaurants/presentation/pages/RestaurantDetailPage.dart';
import 'package:gearpizza/features/restaurants/presentation/pages/RestaurantPage.dart';
import 'package:gearpizza/main.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/restaurants',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          BottomNavWithAnimatedIcons(child: child),
      routes: [
        GoRoute(
          path: '/restaurants',
          name: 'restaurants',
          builder: (context, state) => BlocProvider(
            create: (_) => RestaurantsCubit(sl<GearPizzaDirectusApiService>()),
            child: const RestaurantPage(title: "Restaurants"),
          ),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => BlocProvider(
            create: (_) => RestaurantsCubit(sl<GearPizzaDirectusApiService>()),
            child: const OrdersPage(title: "Orders"),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/restaurant/:id',
      name: 'restaurantDetail',
      builder: (context, state) {
        final restaurant = state.extra as Restaurant;
        return BlocProvider(
          create: (_) => PizzasCubit(sl<GearPizzaDirectusApiService>()),
          child: RestaurantDetailPage(restaurant: restaurant),
        );
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) {
        return Cartpage();
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => CustomerFormCubit(
            service: sl<GearPizzaDirectusApiService>(),
            cartCubit: context.read<CartCubit>(),
          ),
          child: Checkoutpage(),
        );
      },
    ),
  ],
);
