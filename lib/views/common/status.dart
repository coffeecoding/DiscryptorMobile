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
  const StatusIndicator({super.key, this.discordStatus = 4});

  final int discordStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          border: Border.all(width: 3),
          color: discordStatusToColor[discordStatus],
          shape: BoxShape.circle),
    );
  }
}
