import '../../domain/entities/capster.dart';

class CapsterModel extends Capster {
  const CapsterModel({
    required super.id,
    required super.name,
    super.bio,
    required super.rating,
  });

  factory CapsterModel.fromJson(Map<String, dynamic> json) {
    return CapsterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      rating: json['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'rating': rating,
    };
  }
}
