import 'package:delfitness/settings/theme.dart';
import 'package:delfitness/ui/widgets/navbar/bloc/navbar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      buildWhen: (previous, current) => previous.view != current.view,
      builder: (context, state) => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Comunidades',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Pruebas',
            ),
          ],
          currentIndex: context.read<NavBarBloc>().state.view.index,
          selectedItemColor: AppTheme.focusNavBarItemColor,
          onTap: (int index) {
            Map<int, NavBarEvent> eventMapper = {
              0: const NavBarProfilePressed(),
              1: const NavBarCommunityPressed(),
              2: const NavBarTrainingProofsPressed()
            };
            context.read<NavBarBloc>().add(eventMapper[index]!);
          }),
    );
  }
}
