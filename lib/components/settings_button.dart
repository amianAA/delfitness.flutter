import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authentication/authentication.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _getSettingsButtonStyle(),
      child: const Icon(IconData(0xe57f, fontFamily: 'MaterialIcons')),
      onPressed: () {},
    );
  }
}


ButtonStyle _getSettingsButtonStyle() => ElevatedButton.styleFrom(
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(24),
  );
