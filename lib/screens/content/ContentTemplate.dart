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
        onTap: () {
          debugPrint("Adding to folder: ${folder.id}");
          folderActionsProvider.addMediaToFolder(
            folderId: folder.id,
            mediaItemIds: selectedFilesActions.selectedFileIds.toList(),
          );
          // Implement the logic to add selected items to this folder
        },
      );
    }).toList();
    dropdownItems.insert(
      0,
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
              onPressed: () {
                debugPrint('Removed from favorites');
                mediaActions.removeFromFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
                selectedFilesActions.toggleSelectionMode();
              },
            ),
          ] else ...[
            customToolbarItem(
              label: 'Add to favorites',
              iconData: CupertinoIcons.heart,
              onPressed: () {
                debugPrint('Add to favorites');
                mediaActions.addToFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
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
            onPressed: () async {
              debugPrint('Changing source...');
              await mediaActions.pickSourceDirectory();
              await folderActionsProvider.refreshFolders();
            },
          ),
          customToolbarItem(
            label: 'Rescan',
            iconData: CupertinoIcons.arrow_clockwise,
            onPressed: () {
              debugPrint('Rescanning directory...');
              mediaActions.rescanDirectory();
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
