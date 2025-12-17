import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/scaffolds/DefaultToolBarScaffold.dart';
import 'package:photo_buddy/widgets/CustomToolbarItem.dart';
import 'package:photo_buddy/widgets/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/VideoThumbnail.dart';
import 'package:provider/provider.dart';

class AllMediaPage extends StatefulWidget {
  const AllMediaPage({super.key});

  @override
  State<AllMediaPage> createState() => _AllMediaPageState();
}

class _AllMediaPageState extends State<AllMediaPage> {
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<FileSystemMediaProvider>(context);
    return defaultToolBarScaffold(
      title: 'All Media',
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
      children: [
        ContentArea(
          builder: (context, scrollcontroller) {
            return _buildRecentlyAddedContentArea(context);
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyAddedContentArea(BuildContext context) {
    final mediaProvider = Provider.of<FileSystemMediaProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: mediaProvider.mediaFiles.isEmpty
              ? Center(child: Text("No media found or no directory selected"))
              : GridView.builder(
                  itemCount: mediaProvider.mediaFiles.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = mediaProvider.mediaFiles[index];
                    ;

                    if (file.fileType == FileType.video) {
                      return VideoThumbnailTile(videoPath: file.path, width: 100, height: 100);
                    } else if (file.fileType == FileType.image) {
                      return ImageThumbnailWidget(file: file);
                    } else {
                      return Center(
                        child: Text(".${file.path.split(".").last.toString()} is not supported"),
                      ); // Unknown file type
                    }
                  },
                ),
        ),
      ],
    );
  }
}
