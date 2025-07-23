import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/restaurants_state.dart';
import 'package:gearpizza/features/restaurants/presentation/widgets/restaurant_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, required this.title});
  final String title;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text("Orders"))),
    );
  }
}
