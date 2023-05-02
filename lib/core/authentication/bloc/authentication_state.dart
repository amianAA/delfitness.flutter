part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });
  final AuthenticationStatus status;
  final User user;

  const AuthenticationState.unknown() : this._();
  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);
  const AuthenticationState.unauthenticated()
      // ignored by coverage due to bug:  https://github.com/dart-lang/sdk/issues/38934
      : this._(
            status:
                AuthenticationStatus.unauthenticated); // coverage:ignore-line

  @override
  List<Object> get props => [status, user];
}
