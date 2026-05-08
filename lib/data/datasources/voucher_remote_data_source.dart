import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/voucher_model.dart';

abstract class VoucherRemoteDataSource {
  Future<PointsModel> getPointsSummary();
  Future<List<VoucherModel>> getVouchers();
  Future<VoucherModel> redeemVoucher(String voucherId);
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final ApiClient apiClient;

  VoucherRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PointsModel> getPointsSummary() async {
    try {
      final response = await apiClient.dio.get('/points/summary');
      if (response.statusCode == 200) {
        return PointsModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get points');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<List<VoucherModel>> getVouchers() async {
    try {
      final response = await apiClient.dio.get('/vouchers');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList.map((e) => VoucherModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get vouchers');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<VoucherModel> redeemVoucher(String voucherId) async {
    try {
      final response = await apiClient.dio.post('/vouchers/$voucherId/redeem');
      if (response.statusCode == 200) {
        return VoucherModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to redeem voucher');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
