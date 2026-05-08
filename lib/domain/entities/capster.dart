import 'package:equatable/equatable.dart';

class Capster extends Equatable {
  final String id;
  final String name;
  final String? bio;
  final num rating;

  const Capster({
    required this.id,
    required this.name,
    this.bio,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, name, bio, rating];
}
