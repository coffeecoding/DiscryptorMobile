import 'package:discryptor/config/custom_router.dart';
import 'package:discryptor/config/locator.dart';
import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cubits.dart';
import 'services/services.dart';

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
        BlocProvider<SelectedChatCubit>(
            lazy: false, create: ((context) => SelectedChatCubit())),
        BlocProvider<ChatListCubit>(
          lazy: false,
          create: ((context) =>
              ChatListCubit(context.read<SelectedChatCubit>())),
        ),
        BlocProvider<AuthCubit>(
            lazy: false,
            create: (context) => AuthCubit(locator.get<PreferenceRepo>(),
                locator.get<AuthRepo>(), locator.get<ChallengeCubit>())),
        BlocProvider<AppCubit>(
          lazy: false,
          create: (context) => AppCubit(context.read<ChatListCubit>()),
        ),
        BlocProvider<LoginCubit>(
            lazy: false,
            create: (context) => LoginCubit(
                context.read<AuthCubit>(), context.read<AppCubit>())),
      ],
      child: MaterialApp(
        title: 'Discryptor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF5865f2),
          primarySwatch: const MaterialColor(0xFF5865f2, {
            50: Color(0x4F5865f2),
            100: Color(0x6F5865f2),
            200: Color(0x8F5865f2),
            300: Color(0xAF5865f2),
            400: Color(0xCF5865f2),
            500: Color(0xFF5865f2),
            600: Color(0xFF5865f2),
            700: Color(0xFF5865f2),
            800: Color(0xFF5865f2),
            900: Color(0xFF5865f2),
          }),
        ),
        themeMode: ThemeMode.dark,
        navigatorKey: navigatorKey,
        onGenerateRoute: CustomRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
