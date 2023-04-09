import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
                IconButton(
                    padding: const EdgeInsets.only(left: 16),
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
            child,
          ],
        ),
      ),
    );
  }
}
