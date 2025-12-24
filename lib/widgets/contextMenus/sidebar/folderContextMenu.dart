import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/widgets/dialogs/folders/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/RenameFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/DeleteFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';
import 'package:provider/provider.dart';

void showSidebarFolderContextMenu(
  BuildContext context,
  Offset position,
  int folderId,
  String folderName,
  ContextMenuController contextMenuController,
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
                    barrierColor: MacosColors.black.withAlpha(30),
                  );
                },
                label: 'Create Folder',
              ),
              ContextMenuButtonItem(
                onPressed: () {
                  ContextMenuController.removeAny();
                  showMacosAlertDialog(
                    context: context,
                    builder: (context) => GaussianBlurDialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Are you sure you want to duplicate the folder \"$folderName\"?",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AdaptiveButton(
                                onPressed: () async {
                                  final folderActions = context
                                      .read<FolderMediaProvider>();
                                  await folderActions.duplicateFolder(
                                    folderId: folderId,
                                  );
                                  if (context.mounted) Navigator.of(context).pop();
                                  if (context.mounted) {
                                    if (folderActions.hasError) {
                                      showMacosAlertDialog(
                                        context: context,
                                        barrierColor: MacosColors.black.withAlpha(30),
                                        builder: (context) {
                                          return GaussianBlurDialog(
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
                                                    "Couldn't duplicate the folder",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: MacosColors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  if (folderActions
                                                          .errorMessage !=
                                                      null) ...[
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      folderActions
                                                          .errorMessage!,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            MacosColors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                  const SizedBox(height: 18),
                                                  AdaptiveButton(
                                                    label: "Alright!",
                                                    style: AdaptiveButtonStyle
                                                        .filled,
                                                    onPressed: () {
                                                      folderActions
                                                          .clearError();
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    color: MacosColors.white,
                                                    textColor:
                                                        MacosColors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                label: 'Yes',
                              ),
                              AdaptiveButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                label: 'No',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    barrierDismissible: true,
                    barrierColor: MacosColors.black.withAlpha(30),
                  );
                },
                label: 'Duplicate Folder',
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
