import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

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

  bool get isRunningOnSimulator {
    return Platform.isIOS &&
        !Platform.isMacOS &&
        !Platform.isAndroid &&
        !Platform.isFuchsia &&
        Platform.environment.toString().contains('SIMULATOR_');
  }

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
      } else {
        debugPrint("Nessuna immagine selezionata.");
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nome",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Inserisci il tuo nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obbligatorio'
                      : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Inserisci la tua email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo obbligatorio';
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!regex.hasMatch(value)) return 'Email non valida';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Indirizzo",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                GooglePlaceAutoCompleteTextField(
                  isLatLngRequired: false,
                  getPlaceDetailWithLatLng: null,
                  textEditingController: addressController,
                  googleAPIKey: dotenv.env['GOOGLE_API_KEY']!,
                  inputDecoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    hintText: "Inserisci l'indirizzo",
                    border: OutlineInputBorder(),
                  ),
                  debounceTime: 600,
                  countries: ["it"],
                  itemClick: (prediction) {
                    addressController.text = prediction.description!;
                    setState(() => _addressErrorText = null);
                  },
                ),
                if (_addressErrorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _addressErrorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  "Immagine",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      style: const TextStyle(color: Colors.red, fontSize: 12),
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
                    onPressed: () {
                      final isValidForm = _formKey.currentState!.validate();

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
                        // context.read<CustomerFormCubit>().submitForm(...);
                      }
                    },
                    child: const Text(
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
      ),
    );
  }
}
