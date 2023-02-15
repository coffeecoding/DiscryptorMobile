import 'package:discryptor/config/custom_router.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cubits.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpLocator();

  runApp(const DiscryptorApp());
}

class DiscryptorApp extends StatelessWidget {
  const DiscryptorApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LoginCubit>(lazy: false, create: (context) => LoginCubit())
      ],
      child: MaterialApp(
        title: 'Discryptor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        navigatorKey: navigatorKey,
        onGenerateRoute: CustomRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
