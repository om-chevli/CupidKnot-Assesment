import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './User.dart';
import './json_parse.dart';

class UserImage {
  UserImage({
    required this.name,
  });

  String name;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
      };
}

class Users with ChangeNotifier {
  List<User>? users = [];
  final String? authToken;

  Users({this.authToken, this.users});

  String? url = 'cupidknot.kuldip.dev';

  List<User> get usersCopy {
    return [...?users];
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.https(url!, 'api/users'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + authToken!,
        },
      );

      final List<User> loadedUsers = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(response.statusCode);
      final userData = responseData["data"]["data"];
      var name = [];
      var id = [];
      var dob = [];
      var gender = [];
      // Map<String, dynamic> userImages = {};
      List<dynamic> images = [];
      for (Map<String, dynamic> user in userData) {
        user.forEach((key, value) {
          if (key == "name") {
            name.add(value.toString());
          }
          if (key == "id") {
            id.add(value.toString());
          }
          if (key == "birth_date") {
            dob.add(value.toString());
          }
          if (key == "gender") {
            if (value != null) {
              gender.add(value);
            } else {
              gender.add("Not Specified");
            }
          }
          if (key == "user_images") {
            if (value != null) images = value;
          }
        });
      }
      // userImages.forEach((element) {
      //   // images.addAll(
      //   //   {
      //   //     'user_id': element["user_id"],
      //   //     'name': [element["name"]],
      //   //   },
      //   // );
      //   print(element["name"]);
      // });
      // print(userImages);
      for (int i = 0; i < name.length; i++) {
        // print(images.containsValue(id[i]));
        // print(id[i]);
        loadedUsers.add(
          User(
            name: name[i],
            dob: dob[i],
            gender: gender[i],
            userId: id[i],
            usrImage: images,
          ),
        );
      }
      print(loadedUsers.length);

      users = loadedUsers.toList();
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
