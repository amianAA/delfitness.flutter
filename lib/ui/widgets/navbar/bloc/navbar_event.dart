part of 'navbar_bloc.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object> get props => [];
}

class NavBarProfilePressed extends NavBarEvent {
  const NavBarProfilePressed();

  @override
  List<Object> get props => [];
}

class NavBarCommunityPressed extends NavBarEvent {
  const NavBarCommunityPressed();

  @override
  List<Object> get props => [];
}

class NavBarTrainingProofsPressed extends NavBarEvent {
  const NavBarTrainingProofsPressed();

  @override
  List<Object> get props => [];
}
