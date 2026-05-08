import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel> getServiceById(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiClient apiClient;

  ServiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await apiClient.dio.get('/services');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList.map((e) => ServiceModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get services');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await apiClient.dio.get('/services/$id');
      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get service');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
