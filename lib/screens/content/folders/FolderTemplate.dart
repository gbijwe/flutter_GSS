import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/dialogs/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/CustomDropdownToolbarItem.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
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
        onTap: () {
          debugPrint("Adding to folder: ${folder.id}");
          folderActionsProvider.addMediaToFolder(folderId: folder.id, mediaItemIds: selectedFilesActions.selectedFileIds.toList());
          // Implement the logic to add selected items to this folder
        },
      );
    }).toList();
    dropdownItems.add(
      PullDownMenuItem(
        title: 'Create new folder',
        enabled: true,
        onTap: () {
          showMacosAlertDialog(context: context, builder: (context) => CreateFolderDialog());
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
              onPressed: () {
                debugPrint('Add to favorites');
                mediaActions.addToFavorites(
                  selectedFilesActions.selectedFileIds.toList(),
                );
                selectedFilesActions.toggleSelectionMode();
              },
            ),
            customDropdownToolbarItem(
              label: 'Add to folder', 
              dropdownItems: dropdownItems, color: CupertinoColors.black),
            
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
