import 'package:discryptor/cubits/login_cubit/login_cubit.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/home.dart';
import 'package:discryptor/views/login/views/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  static Route<dynamic> route() {
    return MaterialPageRoute<LoginScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) => {
              if (state.status == LoginStatus.loggedIn)
                DiscryptorApp.navigatorKey.currentState!
                    .pushAndRemoveUntil(HomeScreen.route(), (route) => false)
            },
        child: Material(
            child: SafeArea(
          child: Column(children: [
            const Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'D15CRYPT0R',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28),
                  ),
                )),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(child: LoginForm()),
                ))
          ]),
        )));
  }
}
