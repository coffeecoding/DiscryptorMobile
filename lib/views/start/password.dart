import 'package:discryptor/main.dart';
import 'package:discryptor/views/start/common/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/models/user_pub_search_result.dart';
import 'package:discryptor/views/dialog/custom_dialog.dart';
import 'package:discryptor/views/dialog/server_invite.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  static const String routeName = '/password';

  static Route<dynamic> route() {
    return MaterialPageRoute<PasswordScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const PasswordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordCtr = TextEditingController();
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          //DiscryptorApp.navigatorKey.currentState!.push("");
        },
        listenWhen: (context, state) => state.status == LoginStatus.loggedIn,
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
                            Text(
                              'Enter password for ${context.read<NameCubit>().state.fullname}',
                            ),
                            const SizedBox(height: 32),
                            TextField(
                                controller: passwordCtr,
                                onChanged: (val) => context
                                    .read<LoginCubit>()
                                    .passwordChanged(val),
                                decoration: const InputDecoration(
                                    labelText: 'Password')),
                            const SizedBox(height: 32),
                            state.status == LoginStatus.busy
                                ? const SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () =>
                                        context.read<LoginCubit>().login(),
                                    child: const SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: Center(child: Text('Unlock')))),
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
                            Text(state.message,
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
