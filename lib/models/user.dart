import 'package:equatable/equatable.dart';

// {
//      googleId: "115188038253667639012",
//      email: "ajeetkumar8358921860@gmail.com",
//      name: "Ajeet Kumar",
//      picture: "https://lh3.googleusercontent.com/a/ACg8ocLSEwyuqjiRup1aJr4EUa6kQwnjbGyQ6kjOnCXmU
//      f9d-Z8=s96-c",
//      createdAt: "2024-03-27T12:24:52.015Z",
//      id: "660410147270663b8909df7f"
// }
class User extends Equatable {
  final String googleId;
  final String email;
  final String name;
  final String picture;
  final String createdAt;
  final String id;
  final String level;

  const User(
      {required this.googleId,
      required this.email,
      required this.name,
      required this.picture,
      required this.createdAt,
      required this.id,
      required this.level});

  @override
  List<Object?> get props =>
      [googleId, email, name, picture, createdAt, id, level];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        googleId: json['googleId'],
        email: json['email'],
        name: json['name'],
        picture: json['picture'] ?? '',
        createdAt: json['createdAt'],
        id: json['id'],
        level: json['level'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'googleId': googleId,
      'email': email,
      'name': name,
      'picture': picture,
      'createdAt': createdAt,
      'id': id,
      'level': level
    };
  }
}
