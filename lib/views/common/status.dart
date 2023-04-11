import 'package:discryptor/views/theme.dart';
import 'package:flutter/material.dart';

const discordStatusToColor = {
  0: Colors.grey,
  1: Colors.red,
  2: Colors.orange,
  3: Colors.grey,
  4: Colors.grey,
  5: Colors.green
};

class StatusIndicator extends StatelessWidget {
  const StatusIndicator(
      {super.key,
      this.discordStatus = 4,
      this.showBorder = true,
      this.size = 16,
      this.borderWidth = 3});

  final int discordStatus;
  final bool showBorder;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            border: showBorder ? Border.all(width: borderWidth) : null,
            color: discordStatusToColor[discordStatus],
            shape: BoxShape.circle),
      ),
      if (discordStatus == 0 || discordStatus == 3 || discordStatus == 4)
        Container(
          width: size == 10 ? 5 : size / 3,
          height: size == 10 ? 5 : size / 3,
          decoration: BoxDecoration(
              border: Border.all(width: size <= 16 ? 4 : 7),
              color: DiscryptorThemeData.backgroundColor,
              shape: BoxShape.circle),
        ),
    ]);
  }
}
