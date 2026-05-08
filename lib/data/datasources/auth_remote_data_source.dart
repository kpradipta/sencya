import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String phone, String password, String name, String dob);
  Future<void> logout();
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({required this.apiClient, required this.sharedPreferences});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'identifier': email,
        'password': password,
        'device_info': {
          'OS': 'web',
          'Model': 'chrome',
          'Version': '114.0.0.0'
        }
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['session_token'];
        final refreshToken = data['refresh_token'];
        if (token != null) await sharedPreferences.setString('auth_token', token);
        if (refreshToken != null) await sharedPreferences.setString('refresh_token', refreshToken);
        return UserModel.fromJson(data['user']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<UserModel> register(String email, String phone, String password, String name, String dob) async {
    try {
      final response = await apiClient.dio.post('/auth/register', data: {
        'email': email,
        'phone': phone,
        'password': password,
        'name': name,
        'dob': dob,
      });

      if (response.statusCode == 201) {
        final data = response.data['data'];
        final token = data['token'];
        if (token != null) await sharedPreferences.setString('auth_token', token);
        return UserModel.fromJson(data['user']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = sharedPreferences.getString('refresh_token') ?? '';
      await apiClient.dio.post('/auth/logout', data: {
        'refresh_token': refreshToken,
      });
      await sharedPreferences.remove('auth_token');
      await sharedPreferences.remove('refresh_token');
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Logout failed');
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await apiClient.dio.get('/auth/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
