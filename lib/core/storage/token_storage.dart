import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static String? accessToken;
  static String? refreshToken;

  // Inizializza i token caricandoli da SharedPreferences, o se non presenti da .env
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');

    // Se i token non sono in SharedPreferences, carica quelli da .env
    if (accessToken == null || refreshToken == null) {
      accessToken = dotenv.env['GUEST_ACCESS_TOKEN'];
      refreshToken = dotenv.env['GUEST_REFRESH_TOKEN'];

      // Salva i token in SharedPreferences per future sessioni
      await saveTokens(accessToken!, refreshToken!);
    }
  }

  // Salva i token in SharedPreferences e aggiorna le variabili globali
  static Future<void> saveTokens(
    String newAccessToken,
    String newRefreshToken,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    accessToken = newAccessToken;
    refreshToken = newRefreshToken;

    await prefs.setString('access_token', newAccessToken);
    await prefs.setString('refresh_token', newRefreshToken);
  }

  // Restituisce l'access token in modo sincrono
  static String? getAccessTokenSync() {
    return accessToken;
  }

  // Restituisce il refresh token in modo sincrono
  static String? getRefreshTokenSync() {
    return refreshToken;
  }

  // Cancella i token da SharedPreferences e aggiorna le variabili globali
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    accessToken = null;
    refreshToken = null;

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}
