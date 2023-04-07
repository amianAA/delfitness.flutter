part of 'login_bloc.dart';

class LoginState extends Equatable with FormzMixin {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.message = ""
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final String message;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    String? message,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      message: message ?? this.message,
    );
  }


  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [username, password];

  @override
  List<Object> get props => [status, username, password, message];
}
