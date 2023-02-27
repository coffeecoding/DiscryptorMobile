import 'package:discryptor/config/locator.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/repos/auth_repo.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:discryptor/views/start/auth.dart';
import 'package:discryptor/views/start/password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/models/user_pub_search_result.dart';
import 'package:discryptor/views/dialog/custom_dialog.dart';
import 'package:discryptor/views/dialog/server_invite.dart';

import 'package:discryptor/views/start/common/logo.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  static const String routeName = '/start';

  static Route<dynamic> route() {
    return MaterialPageRoute<StartScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const StartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController =
        TextEditingController(text: context.read<NameCubit>().state.fullname);
    return BlocConsumer<NameCubit, NameState>(
        listener: (context, state) async {
          if (state.result!.result == UserPubSearchResultState.notFound) {
            final dlg = CustomDialog(child: ServerInviteDialog());
            await showDialog(context: context, builder: (c) => dlg);
          } else {
            final authTest = await context.read<AuthCubit>().resumeAuth();
            if (authTest) {
              DiscryptorApp.navigatorKey.currentState!
                  .push(PasswordScreen.route());
            } else {
              DiscryptorApp.navigatorKey.currentState!.push(AuthScreen.route());
            }
          }
        },
        listenWhen: (context, state) => state.status == NameStatus.success,
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
                          children: [
                            TextField(
                                controller: usernameController,
                                onChanged: (val) =>
                                    context.read<NameCubit>().nameChanged(val),
                                decoration: const InputDecoration(
                                    labelText: 'Username#0000')),
                            const SizedBox(height: 32),
                            state.status == NameStatus.busy
                                ? const SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () => context
                                        .read<NameCubit>()
                                        .getUserFromApi(),
                                    child: const SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child:
                                            Center(child: Text('Continue')))),
                            const SizedBox(height: 32),
                            Text(state.message,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.orange.shade700)),
                          ],
                        )))),
              ]),
            )));
  }
}
