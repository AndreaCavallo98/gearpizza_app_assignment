import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gearpizza/core/storage/token_storage.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  String accessToken = dotenv.env['GUEST_ACCESS_TOKEN'] ?? '';
  String refreshToken = dotenv.env['GUEST_REFRESH_TOKEN'] ?? '';

  DioInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? accessToken = TokenStorage.getAccessTokenSync();

    // Se il token è null (all'inizio), usa quello statico
    if (accessToken == null) {
      print('❌ Access token is null');
      accessToken = dotenv.env['GUEST_ACCESS_TOKEN'] ?? '';
    }
    print('❌ Access token: $accessToken');

    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('❌ 401 Unauthorized');
      String? refreshToken = TokenStorage.getRefreshTokenSync();
      refreshToken ??= dotenv.env['GUEST_REFRESH_TOKEN'] ?? '';

      if (refreshToken.isNotEmpty) {
        try {
          final refreshDio = Dio(
            BaseOptions(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );
          refreshDio.interceptors.clear(); // 👈 fondamentale!

          final res = await refreshDio.post(
            'https://gearpizza.revod.services/auth/refresh',
            data: jsonEncode({'refresh_token': refreshToken}),
          );

          print('✅ REFRESH SUCCESS: ${res.data}');

          final newAccessToken = res.data['data']['access_token'];
          final newRefreshToken = res.data['data']['refresh_token'];

          // Salva i nuovi token
          await TokenStorage.saveTokens(newAccessToken, newRefreshToken);

          // Clona la richiesta originale
          final originalRequest = err.requestOptions;
          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          print('🔁 Retrying original request...');
          final retryResponse = await dio.fetch(originalRequest);
          return handler.resolve(retryResponse);
        } catch (e) {
          print('❌ Refresh token failed: $e');
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }
}
