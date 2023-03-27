import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delfitness/authentication/authentication.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final user = context.select(
          (AuthenticationBloc bloc) => bloc.state.user,
        );
        return Column(children: [
          Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://thumbs.dreamstime.com/b/vector-de-icono-perfil-usuario-s%C3%ADmbolo-retrato-avatar-logo-la-persona-forma-plana-silueta-negra-aislada-sobre-fondo-blanco-196482128.jpg")
                        )
                    )),
                 Text(user.firstName)
        ],);
      },
    );
  }
}
