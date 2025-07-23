import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/allergens_cubit.dart';
import 'package:gearpizza/features/restaurants/logic/cubit/allergens_state.dart';

class AllergenBottomSheet extends StatefulWidget {
  final List<int> initialSelectedIds;

  const AllergenBottomSheet({super.key, required this.initialSelectedIds});

  @override
  State<AllergenBottomSheet> createState() => _AllergenBottomSheetState();
}

class _AllergenBottomSheetState extends State<AllergenBottomSheet> {
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();
    selectedIds = [...widget.initialSelectedIds];
    context.read<AllergensCubit>().fetchAllergens();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Text(
            "Seleziona allergeni da evitare",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          BlocConsumer<AllergensCubit, AllergensState>(
            listener: (context, state) {
              if (state is AllergensError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AllergensLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is AllergensLoaded) {
                return Column(
                  children: [
                    ...state.allergens.map((a) {
                      return CheckboxListTile(
                        title: Text(a.name),
                        value: selectedIds.contains(a.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedIds.add(a.id);
                            } else {
                              selectedIds.remove(a.id);
                            }
                          });
                        },
                      );
                    }),
                  ],
                );
              }
              return const SizedBox();
            },
          ),

          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedIds);
            },
            child: Text("Applica filtro"),
          ),
        ],
      ),
    );
  }
}
