import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gearpizza/core/di/injection.dart';
import 'package:gearpizza/core/storage/token_storage.dart';
import 'package:gearpizza/features/cart/logic/cubit/cart_cubit.dart';
import 'package:gearpizza/router/app_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await TokenStorage.initialize();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  print('🟢 HydratedBloc storage initialized');

  setupDependencies();

  runApp(BlocProvider(create: (_) => CartCubit(), child: const MyApp()));
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
