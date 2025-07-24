import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import 'package:gearpizza/features/cart/logic/cubit/customer_form_cubit.dart';
import 'package:gearpizza/features/cart/logic/cubit/customer_form_state.dart';

class Checkoutpage extends StatefulWidget {
  const Checkoutpage({super.key});

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _imageFile;
  String? _imageErrorText;
  String? _addressErrorText;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageErrorText = null;
        });
      }
    } catch (e) {
      debugPrint("Errore durante pickImage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CustomerFormCubit, CustomerFormState>(
        listener: (context, state) {
          if (state.success) {
            final msg = state.customerAlreadyExists!
                ? 'Ordine inviato! Cliente già esistente.'
                : 'Ordine inviato! Nuovo cliente creato.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: Colors.green),
            );
            context.go('/orders');
          }

          if (state.genericError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.genericError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final backendErrors = state.backendErrors;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nome",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Inserisci il tuo nome',
                        border: const OutlineInputBorder(),
                        errorText: backendErrors['name'],
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obbligatorio'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Inserisci la tua email',
                        border: const OutlineInputBorder(),
                        errorText: backendErrors['email'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Campo obbligatorio';
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        return regex.hasMatch(value)
                            ? null
                            : 'Email non valida';
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Indirizzo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GooglePlaceAutoCompleteTextField(
                      isLatLngRequired: false,
                      getPlaceDetailWithLatLng: null,
                      textEditingController: addressController,
                      googleAPIKey: dotenv.env['GOOGLE_API_KEY']!,
                      inputDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        hintText: "Inserisci l'indirizzo",
                        border: const OutlineInputBorder(),
                        errorText:
                            _addressErrorText ?? backendErrors['address'],
                      ),
                      debounceTime: 600,
                      countries: ["it"],
                      itemClick: (prediction) {
                        addressController.text = prediction.description!;
                        setState(() => _addressErrorText = null);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Immagine",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt, size: 18),
                          label: const Text("Scegli immagine"),
                        ),
                        const SizedBox(width: 12),
                        if (_imageFile != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                    if (_imageErrorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _imageErrorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                final isValidForm = _formKey.currentState!
                                    .validate();
                                setState(() {
                                  _addressErrorText =
                                      addressController.text.trim().isEmpty
                                      ? 'Campo obbligatorio'
                                      : null;
                                  _imageErrorText = _imageFile == null
                                      ? 'Seleziona un\'immagine'
                                      : null;
                                });

                                if (isValidForm &&
                                    _addressErrorText == null &&
                                    _imageErrorText == null) {
                                  context.read<CustomerFormCubit>().submitForm(
                                    name: nameController.text,
                                    email: emailController.text,
                                    address: addressController.text,
                                    imageFile: _imageFile!,
                                  );
                                }
                              },
                        child: state.isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Invia",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
