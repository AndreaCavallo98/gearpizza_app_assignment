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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra superiore
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Seleziona allergeni da evitare",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AllergensLoaded) {
                  return Column(
                    children: state.allergens.map((a) {
                      final isSelected = selectedIds.contains(a.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(a.name),
                          value: isSelected,
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedIds.add(a.id);
                              } else {
                                selectedIds.remove(a.id);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedIds);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Applica filtro",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
