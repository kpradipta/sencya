import 'package:barbershop_app/domain/entities/capster.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final Capster? capster;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.capster,
  });

  bool get isCapster => capster?.id != null;

  @override
  List<Object?> get props => [id, email, name, phone, capster];
}
