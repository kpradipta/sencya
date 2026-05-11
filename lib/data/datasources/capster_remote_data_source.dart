import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/capster_model.dart';
import '../models/capster_history_model.dart';

abstract class CapsterRemoteDataSource {
  Future<List<CapsterModel>> getCapsters();
  Future<CapsterModel> getCapsterById(String id);
  Future<List<CapsterHistoryModel>> getCapsterHistory();
}

class CapsterRemoteDataSourceImpl implements CapsterRemoteDataSource {
  final ApiClient apiClient;

  CapsterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CapsterModel>> getCapsters() async {
    try {
      final response = await apiClient.dio.get('/capsters');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data']['items'];
        return jsonList.map((e) => CapsterModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get capsters');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<CapsterModel> getCapsterById(String id) async {
    try {
      final response = await apiClient.dio.get('/capsters/$id');
      if (response.statusCode == 200) {
        return CapsterModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get capster');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<List<CapsterHistoryModel>> getCapsterHistory() async {
    try {
      final response = await apiClient.dio.get('/histories/capster');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data']['items'];
        return jsonList.map((e) => CapsterHistoryModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get history');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
