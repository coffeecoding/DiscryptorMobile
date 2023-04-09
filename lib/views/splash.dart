import 'package:discryptor/cubits/auth/auth_cubit.dart';
import 'package:discryptor/cubits/name_cubit/name_cubit.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/start/password.dart';
import 'package:discryptor/views/start/start.dart';
import 'package:discryptor/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash';

  static Route<dynamic> route() {
    return MaterialPageRoute<SplashScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final nc = context.read<NameCubit>();
    nc.getUserFromPrefs().then((found) {
      if (found) {
        final ac = context.read<AuthCubit>();
        ac.resumeAuth().then((authenticated) {
          if (authenticated) {
            DiscryptorApp.navigatorKey.currentState!
                .pushAndRemoveUntil(PasswordScreen.route(), (route) => false);
          } else {
            DiscryptorApp.navigatorKey.currentState!
                .pushAndRemoveUntil(StartScreen.route(), (route) => false);
          }
        });
      } else {
        DiscryptorApp.navigatorKey.currentState!
            .pushAndRemoveUntil(StartScreen.route(), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      color: DiscryptorThemeData.backgroundColorDarker,
      child: Center(
          child: Image.asset('assets/images/discryptor_logo_v1_512_gray.png')),
    ));
  }
}
