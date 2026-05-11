import 'package:dio/dio.dart';
import '../storage/secret_storage.dart';
import 'api_config.dart';

class ApiClient {
  final Dio _dio;
  final SecretStorage _secretStorage;

  ApiClient(this._dio, this._secretStorage) {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secretStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _secretStorage.getRefreshToken();
            
            if (refreshToken != null) {
              try {
                // Attempt to refresh the token
                final refreshResponse = await Dio().post(
                  '${ApiConfig.baseUrl}/auth/refresh',
                  data: {'refresh_token': refreshToken},
                );

                if (refreshResponse.statusCode == 200) {
                  final newToken = refreshResponse.data['data']['session_token'];
                  final newRefreshToken = refreshResponse.data['data']['refresh_token'];
                  
                  await _secretStorage.saveToken(newToken);
                  if (newRefreshToken != null) {
                    await _secretStorage.saveRefreshToken(newRefreshToken);
                  }

                  // Retry the original request
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';
                  
                  final response = await _dio.fetch(options);
                  return handler.resolve(response);
                }
              } catch (e) {
                // If refresh fails, clear tokens and let the error propagate
                // AuthBloc will handle state change to Unauthenticated
                await _secretStorage.clearTokens();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
