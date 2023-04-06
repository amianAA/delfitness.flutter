import 'package:flutter/material.dart';

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
