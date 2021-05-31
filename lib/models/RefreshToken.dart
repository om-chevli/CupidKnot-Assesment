import 'dart:convert';

String refreshTokensToJson(RefreshTokens data) => json.encode(data.toJson());

class RefreshTokens {
  RefreshTokens({
    required this.refreshToken,
  });

  String? refreshToken;

  Map<String, dynamic> toJson() => {
        "refresh_token": refreshToken == null ? null : refreshToken,
      };
}
