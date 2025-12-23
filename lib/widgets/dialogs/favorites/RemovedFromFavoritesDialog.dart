import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';

class RemovedFromFavoritesDialog {
  static Future<void> show(
    BuildContext context, {
    required String message,
  }) async {
    return showDialog(
      context: context,
      barrierColor: MacosColors.black.withAlpha(30),
      barrierDismissible: true,
      builder: (context) => GaussianBlurDialog(
        contentPadding: const EdgeInsets.only(
          top: 20,
          left: 22,
          right: 22,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Removed from favorites',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: MacosColors.black,
                  ),
                ),
                SizedBox(width: 4),
                MacosIcon(
                  CupertinoIcons.heart_slash_fill,
                  color: MacosColors.black,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 11,
                color: MacosColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AdaptiveButton(
                label: 'Alright!',
                style: AdaptiveButtonStyle.glass,
                color: MacosColors.black,
                onPressed: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
