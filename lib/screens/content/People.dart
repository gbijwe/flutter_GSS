import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return defaultToolBarScaffold(
      title: 'Recently Added',
      actions: [
        customToolbarItem(
          label: 'Select Source',
          iconData: CupertinoIcons.folder_badge_plus,
          onPressed: () {
            debugPrint('Select Source pressed');
          },
        ),
        customToolbarItem(
          label: 'Rescan',
          iconData: CupertinoIcons.arrow_clockwise,
          onPressed: () {
            debugPrint('Rescan pressed');
          },
        ),
        customToolbarItem(
          label: 'Select',
          onPressed: () {
            debugPrint('Select pressed');
          },
        ),
      ],
      children: [
        ContentArea(
          builder: (context, scrollcontroller) {
            return _buildRecentlyAddedContentArea();
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyAddedContentArea() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "This folder is currently empty",
            style: TextStyle(fontSize: 13.0, color: MacosColors.black),
          ),
        ),
        Center(
          child: Text(
            "No media was added in the last 24 hours",
            style: TextStyle(
              fontSize: 13.0,
              color: MacosColors.systemGrayColor,
            ),
          ),
        ),
      ],
    );
  }
}
