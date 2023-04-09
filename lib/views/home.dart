import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/views/add/add.dart';
import 'package:discryptor/views/chat/chat.dart';
import 'package:discryptor/views/common/avatar_with_status.dart';
import 'package:discryptor/views/dialog/base_dialog.dart';
import 'package:discryptor/views/dialog/custom_dialog.dart';
import 'package:discryptor/views/profile/profile.dart';
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
              onPressed: () {
                const dlg = CustomDialog(
                    child: BaseDialog(
                  title: 'Start Conversation',
                  child: AddScreen(),
                ));
                showDialog(context: context, builder: (_) => dlg);
              },
              icon: const Icon(FluentIcons.add_20_filled)),
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Theme.of(context).dividerColor),
          ),
          title: GestureDetector(
              onTap: () {
                const dlg = CustomDialog(
                    child: BaseDialog(
                  title: 'Start Conversation',
                  child: AddScreen(),
                ));
                showDialog(context: context, builder: (_) => dlg);
              },
              child: const Text('Start Conversation')),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.transparent,
                    onRefresh: () => context.read<ChatListCubit>().loadChats(),
                    child: ListView.builder(
                        itemCount: state.chats.length,
                        itemBuilder: (context, index) => ChatListItem(
                            onPressed: () {
                              context
                                  .read<ChatListCubit>()
                                  .selectChat(state.chats[index]);
                              DiscryptorApp.navigatorKey.currentState!
                                  .pushNamed(ChatScreen.routeName);
                            },
                            onRelationshipButtonPressed: () {
                              final relStatus = getRelationshipStatus(
                                  state.chats[index].userVM.user);
                              if (relStatus ==
                                  RelationshipStatus.initiatedBySelf) {
                                context
                                    .read<ChatListCubit>()
                                    .updateRelationship(state.chats[index],
                                        RelationshipStatus.none);
                              } else if (relStatus ==
                                  RelationshipStatus.initiatedByOther) {
                                context
                                    .read<ChatListCubit>()
                                    .updateRelationship(state.chats[index],
                                        RelationshipStatus.accepted);
                              }
                            },
                            chatVM: state.chats[index])),
                  ),
                ),
                const Divider(height: 1, indent: 0, endIndent: 0),
                Material(
                    child: Center(
                        child: ElevatedButton(
                            onPressed: () {
                              context.read<LoginCubit>().logoff();
                              DiscryptorApp.navigatorKey.currentState!
                                  .pushAndRemoveUntil(
                                      PasswordScreen.route(), (route) => false);
                            },
                            child: const Text('Log off')))),
              ],
            ),
            if (state.status == ChatListStatus.busy)
              Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()))
          ],
        ),
      )),
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem(
      {required this.chatVM,
      this.onPressed,
      this.onRelationshipButtonPressed,
      super.key});

  final ChatViewModel chatVM;
  final Function()? onPressed;
  final Function()? onRelationshipButtonPressed;

  @override
  Widget build(BuildContext context) {
    final relStatus = getRelationshipStatus(chatVM.userVM.user);
    return RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        child: Opacity(
          opacity: relStatus == RelationshipStatus.accepted ? 1 : 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AvatarWithStatus(chatVM.userVM.user, onTap: () {
                      context
                          .read<ProfileCubit>()
                          .selectUser(chatVM.userVM.user);
                      DiscryptorApp.navigatorKey.currentState!
                          .push(ProfileScreen.route());
                    }),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        chatVM.userVM.user.username,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              if (relStatus != RelationshipStatus.accepted)
                IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 28,
                    onPressed: () async {
                      final dlg = CustomDialog(
                        child: BaseDialog(
                          title: 'Confirm action',
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "${relStatus == RelationshipStatus.initiatedBySelf ? 'Revoke friend request with' : 'Accept friend request from'} user ${chatVM.userVM.user.username}?",
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                        onPressed: () {
                                          onRelationshipButtonPressed!();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(relStatus ==
                                                RelationshipStatus
                                                    .initiatedBySelf
                                            ? 'Revoke Request'
                                            : 'Accept Friend')),
                                  ],
                                )
                              ]),
                        ),
                      );
                      await showDialog(context: context, builder: (c) => dlg);
                    },
                    color: Colors.white,
                    icon: Icon(relStatus == RelationshipStatus.initiatedBySelf
                        ? FluentIcons.clock_28_regular
                        : FluentIcons.hand_wave_24_regular))
            ],
          ),
        ));
  }
}
