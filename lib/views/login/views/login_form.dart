import 'package:discryptor/cubits/login_cubit/login_cubit.dart';
import 'package:discryptor/main.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
            controller: usernameController,
            onChanged: (val) => context.read<LoginCubit>().usernameChanged(val),
            decoration: const InputDecoration(labelText: 'Username#0000')),
        const SizedBox(height: 32),
        BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          switch (state.status) {
            case LoginStatus.busy:
              return const SizedBox(
                  height: 40, child: CircularProgressIndicator());
            default:
              return ElevatedButton(
                  onPressed: () =>
                      DiscryptorApp.navigatorKey.currentState!.push(""),
                  child: const SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Center(child: Text('Continue'))));
          }
        }),
        const SizedBox(height: 64),
      ],
    )));
  }
}
