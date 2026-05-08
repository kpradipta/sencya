import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String name;
  final num price;
  final int duration;
  final String description;

  const Service({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, price, duration, description];
}
