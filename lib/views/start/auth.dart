import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/views/start/common/logo.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const String routeName = '/auth';

  static Route<dynamic> route() {
    return MaterialPageRoute<AuthScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const AuthScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChallengeCubit>().getChallenge();
    return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          //DiscryptorApp.navigatorKey.currentState!.push("");
          final userStatus = context.read<NameCubit>().state.result!.result;
          if (userStatus == UserPubSearchResultState.noCredentialsFound) {
            // handle
          } else if (userStatus == UserPubSearchResultState.found) {
            // handle
          }
        },
        listenWhen: (context, state) =>
            state.status == AuthStatus.authenticated,
        builder: (context, state) => Material(
                child: SafeArea(
              child: Column(children: [
                const Expanded(flex: 1, child: Center(child: Logo())),
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Authenticate ${context.read<NameCubit>().state.fullname} with Discord",
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                                'To authenticate with Discord, please send the below token as a private message to DiscryptorMessenger in Discord. Then press Authenticate.',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 32),
                            BlocBuilder<ChallengeCubit, ChallengeState>(
                              builder: (context, state) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onLongPress: () {
                                          Clipboard.setData(ClipboardData(
                                              text: context
                                                  .read<ChallengeCubit>()
                                                  .state
                                                  .challenge));
                                          Fluttertoast.showToast(
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              fontSize: 14.0,
                                              msg: "Copied to Clipboard");
                                        },
                                        child: Text(
                                          state.challengeString,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: TextButton(
                                            onPressed: () => context
                                                .read<ChallengeCubit>()
                                                .getChallenge(),
                                            style: const ButtonStyle(
                                                foregroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.white)),
                                            child: state.status ==
                                                    ChallengeStatus.fetching
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Colors.white70),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text('Renew Token'),
                                                      SizedBox(width: 4),
                                                      Icon(FluentIcons
                                                          .arrow_counterclockwise_20_filled)
                                                    ],
                                                  )))
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            state.status == AuthStatus.authenticating
                                ? const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () => context
                                        .read<AuthCubit>()
                                        .authenticate(),
                                    child: const SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: Center(
                                            child: Text('Authenticate')))),
                            ElevatedButton(
                                onPressed: () => DiscryptorApp
                                    .navigatorKey.currentState!
                                    .pop(),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context)
                                            .secondaryHeaderColor)),
                                child: const SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: Center(child: Text('Back')))),
                            const SizedBox(height: 32),
                            Text(state.error,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepOrange.shade700)),
                          ],
                        )))),
              ]),
            )));
  }
}
