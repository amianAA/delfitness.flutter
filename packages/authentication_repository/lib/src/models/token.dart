class UserToken {
  final String accessToken;
  final String refreshToken;

  const UserToken({
    required String accessToken,
    required String refreshToken,
    }): accessToken=accessToken,
        refreshToken=refreshToken;

  List<Object> get props => [accessToken, refreshToken];

  static const empty = UserToken(accessToken: '', refreshToken: '');

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
      accessToken: json['access'],
      refreshToken: json['refresh']);
}