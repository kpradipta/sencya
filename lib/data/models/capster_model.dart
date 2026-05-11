import '../../domain/entities/capster.dart';

class CapsterModel extends Capster {
  const CapsterModel({
    required super.id,
    required super.name,
    super.bio,
    required super.rating,
    super.target,
    super.achievement,
    super.incentive,
  });

  factory CapsterModel.fromJson(Map<String, dynamic> json) {
    return CapsterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['description'] ?? json['bio'],
      rating: json['rating'] ?? 0,
      target: json['target'] ?? 0,
      achievement: json['achievement'] ?? 0,
      incentive: json['incentive'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'rating': rating,
      'target': target,
      'achievement': achievement,
      'incentive': incentive,
    };
  }
}
