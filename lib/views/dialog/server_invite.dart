import 'package:discryptor/cubits/cubits.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServerInviteDialog extends StatelessWidget {
  ServerInviteDialog({super.key});

  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    context.read<InviteCubit>().getLink();
    return BlocBuilder<InviteCubit, InviteState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Join the Server',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 1,
                        onPressed: () => Navigator.of(context).pop(),
                        style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white70)),
                        icon: const Icon(
                          FluentIcons.dismiss_20_filled,
                          color: Colors.white,
                          size: 20,
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                    "It looks like you aren't part of the official Discryptor server yet. To use Discryptor, this is necessary, as the Discryptor Messenger bot can only deliver encrypted messages between members of the same server.",
                    softWrap: true),
                const SizedBox(height: 16),
                const Text('Use the invite link below to join.',
                    softWrap: true),
                const SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.inviteLink),
                      TextButton(
                          onPressed: () =>
                              context.read<InviteCubit>().getLink(),
                          style: const ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white70)),
                          child: state.status == InviteStatus.busy
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white70),
                                )
                              : Row(
                                  children: const [
                                    Text('Refetch'),
                                    SizedBox(width: 4),
                                    Icon(FluentIcons
                                        .arrow_counterclockwise_20_filled)
                                  ],
                                ))
                    ]),
                const SizedBox(height: 8),
                StatefulBuilder(
                  builder: (context, setState) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: _copied
                            ? const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green))
                            : ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: state.inviteLink));
                          setState(() => _copied = true);
                          Future.delayed(const Duration(seconds: 2),
                              () => setState(() => _copied = false));
                        },
                        child: Text(
                            _copied ? 'Copied' : 'Copy Link to Clipboard')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
