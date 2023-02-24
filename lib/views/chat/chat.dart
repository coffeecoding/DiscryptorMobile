import 'package:discryptor/cubits/auth/auth_cubit.dart';
import 'package:discryptor/cubits/chat_list/chat_list_cubit.dart';
import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/cubitvms/message_vm.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/models/discryptor_user.dart';
import 'package:discryptor/models/idiscryptor_user.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:discryptor/extensions/datetime_ext.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static const String routeName = '/chat';

  static Route<dynamic> route() {
    return MaterialPageRoute<ChatScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => ChatScreen(),
    );
  }

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    ScrollController sctr = ScrollController(keepScrollOffset: true);
    TextEditingController ctr = TextEditingController();
    return SafeArea(
      child: BlocBuilder<SelectedChatCubit, SelectedChatState>(
        buildWhen: (prev, next) {
          return prev != next;
        },
        builder: (context, state) {
          final ac = context.read<AuthCubit>();
          DiscryptorUser self = ac.state.user!;
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: () =>
                        DiscryptorApp.navigatorKey.currentState!.pop(),
                    icon: const Icon(FluentIcons.arrow_left_20_filled)),
                titleSpacing: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                      height: 1, color: Theme.of(context).dividerColor),
                ),
                title: Text(state.chat!.userVM.user.username),
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  final clc = context.read<ChatListCubit>();
                  final scc = context.read<SelectedChatCubit>();
                  clc.loadChats().then((_) {
                    scc.selectChat(clc.state.chats.firstWhere(
                        (c) => c.userVM.user.id == state.chat!.userVM.user.id));
                    scc.refresh();
                  });
                  return Future.value();
                },
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: sctr,
                          itemCount: state.messages.length,
                          itemBuilder: (context, i) {
                            bool isPreviousSame = i == 0
                                ? true
                                : state.messages[i].message.authorId ==
                                    state.messages[i - 1].message.authorId;
                            return i == 0
                                ? ChatMessage(state.messages[i],
                                    user: (state.messages[i].isSelfSender
                                            ? self
                                            : state.chat!.userVM.user)
                                        as IDiscryptorUser)
                                : isPreviousSame
                                    ? ChatMessage(state.messages[i])
                                    : ChatMessage(state.messages[i],
                                        user: (state.messages[i].isSelfSender
                                                ? self
                                                : state.chat!.userVM.user)
                                            as IDiscryptorUser,
                                        isPreviousSelf: false);
                          }),
                    )),
                    const Divider(height: 1.0),
                    StatefulBuilder(
                      builder: (context, setState) => Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          child: Container(
                              margin: const EdgeInsets.only(left: 16, right: 8),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Material(
                                        child: TextField(
                                            controller: ctr,
                                            onChanged: (val) {
                                              context
                                                  .read<SelectedChatCubit>()
                                                  .messageFieldChanged(val);
                                              setState(() => _isComposing =
                                                  val.isEmpty ? false : true);
                                            },
                                            onSubmitted: (val) {},
                                            maxLines: 1,
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: 'Compose ...'))),
                                  ),
                                  IconButton(
                                      onPressed: !_isComposing ||
                                              state.status ==
                                                  SelectedChatStatus
                                                      .busySending ||
                                              ctr.text.isEmpty
                                          ? null
                                          : () => context
                                                  .read<SelectedChatCubit>()
                                                  .sendMessage(ctr.text)
                                                  .then((success) {
                                                if (success) {
                                                  ctr.text = '';
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    sctr.jumpTo(sctr.position
                                                        .maxScrollExtent);
                                                  });
                                                }
                                              }),
                                      splashRadius: 1,
                                      icon: const Icon(
                                          FluentIcons.send_20_filled))
                                ],
                              ))),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(this.messageVM,
      {super.key, this.user, this.isPreviousSelf = true});

  final IDiscryptorUser? user;
  final MessageViewModel messageVM;
  final bool isPreviousSelf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isPreviousSelf ? 0 : 16.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        user == null
            ? const SizedBox(width: 40)
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user!.usedAvatarUrl),
              ),
        const SizedBox(width: 12),
        Expanded(
            child: user == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(messageVM.message.content),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user!.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              relativeTimeString(messageVM.message.timestamp),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 10),
                            )
                          ]),
                      const SizedBox(height: 5),
                      Text(messageVM.message.content)
                    ],
                  ))
      ]),
    );
  }
}
