import 'dart:convert';

import 'package:flutter/cupertino.dart';

String apiRequestsToJson(ApiRequests data) => json.encode(data.toJson());

class ApiRequests with ChangeNotifier {
  ApiRequests({
    required this.accept,
    required this.authorization,
  });

  final String accept;
  final String authorization;

  Map<String, dynamic> toJson() => {
        "Accept": accept,
        "Authorization": authorization,
      };
}
