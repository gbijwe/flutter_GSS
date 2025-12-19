import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/content/ContentTemplate.dart';
import 'package:photo_buddy/widgets/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/VideoThumbnail.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return ContentTemplateWidget(
      title: 'Favorites',
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
    final favorites = mediaProvider.favoriteMediaFiles;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: favorites.isEmpty
              ? Center(child: Text("No media found or no directory selected"))
              : GridView.builder(
                  itemCount: favorites.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = favorites[index];

                    if (file.type == FileType.video) {
                      return VideoThumbnailTile(
                        videoPath: file.path,
                        width: 100,
                        height: 100,
                        isFavorite: file.isFavorite,
                      );
                    } else if (file.type == FileType.image) {
                      return ImageThumbnailWidget(
                        path: file.path,
                        id: file.id,
                        isFavorite: file.isFavorite,
                        onTap: () {},
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
