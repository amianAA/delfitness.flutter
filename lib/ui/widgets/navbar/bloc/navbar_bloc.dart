import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState()) {
    on<NavBarProfilePressed>(_onNavBarProfilePressed);
    on<NavBarCommunityPressed>(_onNavBarCommunityPressed);
    on<NavBarTrainingProofsPressed>(_onNavBarTrainingProofsPressed);
  }

  void _onNavBarProfilePressed(
      NavBarProfilePressed event, Emitter<NavBarState> emit) {
    emit(state.set(view: View.profile));
  }

  void _onNavBarCommunityPressed(
      NavBarCommunityPressed event, Emitter<NavBarState> emit) {
    emit(state.set(view: View.communities));
  }

  void _onNavBarTrainingProofsPressed(
      NavBarTrainingProofsPressed event, Emitter<NavBarState> emit) {
    emit(state.set(view: View.trainingProofs));
  }
}
