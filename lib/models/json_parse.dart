import 'dart:convert';

ParseJson parseFromJson(String str) => ParseJson.fromJson(json.decode(str));

class ParseJson {
  ParseJson({
    required this.data,
  });

  Data? data;

  factory ParseJson.fromJson(Map<String, dynamic> json) => ParseJson(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    required this.data,
  });

  List<Datum>? data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    required this.userImages,
  });

  int id;
  String name;
  DateTime? birthDate;
  dynamic gender;
  List<UserImage>? userImages;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
        gender: json["gender"],
        userImages: json["user_images"] == null
            ? null
            : List<UserImage>.from(
                json["user_images"].map((x) => UserImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "birth_date": birthDate == null
            ? null
            : "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "user_images": userImages == null
            ? null
            : List<dynamic>.from(userImages!.map((x) => x.toJson())),
      };
}

class UserImage {
  UserImage({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "id": id == null ? null : id,
      };
}
