import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/widgets/dialogs/GaussianBlurDialog.dart';

class LoadingDialog {
  static Future<void> show(
    BuildContext context, {
    String message = 'Loading the media...',
    double? progress,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(30),
      builder: (context) => GaussianBlurDialog(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20,
            right: 20,
            bottom: 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 300,
                child: progress != null
                    ? LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[400],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          MacosColors.systemBlueColor,
                        ),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(100),
                      )
                    : LinearProgressIndicator(
                        backgroundColor: Colors.grey[400],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(100),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
