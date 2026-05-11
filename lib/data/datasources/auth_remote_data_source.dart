import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../../core/storage/secret_storage.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String email,
    String phone,
    String password,
    String name,
    String dob,
  );
  Future<void> logout();
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SecretStorage secretStorage;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.secretStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'identifier': email,
          'password': password,
          'device_info': {
            'OS': 'web',
            'Model': 'chrome',
            'Version': '114.0.0.0',
          },
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['session_token'];
        final refreshToken = data['refresh_token'];
        if (token != null) {
          await secretStorage.saveToken(token);
        }
        if (refreshToken != null) {
          await secretStorage.saveRefreshToken(refreshToken);
        }
        
        final userJson = Map<String, dynamic>.from(data['user']);
        if (data['capster'] != null) {
          userJson['capster'] = data['capster'];
        }
        return UserModel.fromJson(userJson);
       } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String phone,
    String password,
    String name,
    String dob,
  ) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'phone': phone,
          'password': password,
          'name': name,
          'dob': dob,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        final token = data['token'];
        if (token != null) {
          await secretStorage.saveToken(token);
        }
        return UserModel.fromJson(data['user']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await secretStorage.getRefreshToken() ?? '';
      await apiClient.dio.post(
        '/auth/logout',
        data: {'refresh_token': refreshToken},
      );
      await secretStorage.clearTokens();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Logout failed',
      );
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await apiClient.dio.get('/auth/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get profile',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }
}
