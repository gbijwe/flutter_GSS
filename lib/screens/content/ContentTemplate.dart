import 'package:flutter/cupertino.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
import 'package:provider/provider.dart';

class ContentTemplateWidget extends StatefulWidget {
  const ContentTemplateWidget({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  State<ContentTemplateWidget> createState() => _ContentTemplateWidgetState();
}

class _ContentTemplateWidgetState extends State<ContentTemplateWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<FileSystemMediaProvider>(context);
    return defaultToolBarScaffold(
      title: widget.title,
      source: mediaProvider.currentPath ?? "No source selected",
      actions: [
        customToolbarItem(
          label: 'Select Source',
          iconData: CupertinoIcons.folder_badge_plus,
          onPressed: () {
            debugPrint('Select Source pressed');
            mediaProvider.pickSourceDirectory();
          },
        ),
        customToolbarItem(
          label: 'Rescan',
          iconData: CupertinoIcons.arrow_clockwise,
          onPressed: () {
            debugPrint('Rescan pressed');
            mediaProvider.loadSavedPath();
          },
        ),
        customToolbarItem(
          label: 'Select',
          onPressed: () {
            debugPrint('Select pressed');
          },
        ),
      ],
      children: widget.children,
    );
  }
}
