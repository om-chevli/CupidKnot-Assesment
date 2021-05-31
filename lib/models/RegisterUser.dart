import 'dart:convert';

String RegisterUserToJson(RegisterUser data) => json.encode(data.toJson());
RegisterUser RegisterUserFromJson(String str) =>
    RegisterUser.fromJson(json.decode(str));

class RegisterUser {
  String firstName;
  String lastName;
  String email;
  String password;
  String passwordConfirmation;
  String gender;

  RegisterUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.gender,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "gender": gender,
      };
}
