import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  static Route<dynamic> route() {
    return MaterialPageRoute<HomeScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.initial) {
          DiscryptorApp.navigatorKey.currentState!
              .pushAndRemoveUntil(LoginScreen.route(), (route) => false);
        }
      },
      child: SafeArea(
          child: Material(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            Text("Welcome home!"),
            ElevatedButton(
                onPressed: () => context.read<LoginCubit>().logout(),
                child: Container(child: Text('Log out')))
          ])))),
    );
  }
}
