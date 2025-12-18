import 'package:flutter/cupertino.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
import 'package:provider/provider.dart';

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
    final mediaActions = context.read<FileSystemMediaProvider>(); // will not cause rebuilds on button presses
    return defaultToolBarScaffold(
      title: title,
      source: mediaProvider.currentPath ?? "No source selected",
      actions: [
        customToolbarItem(
          label: 'Select Source',
          iconData: CupertinoIcons.folder_badge_plus,
          onPressed: () {
            debugPrint('Select Source pressed');
            mediaActions.pickSourceDirectory();
          },
        ),
        customToolbarItem(
          label: 'Rescan',
          iconData: CupertinoIcons.arrow_clockwise,
          onPressed: () {
            debugPrint('Rescan pressed');
            mediaActions.loadSavedPath();
          },
        ),
        customToolbarItem(
          label: 'Select',
          onPressed: () {
            debugPrint('Select pressed');
          },
        ),
      ],
      children: children,
    );
  }
}
