import '../../domain/entities/voucher.dart';

class PointsModel extends Points {
  const PointsModel({
    required super.totalPoints,
    required super.usedPoints,
  });

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    return PointsModel(
      totalPoints: json['total_points'] ?? 0,
      usedPoints: json['used_points'] ?? 0,
    );
  }
}

class VoucherModel extends Voucher {
  const VoucherModel({
    required super.id,
    required super.name,
    required super.description,
    required super.pointsRequired,
    required super.isRedeemed,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pointsRequired: json['points_required'] ?? 0,
      isRedeemed: json['is_redeemed'] ?? false,
    );
  }
}
