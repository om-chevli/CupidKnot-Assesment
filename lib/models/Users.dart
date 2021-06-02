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

  User personalProfile = new User(
    dob: DateTime.now(),
    gender: "gender",
    name: "name",
    userId: "userId",
    email: "",
    religion: "",
    usrImage: "",
  );

  List<User> get usersCopy {
    return [...?users];
  }

  // User personalProfile;

  User get profileCopy {
    return personalProfile;
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
            if (value != null) {
              dob.add(DateTime.tryParse(value));
            } else {
              dob.add(DateTime.tryParse("11/01/1911"));
            }
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
      debugPrintStack();
      throw (e);
    }
  }

  Future<void> viewProfile() async {
    try {
      final response = await http.get(
        Uri.https(url!, 'api/user'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + authToken!,
        },
      );
      final extractedUser = json.decode(response.body) as Map<String, dynamic>;
      if (extractedUser == null) {
        return;
      }
      print(extractedUser["name"]);
      print(extractedUser["birth_date"]);
      print(extractedUser["gender"]);
      print(extractedUser["id"]);
      personalProfile = User(
        name: extractedUser["name"],
        dob: DateTime.parse(extractedUser["birth_date"]),
        gender: extractedUser["gender"] == null ? "" : extractedUser["gender"],
        userId: extractedUser["id"].toString(),
        usrImage: extractedUser["user_images"],
        email: extractedUser["email"],
        religion: extractedUser["religion"],
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProfile(User newValues) async {
    try {
      await http.post(
        Uri.https(url!, 'api/update_user'),
        body: {
          'first_name': newValues.fName,
          'last_name': newValues.lName,
          'email': newValues.email,
          'religion': newValues.religion,
          'birth_date': newValues.dob.toString(),
          'gender': newValues.gender,
          'updated_at': DateTime.now().toString(),
        },
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + authToken!,
        },
      ).then((res) {
        personalProfile = User(
          name: "${newValues.fName}" + " " + "${newValues.lName}",
          email: newValues.email,
          religion: newValues.religion,
          dob: newValues.dob,
          gender: newValues.gender,
          userId: newValues.userId,
        );
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }
}
