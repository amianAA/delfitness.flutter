import 'package:delfitness/ui/widgets/logout_button.dart';
import 'package:delfitness/ui/widgets/settings_button.dart';
import 'package:flutter/material.dart';

class CommunitiesPage extends StatelessWidget {
  const CommunitiesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const CommunitiesPage());
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
                    SettingsButton(),
                    LogoutButton(),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
