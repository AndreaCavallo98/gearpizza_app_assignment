import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  String accessToken = dotenv.env['ACCESS_TOKEN'] ?? '';
  String refreshToken = dotenv.env['REFRESH_TOKEN'] ?? '';

  DioInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && refreshToken.isNotEmpty) {
      try {
        final res = await dio.post(
          '/auth/refresh',
          options: Options(headers: {
            'Authorization': 'Bearer $refreshToken',
          }),
        );

        accessToken = res.data['data']['access_token'];
        refreshToken = res.data['data']['refresh_token'];

        final cloned = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(cloned);
      } catch (e) {
        return handler.next(err); // Refresh fallito
      }
    }

    return handler.next(err); // Altri errori
  }
}
