import 'package:discryptor/config/sample_data.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/chat/chat.dart';
import 'package:discryptor/views/common/status.dart';
import 'package:discryptor/views/start/password.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
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
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) => SafeArea(
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
        body: state.status == ChatListStatus.busy
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<ChatListCubit>().loadChats(),
                      child: ListView.builder(
                          itemCount: state.chats.length,
                          itemBuilder: (context, index) => RawMaterialButton(
                              onPressed: () {
                                context
                                    .read<ChatListCubit>()
                                    .selectChat(state.chats[index]);
                                DiscryptorApp.navigatorKey.currentState!
                                    .pushNamed(ChatScreen.routeName);
                              },
                              elevation: 2.0,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  AvatarWithStatus(state.chats[index].userVM),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(SampleData
                                        .sampleContacts[index].username),
                                  )
                                ],
                              ))),
                    ),
                  ),
                  const Divider(height: 1, indent: 0, endIndent: 0),
                  Material(
                      child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                context.read<LoginCubit>().logoff();
                                DiscryptorApp.navigatorKey.currentState!
                                    .pushAndRemoveUntil(PasswordScreen.route(),
                                        (route) => false);
                              },
                              child: const Text('Log off')))),
                ],
              ),
      )),
    );
  }
}

class AvatarWithStatus extends StatelessWidget {
  const AvatarWithStatus(this.userVM, {super.key});

  final UserViewModel userVM;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(userVM.avatarUrl),
        ),
        BlocBuilder<StatusesCubit, StatusesState>(
          builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.only(top: 26, left: 26),
                child: StatusIndicator(
                    discordStatus: state.statusByUserId(userVM.user.id)));
          },
        )
      ],
    );
  }
}
