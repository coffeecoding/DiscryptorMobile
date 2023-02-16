import 'package:discryptor/cubits/selected_chat/selected_chat_cubit.dart';
import 'package:discryptor/main.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return SafeArea(
      child: BlocBuilder<SelectedChatCubit, SelectedChatState>(
        builder: (context, state) {
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
                title: Text(context
                    .read<SelectedChatCubit>()
                    .state
                    .chat!
                    .user
                    .username),
              ),
              body: Column(
                children: [
                  const Expanded(
                      child: Center(child: Text('Chat will be here'))),
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
                                          onChanged: (val) {
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
                                    onPressed: _isComposing ? () => {} : null,
                                    icon:
                                        const Icon(FluentIcons.send_20_filled))
                              ],
                            ))),
                  )
                ],
              ));
        },
      ),
    );
  }
}
