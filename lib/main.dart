import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gearpizza/core/di/injection.dart';
import 'package:gearpizza/core/storage/token_storage.dart';
import 'package:gearpizza/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Carica variabili ambiente (.env)
  await TokenStorage.initialize(); // Carica i token, o da .env o da SharedPreferences

  setupDependencies(); // Inizializza la DI (Dependency Injection)
  runApp(const MyApp());
}

// Funzione che inizializza i token, caricandoli da SharedPreferences o da .env
Future<void> initializeTokens() async {
  final prefs = await SharedPreferences.getInstance();

  // Se i token non sono presenti in SharedPreferences, carica quelli da .env
  if (prefs.getString('access_token') == null ||
      prefs.getString('refresh_token') == null) {
    await TokenStorage.saveTokens(
      dotenv.env['GUEST_ACCESS_TOKEN']!, // Carica il token statico da .env
      dotenv
          .env['GUEST_REFRESH_TOKEN']!, // Carica il refresh token statico da .env
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'restaurants',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
