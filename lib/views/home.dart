import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
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

import 'common/chat_listitem.dart';

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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                                final newStatus = relStatus ==
                                        RelationshipStatus.initiatedBySelf
                                    ? RelationshipStatus.none
                                    : relStatus ==
                                            RelationshipStatus.initiatedByOther
                                        ? RelationshipStatus.accepted
                                        : RelationshipStatus.initiatedBySelf;
                                context
                                    .read<ChatListCubit>()
                                    .updateRelationship(
                                        state.chats[index], newStatus);
                              },
                              chatVM: state.chats[index])),
                    ),
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
