import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/widgets/dialogs/folders/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';

void showThumbnailFolderContextSubMenu(
  BuildContext context,
  Offset position,
  List<int> selectedItems,
  FolderMediaProvider folderActionsProvider,
  List folders,
) {
  final submenuController = ContextMenuController();

  // Calculate submenu position (to the right of the main menu)
  final submenuPosition = Offset(position.dx, position.dy);

  submenuController.show(
    context: context,
    contextMenuBuilder: (BuildContext context) {
      return TapRegion(
        onTapOutside: (event) {
          submenuController.remove();
        },
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              submenuController.remove();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: AdaptiveTextSelectionToolbar.buttonItems(
            anchors: TextSelectionToolbarAnchors(
              primaryAnchor: submenuPosition,
            ),
            buttonItems: [
              ...folders.map((folder) {
                return ContextMenuButtonItem(
                  onPressed: () async {
                    ContextMenuController.removeAny();
                    if (context.mounted) {
                      await showMacosAlertDialog(
                        context: context,
                        barrierColor: MacosColors.black.withAlpha(30),
                        barrierDismissible: true,
                        builder: (context) {
                          return GaussianBlurDialog(
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
                                Text(
                                  "Add to '${folder.name}'",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: MacosColors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Are you sure you want to the selected \nitem to “${folder.name}”?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: MacosColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AdaptiveButton(
                                      label: 'Cancel',
                                      style: AdaptiveButtonStyle.glass,
                                      color: MacosColors.white,
                                      textColor: MacosColors.black,
                                      onPressed: () {
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    AdaptiveButton(
                                      label: 'Add to folder',
                                      style: AdaptiveButtonStyle.filled,
                                      color: MacosColors.systemBlueColor,
                                      textColor: MacosColors.white,
                                      onPressed: () {
                                        folderActionsProvider.addMediaToFolder(
                                          folderId: folder.id,
                                          mediaItemIds: selectedItems,
                                        );
                                        debugPrint(
                                          "Adding to folder: ${folder.id}",
                                        );
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  label: folder.name,
                );
              }),
              ContextMenuButtonItem(
                onPressed: () {
                  ContextMenuController.removeAny();
                  showMacosAlertDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: MacosColors.black.withAlpha(30),
                    builder: (context) => CreateFolderDialog(),
                  );
                },
                label: 'Create new folder...',
              ),
            ],
          ),
        ),
      );
    },
  );
}
