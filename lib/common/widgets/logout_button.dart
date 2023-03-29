import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/authentication.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _getLogOutButtonStyle(),
      child: const Icon(IconData(0xf71e, fontFamily: 'MaterialIcons')),
      onPressed: () {
        context
            .read<AuthenticationBloc>()
            .add(AuthenticationLogoutRequested());
      },
    );
  }
}


ButtonStyle _getLogOutButtonStyle() => ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(24),
  );
