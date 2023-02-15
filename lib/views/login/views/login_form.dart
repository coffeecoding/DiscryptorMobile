import 'package:discryptor/cubits/login_cubit/login_cubit.dart';
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
            onChanged: (username) => {},
            decoration: InputDecoration(labelText: 'Username#0000')),
        const SizedBox(height: 16),
        TextField(
            controller: passwordController,
            onChanged: (username) => {},
            decoration: const InputDecoration(labelText: 'Password')),
        BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          if (state.status == LoginStatus.error) {
            return Text(state.message,
                style: const TextStyle(color: Colors.red));
          } else {
            return Container();
          }
        }),
        const SizedBox(height: 16),
        BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          switch (state.status) {
            case LoginStatus.busy:
              return const SizedBox(
                  height: 40, child: CircularProgressIndicator());
            default:
              return ElevatedButton(
                  onPressed: () => context
                      .read<LoginCubit>()
                      .login(usernameController.text, passwordController.text),
                  child: const SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Center(child: Text('Login'))));
          }
        }),
        const SizedBox(height: 64),
      ],
    )));
  }
}
