import 'package:delfitness/ui/widgets/navbar/bloc/navbar_bloc.dart';
import 'package:delfitness/ui/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        bottomNavigationBar: BlocProvider(
            create: (context) => NavBarBloc(), child: const NavBar()));
  }
}
