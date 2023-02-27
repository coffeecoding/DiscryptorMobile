import 'package:discryptor/views/chat/chat.dart';
import 'package:discryptor/views/home.dart';
import 'package:discryptor/views/profile/profile.dart';
import 'package:discryptor/views/start/auth.dart';
import 'package:discryptor/views/start/password.dart';
import 'package:discryptor/views/splash.dart';
import 'package:discryptor/views/start/register.dart';
import 'package:discryptor/views/start/start.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case PasswordScreen.routeName:
        return PasswordScreen.route();
      case StartScreen.routeName:
        return StartScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();
      case AuthScreen.routeName:
        return AuthScreen.route();
      case RegisterScreen.routeName:
        return RegisterScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
