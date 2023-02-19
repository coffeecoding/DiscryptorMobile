import 'package:flutter/material.dart';

class CustomDialog extends Dialog {
  const CustomDialog({super.key, required Widget child})
      : super(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: child);
}
