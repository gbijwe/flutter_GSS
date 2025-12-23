import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class GaussianBlurDialog extends StatelessWidget {
  const GaussianBlurDialog({
    super.key,
    required this.child,
    this.borderRadius = 26.0,
    this.blurSigmaX = 2.0,
    this.blurSigmaY = 2.0,
    this.backgroundColor,
    this.borderColor = MacosColors.white,
    this.borderWidth = 2.0,
    this.contentPadding = const EdgeInsets.all(0.0),
  });

  final Widget child;
  final double borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: backgroundColor ?? MacosColors.white.withAlpha(220),
      surfaceTintColor: Colors.white,
      content: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border(
            top: BorderSide(
              width: borderWidth,
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            left: BorderSide(
              width: borderWidth,
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            right: BorderSide(
              width: borderWidth,
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            bottom: BorderSide(
              width: borderWidth,
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
          child: Padding(
            padding: contentPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}