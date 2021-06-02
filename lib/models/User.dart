import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  final String? name;
  final String userId;
  final DateTime? dob;
  final String gender;
  final usrImage;
  final String? email;
  final String? religion;
  final String? fName;
  final String? lName;

  User({
    this.dob,
    required this.gender,
    this.name,
    required this.userId,
    this.email,
    this.religion,
    this.usrImage,
    this.fName,
    this.lName,
  });
}
