import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/content/ContentTemplate.dart';
import 'package:photo_buddy/widgets/thumbnails/MediaThumbnailWrapper.dart';
import 'package:provider/provider.dart';

class RecentlyAddedPage extends StatefulWidget {
  const RecentlyAddedPage({super.key});

  @override
  State<RecentlyAddedPage> createState() => _RecentlyAddedPageState();
}

class _RecentlyAddedPageState extends State<RecentlyAddedPage> {
  @override
  Widget build(BuildContext context) {
    return ContentTemplateWidget(
      title: 'Recently Added',
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
    final mediaProvider = context.watch<FileSystemMediaProvider>();
    final recentlyAdded = mediaProvider.recentlyAddedMediaFiles;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: recentlyAdded.isEmpty
              ? Center(
                  child: Text(
                    "No media was added in the last 24 hours",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: MacosColors.systemGrayColor,
                    ),
                  ),
                )
              : GridView.builder(
                  itemCount: recentlyAdded.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = recentlyAdded[index];

                    if (file.type == FileType.video ||
                        file.type == FileType.image) {
                      return MediaThumbnailWrapper(file: file);
                    } else {
                      return Center(
                        child: Text(
                          ".${file.path.split(".").last.toString()} is not supported",
                        ),
                      ); // Unknown file type
                    }
                  },
                ),
        ),
      ],
    );
  }
}
