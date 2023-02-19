import 'package:discryptor/views/home.dart';
import 'package:discryptor/views/login/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash';

  static Route<dynamic> route() {
    return MaterialPageRoute<SplashScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Todo: read auth state from storage
    bool authenticated = 1 + 2 == 5;
    return authenticated ? const HomeScreen() : LoginScreen();
  }
}
