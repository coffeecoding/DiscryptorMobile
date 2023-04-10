import 'package:discryptor/cubits/add/add_cubit.dart';
import 'package:discryptor/cubits/chat_list/chat_list_cubit.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/cubitvms/user_vm.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/views/common/chat_listitem.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  static const String routeName = '/add';

  static Route<dynamic> route() {
    return MaterialPageRoute<AddScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const AddScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctr = TextEditingController();
    return BlocBuilder<AddCubit, AddState>(
      builder: (context, state) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    autofocus: true,
                    controller: ctr,
                    onChanged: (val) =>
                        context.read<AddCubit>().inputChanged(val),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: Colors.black26,
                      hintText: 'Username#1234',
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              state.status == AddStatus.busy
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => context.read<AddCubit>().executeSearch(),
                      child: const Text('Search')),
            ],
          ),
          const SizedBox(height: 16),
          state.result == null
              ? const Text('')
              : GestureDetector(
                  onDoubleTap: () {
                    final chatVM = ChatViewModel(state.result!);
                    context.read<ChatListCubit>().addChat(chatVM);
                    Navigator.of(context).pop();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                        child: ChatListItem(
                            chatVM: ChatViewModel(state.result!),
                            onPressed: () {},
                            onRelationshipButtonPressed: () {
                              final clc = context.read<ChatListCubit>();
                              final relStatus =
                                  getRelationshipStatus(state.result!.user);
                              final newStatus = relStatus ==
                                      RelationshipStatus.initiatedBySelf
                                  ? RelationshipStatus.none
                                  : relStatus ==
                                          RelationshipStatus.initiatedByOther
                                      ? RelationshipStatus.accepted
                                      : RelationshipStatus.initiatedBySelf;
                              final chatVM = ChatViewModel(state.result!);
                              clc.updateRelationship(chatVM, newStatus);
                              if (newStatus != RelationshipStatus.none) {
                                clc.addChat(chatVM);
                              }
                              Navigator.of(context).pop();
                            },
                            opacity: 1)),
                  ),
                ),
          if (state.error.isNotEmpty) const SizedBox(height: 24),
          if (state.error.isNotEmpty)
            Text(state.error,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange.shade500)),
        ],
      ),
    );
  }
}
