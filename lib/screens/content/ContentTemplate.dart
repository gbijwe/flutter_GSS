import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/provider/NavigatorStateProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/dialogs/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/CustomDropdownToolbarItem.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
import 'package:photo_buddy/widgets/dialogs/GaussianBlurDialog.dart';
import 'package:photo_buddy/widgets/dialogs/ProgressLoadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ContentTemplateWidget extends StatelessWidget {
  const ContentTemplateWidget({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<FileSystemMediaProvider>();
    final mediaActions = context
        .read<
          FileSystemMediaProvider
        >(); // will not cause rebuilds on button presses
    final selectedFilesActions = context.watch<FileSelectionActionProvider>();
    final folderActionsProvider = context.read<FolderMediaProvider>();
    final folders = context.watch<FolderMediaProvider>().folders.toList();
    final navigatorStateProvider = context.watch<NavigatorStateProvider>();

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
                        ' Are you sure you want to the selected ${selectedFilesActions.selectedFileIds.length} \nitems to “${folder.name}”?',
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
                              if (context.mounted) Navigator.of(context).pop();
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
                                mediaItemIds: selectedFilesActions
                                    .selectedFileIds
                                    .toList(),
                              );
                              debugPrint("Adding to folder: ${folder.id}");
                              selectedFilesActions.toggleSelectionMode();
                              if (context.mounted) Navigator.of(context).pop();
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

    return defaultToolBarScaffold(
      title: title,
      source: mediaProvider.currentPath ?? "No source selected",
      actions: [
        if (selectedFilesActions.selectionMode) ...[
          customToolbarItem(
            label: 'View original',
            iconData: CupertinoIcons.sparkles,
            onPressed: (selectedFilesActions.selectedFileIds.length == 1)
                ? () {
                    debugPrint('Opening in finder...');
                  }
                : null,
          ),
          if (navigatorStateProvider.isFavoritesView()) ...[
            customToolbarItem(
              label: 'Remove from favorites',
              iconData: CupertinoIcons.heart_slash,
              onPressed: () async {
                debugPrint('Removed from favorites');
                await mediaActions.removeFromFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
                if (context.mounted) {
                  await showMacosAlertDialog(
                    context: context,
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
                            const Text(
                              'Removed from favorites',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: MacosColors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${selectedFilesActions.selectedFileIds.length} files removed from favorites',
                              style: TextStyle(
                                fontSize: 11,
                                color: MacosColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: AdaptiveButton(
                                label: 'Alright!',
                                style: AdaptiveButtonStyle.glass,
                                color: MacosColors.black,
                                onPressed: () {
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                selectedFilesActions.toggleSelectionMode();
              },
            ),
          ] else ...[
            customToolbarItem(
              label: 'Add to favorites',
              iconData: CupertinoIcons.heart,
              onPressed: () async {
                debugPrint('Add to favorites');
                await mediaActions.addToFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Added to favorites',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: MacosColors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 4),
                                MacosIcon(
                                  CupertinoIcons.heart_fill,
                                  color: MacosColors.black,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${selectedFilesActions.selectedFileIds.length} items have been added to your Favourites section',
                              style: TextStyle(
                                fontSize: 11,
                                color: MacosColors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: AdaptiveButton(
                                label: 'Alright!',
                                style: AdaptiveButtonStyle.glass,
                                color: MacosColors.black,
                                onPressed: () {
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                selectedFilesActions.toggleSelectionMode();
              },
            ),
          ],
          customDropdownToolbarItem(
            label: 'Add to folder',
            iconData: CupertinoIcons.folder,
            dropdownItems: dropdownItems,
            color: CupertinoColors.black,
          ),
          customToolbarItem(
            label: 'Cancel',
            onPressed: () {
              debugPrint('Clearing selection...');
              selectedFilesActions.toggleSelectionMode();
            },
          ),
        ] else ...[
          customToolbarItem(
            label: 'Select Source',
            iconData: CupertinoIcons.folder_badge_plus,
            onPressed: () {
              debugPrint('Changing source...');
              ProgressLoadingDialog.showForMedia(
                context: context,
                operation: () async {
                  await mediaActions.pickSourceDirectory();
                  await folderActionsProvider.refreshFolders();
                },
              );
            },
          ),
          customToolbarItem(
            label: 'Rescan',
            iconData: CupertinoIcons.arrow_clockwise,
            onPressed: () async {
              debugPrint('Rescanning directory...');
              ProgressLoadingDialog.showForMedia(
                context: context,
                operation: () => mediaActions.rescanDirectory(),
              );
              
            },
          ),
          customToolbarItem(
            label: 'Select',
            onPressed: () {
              debugPrint('Select pressed');
              selectedFilesActions.toggleSelectionMode();
            },
          ),
        ],
      ],
      children: children,
    );
  }
}
