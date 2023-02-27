import 'package:discryptor/cubits/statuses/statuses_cubit.dart';
import 'package:discryptor/models/idiscryptor_user.dart';
import 'package:discryptor/views/common/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AvatarSize { small, big }

class AvatarWithStatus extends StatelessWidget {
  const AvatarWithStatus(this.user,
      {super.key, this.onTap, this.size = AvatarSize.small});

  final IDiscryptorUser user;
  final Function()? onTap;
  final AvatarSize size;

  // definition of a size
  // radius, padding, statussize, statusbordersize

  @override
  Widget build(BuildContext context) {
    double symmPadding = size == AvatarSize.small ? 26 : 74;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: size == AvatarSize.big
                    ? Border.all(
                        width: 8,
                        color: Theme.of(context).scaffoldBackgroundColor)
                    : null,
                shape: BoxShape.circle),
            child: CircleAvatar(
              radius: size == AvatarSize.small ? 20 : 48,
              backgroundImage: NetworkImage(user.getUsedAvatarUrl),
            ),
          ),
          BlocBuilder<StatusesCubit, StatusesState>(
            builder: (context, state) {
              return Padding(
                  padding: EdgeInsets.only(top: symmPadding, left: symmPadding),
                  child: StatusIndicator(
                      size: size == AvatarSize.small ? 16 : 28,
                      borderWidth: size == AvatarSize.small ? 3 : 4,
                      discordStatus: state.statusByUserId(user.getId)));
            },
          )
        ],
      ),
    );
  }
}
