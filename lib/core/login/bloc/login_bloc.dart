import 'package:delfitness/common/repositories/authentication/models/errors.dart';
import 'package:delfitness/common/repositories/authentication/models/password.dart';
import 'package:delfitness/common/repositories/authentication/models/username.dart';
import 'package:delfitness/common/repositories/authentication/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(onUsernameChanged);
    on<LoginPasswordChanged>(onPasswordChanged);
    on<LoginSubmitted>(onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isInitial || state.status.isFailure) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            message: "Bienvenid@ a Delfiness ;)"));
      } catch (e) {
        if (e == ErrorUnreachable) {
          emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              message:
                  "Ha ocurrido un error. Por favor, contacte con el administrador."));
        } else if (e == ErrorBadRequest) {
          emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              message: "Las credenciales no son válidas."));
        }
      }
    }
  }
}
