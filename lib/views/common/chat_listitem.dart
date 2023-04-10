import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/cubitvms/chat_vm.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/models/models.dart';
import 'package:discryptor/views/common/avatar_with_status.dart';
import 'package:discryptor/views/dialog/base_dialog.dart';
import 'package:discryptor/views/dialog/custom_dialog.dart';
import 'package:discryptor/views/profile/profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem(
      {required this.chatVM,
      this.onPressed,
      this.onRelationshipButtonPressed,
      this.opacity = 0.5,
      super.key});

  final ChatViewModel chatVM;
  final Function()? onPressed;
  final Function()? onRelationshipButtonPressed;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final relStatus = getRelationshipStatus(chatVM.userVM.user);
    return RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        child: Opacity(
          opacity: relStatus == RelationshipStatus.accepted ? 1 : opacity,
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
                          title: relStatus == RelationshipStatus.none
                              ? 'Add user'
                              : 'Pending friend request',
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "${relStatus == RelationshipStatus.initiatedBySelf ? 'Revoke friend request for' : relStatus == RelationshipStatus.initiatedByOther ? 'Accept friend request from' : 'Add'} ${chatVM.userVM.user.username}#${chatVM.userVM.user.discriminator}?",
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
                                            ? 'Revoke'
                                            : relStatus ==
                                                    RelationshipStatus
                                                        .initiatedByOther
                                                ? 'Accept'
                                                : 'Add')),
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
                        : relStatus == RelationshipStatus.initiatedByOther
                            ? FluentIcons.hand_wave_24_regular
                            : FluentIcons.person_add_24_filled))
            ],
          ),
        ));
  }
}
