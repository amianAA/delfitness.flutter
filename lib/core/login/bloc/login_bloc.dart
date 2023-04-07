import 'package:delfitness/common/models/password.dart';
import 'package:delfitness/common/models/username.dart';
import 'package:delfitness/common/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isInitial || state.status.isFailure) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      Response resp = await _authenticationRepository.logIn(
        username: state.username.value,
        password: state.password.value,
      );
      if (resp.statusCode == 200) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.success,
            message: "Bienvenid@ a Delfiness ;)"));
      } else if (resp.statusCode == 400) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            message: "Las credenciales no son válidas"));
      } else {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure,
            message:
                "Ha ocurrido un error. Por favor, contacte con el administrador."));
      }
    }
  }
}
