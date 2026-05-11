import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String phone;
  final String password;
  final String name;
  final String dob;

  const RegisterRequested({
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
    required this.dob,
  });

  @override
  List<Object> get props => [email, phone, password, name, dob];
}

class LogoutRequested extends AuthEvent {}

class GetMeRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
