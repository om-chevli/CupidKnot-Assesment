import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  final String name;
  final String userId;
  final String dob;
  final String gender;
  final usrImage;

  User(
      {required this.dob,
      required this.gender,
      required this.name,
      required this.userId,
      this.usrImage});
}
