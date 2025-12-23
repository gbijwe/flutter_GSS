import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/dialogs/favorites/AddedToFavoritesDialog.dart';
import 'package:photo_buddy/widgets/dialogs/folders/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/CustomDropdownToolbarItem.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class FolderTemplateWidget extends StatelessWidget {
  const FolderTemplateWidget({
    super.key,
    required this.title,
    required this.folderId,
    required this.children,
  });

  final String title;
  final int folderId;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<FileSystemMediaProvider>();
    final mediaActions = context.read<FileSystemMediaProvider>();
    final selectedFilesActions = context.watch<FileSelectionActionProvider>();
    final folderActionsProvider = context.read<FolderMediaProvider>();
    final folders = context.watch<FolderMediaProvider>().folders.toList();
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
                        'Are you sure you want to the selected ${selectedFilesActions.selectedFileIds.length} \nitems to “${folder.name}”?',
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
            builder: (context) => CreateFolderDialog(),
          );
        },
      ),
    );
    return Container(
      child: defaultToolBarScaffold(
        title: title,
        source: mediaProvider.currentPath ?? "No source selected",
        actions: [
          if (selectedFilesActions.selectionMode) ...[
            customToolbarItem(
              label: 'Delete from folder',
              iconData: CupertinoIcons.trash,
              color: MacosColors.appleRed,
              onPressed: () {
                debugPrint('Deleting from folder');
                folderActionsProvider.removeMediaFromFolder(
                  folderId: folderId,
                  mediaItemIds: selectedFilesActions.selectedFileIds.toList(),
                );
                selectedFilesActions.toggleSelectionMode();
              },
            ),
            customToolbarItem(
              label: 'View original',
              iconData: CupertinoIcons.sparkles,
              onPressed: (selectedFilesActions.selectedFileIds.length == 1)
                  ? () {
                      debugPrint('Opening in finder...');
                    }
                  : null,
            ),
            customToolbarItem(
              label: 'Add to favorites',
              iconData: CupertinoIcons.heart,
              onPressed: () async {
                debugPrint('Add to favorites');
                await mediaActions.addToFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
                if (context.mounted) {
                  await AddedToFavoritesDialog.show(
                    context, 
                    message: '${selectedFilesActions.selectedFileIds.length} items have been added to your Favourites section'
                  );
                }

                selectedFilesActions.toggleSelectionMode();
              },
            ),
            customDropdownToolbarItem(
              label: 'Add to folder',
              dropdownItems: dropdownItems,
              color: CupertinoColors.black,
            ),

            customToolbarItem(
              label: 'Cancel',
              iconData: CupertinoIcons.clear_circled,
              onPressed: () {
                debugPrint('Clearing selection...');
                selectedFilesActions.toggleSelectionMode();
              },
            ),
          ] else ...[
            customToolbarItem(
              label: 'View original',
              iconData: CupertinoIcons.sparkles,
              onPressed: (selectedFilesActions.selectedFileIds.length == 1)
                  ? () {
                      debugPrint('Opening in finder...');
                    }
                  : null,
            ),
            customToolbarItem(
              label: 'Select',
              onPressed: () {
                selectedFilesActions.toggleSelectionMode();
                debugPrint('Select pressed');
              },
            ),
          ],
        ],
        children: children,
      ),
    );
  }
}
