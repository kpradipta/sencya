import 'package:equatable/equatable.dart';

class Capster extends Equatable {
  final String id;
  final String name;
  final String? bio;
  final num rating;
  final num target;
  final num achievement;
  final num incentive;

  const Capster({
    required this.id,
    required this.name,
    this.bio,
    required this.rating,
    this.target = 0,
    this.achievement = 0,
    this.incentive = 0,
  });

  double get progressPercentage {
    if (target == 0) return 0;
    return (achievement / target).clamp(0, 1).toDouble();
  }

  @override
  List<Object?> get props => [id, name, bio, rating, target, achievement, incentive];
}
