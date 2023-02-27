import 'package:flutter/material.dart';

const discordStatusToColor = {
  0: Colors.orange,
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: showBorder ? Border.all(width: borderWidth) : null,
          color: discordStatusToColor[discordStatus],
          shape: BoxShape.circle),
    );
  }
}
