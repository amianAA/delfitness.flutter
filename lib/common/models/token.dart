class UserToken {
  final String token;

  const UserToken({
    required this.token,
  });

  List<Object> get props => [token, ];

  static const empty = UserToken(token: '');

  factory UserToken.fromJson(Map<String, dynamic> json) =>
      UserToken(token: json['token'],);
}
