import 'dart:ui';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:provider/provider.dart';

class DeleteFolderDialog {
  static Future<void> show(BuildContext context, int folderId) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(30),
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
        content: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            color: MacosColors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete this folder permanently?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to delete the\nselected folder?\nThis action is irreversible.',
                style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w400),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: MacosColors.systemRedColor.withAlpha(23),
                //     foregroundColor: MacosColors.systemRedColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //     elevation: 0,
                //   ),
                //   onPressed: () async {
                //     await context.read<FolderMediaProvider>().deleteFolder(
                //       folderId,
                //     );
                //     if (context.mounted) Navigator.of(context).pop();
                //   },
                //   child: const Text(
                //     'Delete this folder',
                //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                //   ),
                // ),
                child: AdaptiveButton(
                  label: 'Delete this folder',
                  style: AdaptiveButtonStyle.glass,
                  color: MacosColors.systemRedColor,
                  onPressed: () async {
                    await context.read<FolderMediaProvider>().deleteFolder(
                      folderId,
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                // child: ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //     elevation: 0,
                //   ),
                //   onPressed: () => Navigator.of(context).pop(),
                //   child: const Text(
                //     'Cancel',
                //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                //   ),
                // ),
                child: AdaptiveButton(
                  label: "Cancel",
                  style: AdaptiveButtonStyle.filled,
                  onPressed: () => Navigator.of(context).pop(),
                  color: MacosColors.white,
                  textColor: MacosColors.black,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_buddy/provider/FolderMediaProvider.dart';
// import 'package:provider/provider.dart';

// class DeleteFolderDialog {
//   static Future<void> show(BuildContext context, int folderId) async {
//     return AdaptiveAlertDialog.show(
//       context: context,
//       title: 'Delete this folder permanently?',
//       message:
//           'Are you sure you want to delete the\nselected folder?\nThis action is irreversible.',
//       actions: [
//         AlertAction(
//           title: 'Delete this folder',
//           onPressed: () async {
//             await context.read<FolderMediaProvider>().deleteFolder(folderId);
//             if (context.mounted) Navigator.of(context).pop();
//           },
//         ),
//         AlertAction(
//           title: 'Cancel',
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
