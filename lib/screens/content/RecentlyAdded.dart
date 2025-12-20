import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/content/ContentTemplate.dart';
import 'package:photo_buddy/widgets/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/VideoThumbnail.dart';
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
    final selectionActionProvider = context.read<FileSelectionActionProvider>();
    final selectionStatusProvider = context
        .watch<FileSelectionActionProvider>();
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

                    if (file.type == FileType.video) {
                      return Selector<FileSystemMediaProvider, bool>(
                        selector: (_, p) => p.isFavorite(file.id),
                        builder: (_, isFavorite, __) => VideoThumbnailTile(
                          videoPath: file.path,
                          width: 100,
                          height: 100,
                          isFavorite: isFavorite,
                          isSelected: selectionStatusProvider.isFileSelected(
                            file.id,
                          ),
                          favoriteTap: () {
                            mediaProvider.toggleFavorite(file.id);
                            debugPrint("Toggled favorite for id: ${file.id}");
                          },
                          onLongPress: () {
                            selectionActionProvider.toggleFileSelection(
                              file.id,
                            );
                          },
                        ),
                      );
                    } else if (file.type == FileType.image) {
                      return Selector<FileSystemMediaProvider, bool>(
                        selector: (_, p) => p.isFavorite(file.id),
                        builder: (context, isFavorite, child) {
                          return ImageThumbnailWidget(
                            path: file.path,
                            id: file.id,
                            isFavorite: isFavorite,
                            isSelected: selectionStatusProvider.isFileSelected(
                              file.id,
                            ),
                            onDoubleTap: () {},
                            favoriteTap: () {
                              mediaProvider.toggleFavorite(file.id);
                              debugPrint("Toggled favorite for id: ${file.id}");
                            },
                            onLongPress: () {
                              selectionActionProvider.toggleFileSelection(
                                file.id,
                              );
                            },
                          );
                        },
                      );
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
