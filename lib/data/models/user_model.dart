import '../../domain/entities/user.dart';
import 'capster_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    super.capster,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      phone: json['phone'] ?? '',
      capster: json['capster'] != null ? CapsterModel.fromJson(json['capster']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'capster': capster,
    };
  }
}
