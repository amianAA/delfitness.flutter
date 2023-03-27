import 'package:equatable/equatable.dart';

class User extends Equatable {

  final int id;
  final String email;
  final String firstName;
  final String lastName;

  const User({
    required int id, 
    required String email, 
    required String firstName, 
    required String lastName,
    }): id=id,
        email = email,
        firstName = firstName,
        lastName = lastName;

  @override
  List<Object> get props => [id, email, firstName, lastName];

  static const empty = User(id: -1, email: '', firstName: '', lastName: '');

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name']);
}
