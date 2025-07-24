import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/orders/logic/orders_cubit.dart';
import 'package:gearpizza/features/orders/logic/orders_state.dart';
import 'package:gearpizza/features/orders/presentation/widgets/order_card.dart';

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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        title: Text(
          "Ordini",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text("Non hai ordini"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(25),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
                },
              );
            }

            return const Center(
              child: Text("Errore nel recupero degli ordini"),
            );
          },
        ),
      ),
    );
  }
}
