import 'package:discryptor/cubits/cubits.dart';
import 'package:discryptor/extensions/datetime_ext.dart';
import 'package:discryptor/main.dart';
import 'package:discryptor/views/common/avatar_with_status.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route<dynamic> route() {
    return MaterialPageRoute<ProfileScreen>(
      settings: const RouteSettings(name: routeName),
      builder: (BuildContext context) => const ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => Scaffold(
                  body: Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(height: 128, color: Colors.black),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                                onPressed: DiscryptorApp
                                    .navigatorKey.currentState!.pop,
                                icon: const Icon(
                                  FluentIcons.chevron_left_24_filled,
                                  color: Colors.white70,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 68, left: 16),
                            child: AvatarWithStatus(
                              state.user!,
                              size: AvatarSize.big,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 128,
                        padding: const EdgeInsets.all(8),
                        margin:
                            const EdgeInsets.only(left: 16, right: 16, top: 24),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 10, color: Colors.transparent),
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(state.user!.username,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                Text(' #${state.user!.getDiscriminator}',
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.white54)),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 256,
                        padding: const EdgeInsets.all(8),
                        margin:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 10, color: Colors.transparent),
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('DISCORD MEMBER SINCE',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white70)),
                            const SizedBox(height: 12),
                            Text(formalTimeString(state.user!.getCreatedAt),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70))
                          ],
                        ),
                      )
                    ],
                  ),
                )));
  }
}
