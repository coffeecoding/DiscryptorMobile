import 'package:discryptor/config/sample_data.dart';
import 'package:discryptor/cubits/chat/chat_cubit.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/chat/chat.dart';
import 'package:discryptor/views/login/login.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  static Route<dynamic> route() {
    return MaterialPageRoute<HomeScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.initial) {
          DiscryptorApp.navigatorKey.currentState!
              .pushAndRemoveUntil(LoginScreen.route(), (route) => false);
        }
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {}, icon: const Icon(FluentIcons.add_20_filled)),
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Theme.of(context).dividerColor),
          ),
          title: const Text('Conversations'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: SampleData.sampleContacts.length,
                  itemBuilder: (context, index) => RawMaterialButton(
                      onPressed: () {
                        context.read<SelectedChatCubit>().selectChat(
                            ChatCubit(SampleData.sampleContacts[index]));
                        DiscryptorApp.navigatorKey.currentState!
                            .pushNamed(ChatScreen.routeName);
                      },
                      elevation: 2.0,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                SampleData.sampleContacts[index].usedAvatarUrl),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child:
                                Text(SampleData.sampleContacts[index].username),
                          )
                        ],
                      ))),
            ),
            const Divider(height: 1, indent: 0, endIndent: 0),
            Material(
                child: Center(
                    child: ElevatedButton(
                        onPressed: () => context.read<LoginCubit>().logout(),
                        child: const Text('Log out')))),
          ],
        ),
      )),
    );
  }
}
