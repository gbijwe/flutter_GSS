import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/helpers/OpenFileInFinder.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/provider/NavigatorStateProvider.dart';
import 'package:photo_buddy/widgets/contextMenus/thumbnail/submenus/thumbnailFolderContextSubMenu.dart';
import 'package:photo_buddy/widgets/dialogs/favorites/AddedToFavoritesDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';
import 'package:photo_buddy/widgets/dialogs/favorites/RemovedFromFavoritesDialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

void showMediaThumbnailContextMenu(
  BuildContext context,
  Offset position,
  MediaItem file,
  ContextMenuController contextMenuController,
) {
  contextMenuController.show(
    context: context,
    contextMenuBuilder: (BuildContext context) {
      final selectionProvider = context.watch<FileSelectionActionProvider>();
      final folderActionsProvider = context.read<FolderMediaProvider>();
      final folders = context.watch<FolderMediaProvider>().folders.toList();
      final navigatorProvider = context.watch<NavigatorStateProvider>();

      final dropdownItems = folders.asMap().entries.map((entry) {
        final folder = entry.value;
        return PullDownMenuItem(
          title: folder.name,
          onTap: () async {
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
                          'Are you sure you want to the selected \nitems to “${folder.name}”?',
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
                                  mediaItemIds: [file.id],
                                );
                                debugPrint("Adding to folder: ${folder.id}");
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
        );
      }).toList();
      dropdownItems.add(
        PullDownMenuItem(
          title: 'Create new folder',
          enabled: true,
          onTap: () {
            showMacosAlertDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: MacosColors.black.withAlpha(30),
              builder: (context) => CreateFolderDialog(),
            );
          },
        ),
      );

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
                  openFileInFinder(file.path);
                },
                label: 'View Original',
              ),
              ContextMenuButtonItem(
                onPressed: () {
                  ContextMenuController.removeAny();
                  showThumbnailFolderContextSubMenu(
                    context,
                    position,
                    [file.id],
                    folderActionsProvider,
                    folders,
                  );
                },
                label: 'Add to folder',
              ),
              if (file.isFavorite) ...[
                ContextMenuButtonItem(
                  onPressed: () async {
                    ContextMenuController.removeAny();
                    await context
                        .read<FileSystemMediaProvider>()
                        .removeFromFavorites([file.id]);
                    if (context.mounted) {
                      await RemovedFromFavoritesDialog.show(
                        context,
                        message:
                            "The selected item has been removed Favorites.",
                      );
                    }
                  },
                  label: 'Remove from favorites',
                ),
              ] else ...[
                ContextMenuButtonItem(
                  onPressed: () async {
                    ContextMenuController.removeAny();
                    await context
                        .read<FileSystemMediaProvider>()
                        .addToFavorites([file.id]);
                    if (context.mounted) {
                      await AddedToFavoritesDialog.show(
                        context,
                        message:
                            "The selected item has been added to Favorites.",
                      );
                    }
                  },
                  label: 'Add to favorites',
                ),
              ],
              if (navigatorProvider.isFoldersView) ...[
                ContextMenuButtonItem(
                  onPressed: () {
                    ContextMenuController.removeAny();
                    folderActionsProvider.removeMediaFromFolder(
                      folderId: navigatorProvider.currentFolderId,
                      mediaItemIds: [file.id],
                    );
                  },
                  label: 'Delete from folder',
                ),
              ],
              ContextMenuButtonItem(
                onPressed: () {
                  ContextMenuController.removeAny();
                },
                label: 'View details',
              ),
            ],
          ),
        ),
      );
    },
  );
}
