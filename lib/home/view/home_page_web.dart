import 'package:flutter/material.dart';
import 'package:delfitness/components/logout_button.dart';

import '../../components/settings_button.dart';
import '../../user/user_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.blue,
                child: const Text('Dummy Text'),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  UserInfo(),
                  SettingsButton(),
                  LogoutButton(),
                ],
                ),
              )
            ]
        ),
      ),
    );
  }
}
