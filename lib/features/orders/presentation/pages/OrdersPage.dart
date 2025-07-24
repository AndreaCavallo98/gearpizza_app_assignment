import 'package:animate_do/animate_do.dart';
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
  // Aggiungi il controller per il scroll
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
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

              return Scrollbar(
                controller:
                    _scrollController, // Imposta il controller per la scrollbar
                thumbVisibility: true, // Mostra sempre la barra di scorrimento
                child: ListView.builder(
                  controller:
                      _scrollController, // Associa il controller alla lista
                  padding: const EdgeInsets.all(25),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: (index + 1) * 200),
                      child: OrderCard(order: order),
                    );
                  },
                ),
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
