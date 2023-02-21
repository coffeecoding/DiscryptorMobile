import 'package:discryptor/main.dart';
import 'package:discryptor/views/home.dart';
import 'package:discryptor/views/start/common/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:discryptor/cubits/cubits.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  static Route<dynamic> route() {
    return MaterialPageRoute<RegisterScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const RegisterScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          DiscryptorApp.navigatorKey.currentState!.push(HomeScreen.route());
        },
        listenWhen: (context, state) => state.status == RegisterStatus.success,
        builder: (context, state) {
          final TextEditingController passwordCtr =
              TextEditingController(text: state.password);
          final TextEditingController passwordConfirmCtr =
              TextEditingController(text: state.confirmedPassword);
          return Material(
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
                            "Welcome ${context.read<NameCubit>().state.fullname.split('#')[0]}!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                              'You are one step away from chatting! That last step is to generate your encryption keys by entering a strong password. You only have to do this once.',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          const Text(
                              'Make sure to save your password securely, as we do not store it. It cannot be reset or restored!',
                              style: TextStyle(color: Colors.amber),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 32),
                          TextField(
                              obscureText: true,
                              controller: passwordCtr,
                              autofocus: true,
                              onChanged: (val) => context
                                  .read<RegisterCubit>()
                                  .passwordChanged(val),
                              decoration:
                                  const InputDecoration(labelText: 'Password')),
                          TextField(
                              obscureText: true,
                              controller: passwordConfirmCtr,
                              autofocus: true,
                              onChanged: (val) => context
                                  .read<RegisterCubit>()
                                  .confirmedPwChanged(val),
                              decoration: const InputDecoration(
                                  labelText: 'Confirm Password')),
                          const SizedBox(height: 32),
                          state.status == RegisterStatus.busy
                              ? const SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: () =>
                                      context.read<RegisterCubit>().register(),
                                  child: const SizedBox(
                                      width: double.infinity,
                                      height: 40,
                                      child: Center(
                                          child: Text(
                                              'Generate keys and login')))),
                          ElevatedButton(
                              onPressed: () => DiscryptorApp
                                  .navigatorKey.currentState!
                                  .pop(),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).secondaryHeaderColor)),
                              child: const SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: Center(child: Text('Back')))),
                          const SizedBox(height: 32),
                          Text(state.error,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.deepOrange.shade700)),
                        ],
                      )))),
            ]),
          ));
        });
  }
}
