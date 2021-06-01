import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginUser.dart';
import 'http_exception.dart';
import 'RefreshToken.dart';

class Auth with ChangeNotifier {
  String? _accessToken;
  String? _refereshToken;
  DateTime? _expiryDate;
  Timer? _authTimer;
  String? url = 'cupidknot.kuldip.dev';

  bool get isAuth {
    return _accessToken != null;
  }

  String? get token {
    // ignore: unnecessary_null_comparison
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        // ignore: unnecessary_null_comparison
        _accessToken != null) {
      return _accessToken;
    } else {
      return "$_newAccessToken()";
    }
  }

  Future<String?> _newAccessToken() async {
    final response = await http.post(
      Uri.https(url!, 'api/refresh'),
      body: RefreshTokens(refreshToken: _refereshToken),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 302) {
      return null;
    } else if (response.statusCode == 200) {
      _accessToken = responseData["access_token"];
      _refereshToken = responseData["refresh_token"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expires_in'],
          ),
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'access_token': _accessToken,
          'refresh_token': _refereshToken,
          'expires_in': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } else {
      return null;
    }
  }

  Future<String?> logingUser(Map<String, String> _data) async {
    // try {
    final response = await http.post(Uri.https(url!, 'api/login'),
        body: LoginUser(
          username: _data["email"],
          password: _data["password"],
        ).toJson());
    final responseData = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw HttpException("Incorrect Credentials");
    }
    if (response.statusCode == 200) {
      _accessToken = responseData["access_token"];
      _refereshToken = responseData["refresh_token"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: responseData['expires_in'],
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'access_token': _accessToken,
          'refresh_token': _refereshToken,
          'expires_in': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

      _autoLogout();
      notifyListeners();
    } else {
      return "Bad Credentials";
    }
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    String? getData = prefs.getString('userData');
    final extractedUserData = json.decode(getData!);
    final fetchDate = extractedUserData['expires_in'];
    final expires_in = DateTime.parse(fetchDate.toString());

    if (expires_in.isBefore(DateTime.now())) {
      return false;
    }
    _accessToken = extractedUserData['access_token'];
    _refereshToken = extractedUserData['refresh_token'];
    _expiryDate = expires_in;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> logout() async {
    _accessToken = null;
    _refereshToken = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
