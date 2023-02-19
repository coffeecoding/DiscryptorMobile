import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/models/user_pub_search_result.dart';
import 'package:discryptor/views/dialog/custom_dialog.dart';
import 'package:discryptor/views/dialog/server_invite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NameCubit, NameState>(
      listener: (context, state) async {
        if (state.result!.result == UserPubSearchResultState.notFound) {
          final dlg = CustomDialog(child: ServerInviteDialog());
          await showDialog(context: context, builder: (c) => dlg);
        }
        //DiscryptorApp.navigatorKey.currentState!.push("");
      },
      listenWhen: (context, state) => state.status == NameStatus.success,
      builder: (context, state) {
        return Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: usernameController,
                onChanged: (val) => context.read<NameCubit>().nameChanged(val),
                decoration: const InputDecoration(labelText: 'Username#0000')),
            const SizedBox(height: 32),
            state.status == NameStatus.busy
                ? const SizedBox(height: 40, child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () =>
                        context.read<NameCubit>().getUserAndContinue(),
                    child: const SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Center(child: Text('Continue')))),
            const SizedBox(height: 32),
            Text(state.message,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange.shade700)),
            const SizedBox(height: 64),
          ],
        )));
      },
    );
  }
}
