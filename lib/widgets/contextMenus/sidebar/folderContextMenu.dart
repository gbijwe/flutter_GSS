import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/widgets/dialogs/folders/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/RenameFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/DeleteFolderDialog.dart';

void showSidebarFolderContextMenu(
    BuildContext context,
    Offset position,
    int folderId,
    String folderName,
    ContextMenuController contextMenuController
  ) {
    contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return TapRegion(
          onTapOutside: (event) {
            contextMenuController.remove();
          },
          child: Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                contextMenuController.remove();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: AdaptiveTextSelectionToolbar.buttonItems(
              anchors: TextSelectionToolbarAnchors(primaryAnchor: position),
              buttonItems: <ContextMenuButtonItem>[
                ContextMenuButtonItem(
                  onPressed: () {
                    ContextMenuController.removeAny();
                    showMacosAlertDialog(
                      context: context,
                      builder: (context) => CreateFolderDialog(),
                      barrierDismissible: true,
                    );
                  },
                  label: 'Create Folder',
                ),
                ContextMenuButtonItem(
                  onPressed: () {
                    ContextMenuController.removeAny();
                    showMacosAlertDialog(
                      context: context,
                      barrierColor: MacosColors.black.withAlpha(30),
                      barrierDismissible: true,
                      builder: (context) => RenameFolderDialog(
                        folderId: folderId,
                        folderName: folderName,
                      ),
                    );
                  },
                  label: 'Rename Folder',
                ),
                ContextMenuButtonItem(
                  onPressed: () {
                    ContextMenuController.removeAny();
                    DeleteFolderDialog.show(context, folderId);
                  },
                  label: 'Delete Folder',
                ),
              ],
            ),
          ),
        );
      },
    );
  }