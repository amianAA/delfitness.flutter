part of 'navbar_bloc.dart';

enum View { profile, communities, trainingProofs }

class NavBarState extends Equatable {
  const NavBarState({
    this.view = View.trainingProofs,
  });

  final View view;

  NavBarState set({
    required View view,
  }) =>
      NavBarState(view: view);

  List<View> get inputs => [
        view,
      ];

  @override
  List<Object> get props => [view];
}
