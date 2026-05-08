import 'package:equatable/equatable.dart';

class Points extends Equatable {
  final int totalPoints;
  final int usedPoints;

  const Points({
    required this.totalPoints,
    required this.usedPoints,
  });

  @override
  List<Object?> get props => [totalPoints, usedPoints];
}

class Voucher extends Equatable {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final bool isRedeemed;

  const Voucher({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.isRedeemed,
  });

  @override
  List<Object?> get props => [id, name, description, pointsRequired, isRedeemed];
}
