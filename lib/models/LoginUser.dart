import 'dart:convert';

LoginUser loginFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  String? username;
  String? password;

  LoginUser({
    required this.username,
    required this.password,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
