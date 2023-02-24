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
      {super.key, this.discordStatus = 4, this.showBorder = true});

  final int discordStatus;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: showBorder ? 16 : 10,
      height: showBorder ? 16 : 10,
      decoration: BoxDecoration(
          border: showBorder ? Border.all(width: 3) : null,
          color: discordStatusToColor[discordStatus],
          shape: BoxShape.circle),
    );
  }
}
