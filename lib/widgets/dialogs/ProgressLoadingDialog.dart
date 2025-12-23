import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/widgets/dialogs/GaussianBlurDialog.dart';
import 'package:provider/provider.dart';

class ProgressLoadingDialog {
  /// Shows a loading dialog for FileSystemMediaProvider operations
  static void showForMedia({
    required BuildContext context,
    required Future<void> Function() operation,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: MacosColors.black.withOpacity(0.3),
      builder: (dialogContext) => Consumer<FileSystemMediaProvider>(
        builder: (context, provider, child) {
          // Auto-close dialog when done
          if (!provider.isLoading && Navigator.of(dialogContext).canPop()) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
                showMacosAlertDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: MacosColors.black.withAlpha(30),
                  builder: (context) {
                    return GaussianBlurDialog(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 22.0,
                          right: 22.0,
                          bottom: 16.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Rescanning done",
                              style: TextStyle(
                                color: MacosColors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 23),
                            AdaptiveButton(
                              label: "Alright!",
                              style: AdaptiveButtonStyle.filled,
                              color: MacosColors.white,
                              textColor: MacosColors.black,
                              onPressed: () {
                                if (context.mounted)
                                  Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                // Show error if any
                if (provider.hasError && provider.errorMessage != null) {
                  _showErrorDialog(context, provider.errorMessage!, () {
                    provider.clearError();
                  });
                }
              }
            });
          }

          return buildProgressDialog(
            operation: provider.currentOperation,
            progress: provider.progress,
          );
        },
      ),
    );

    // Execute the operation
    operation();
  }

  /// Shows a loading dialog for FolderMediaProvider operations
  static void showForFolder({
    required BuildContext context,
    required Future<void> Function() operation,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: MacosColors.black.withOpacity(0.3),
      builder: (dialogContext) => Consumer<FolderMediaProvider>(
        builder: (context, provider, child) {
          // Auto-close dialog when done
          if (!provider.isLoading && Navigator.of(dialogContext).canPop()) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();

                // Show error if any
                if (provider.hasError && provider.errorMessage != null) {
                  _showErrorDialog(context, provider.errorMessage!, () {
                    provider.clearError();
                  });
                }
              }
            });
          }

          return buildProgressDialog(
            operation: provider.currentOperation,
            progress: provider.progress,
          );
        },
      ),
    );

    // Execute the operation
    operation();
  }

  static Widget buildProgressDialog({
    required String operation,
    required double progress,
  }) {
    return GaussianBlurDialog(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 22.0,
          left: 22.0,
          right: 22.0,
          bottom: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              operation,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: MacosColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: MacosColors.systemGrayColor.withAlpha(30),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  MacosColors.systemBlueColor,
                ),
                minHeight: 10,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showErrorDialog(
    BuildContext context,
    String error,
    VoidCallback onDismiss,
  ) {
    showMacosAlertDialog(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: const MacosIcon(CupertinoIcons.exclamationmark_triangle),
        title: const Text('Error'),
        message: Text(error),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          child: const Text('OK'),
          onPressed: () {
            onDismiss();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
