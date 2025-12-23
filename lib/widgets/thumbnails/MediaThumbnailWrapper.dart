import 'package:flutter/cupertino.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/widgets/contextMenus/thumbnail/thumbnailContextMenu.dart';
import 'package:photo_buddy/widgets/thumbnails/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/thumbnails/VideoThumbnail.dart';
import 'package:provider/provider.dart';

class MediaThumbnailWrapper extends StatelessWidget {
  final MediaItem file;

  const MediaThumbnailWrapper({super.key, required this.file});

  static final ContextMenuController _contextMenuController =
      ContextMenuController();

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.read<FileSystemMediaProvider>();
    final selectionActionProvider = context.read<FileSelectionActionProvider>();
    final selectionStatusProvider = context
        .watch<FileSelectionActionProvider>();

    return Selector<FileSystemMediaProvider, bool>(
      selector: (_, provider) => provider.isFavorite(file.id),
      builder: (context, isFavorite, _) {
        final isSelected = selectionStatusProvider.isFileSelected(file.id);
        final isSelectionMode = selectionStatusProvider.selectionMode;

        final commonCallbacks = _MediaCallbacks(
          onTap: isSelectionMode
              ? () => selectionActionProvider.toggleFileSelection(file.id)
              : () {},
          onDoubleTap: () {}, // Add your preview logic here
          onSecondaryTapDown: (details) {
            if (!isSelectionMode) {
              showMediaThumbnailContextMenu(
                context,
                details.globalPosition,
                file,
                _contextMenuController,
              );
            }
          },
          onLongPress: () {
            if (!isSelectionMode) {
              selectionActionProvider.toggleSelectionMode();
            }
            selectionActionProvider.toggleFileSelection(file.id);
          },
          favoriteTap: () {
            mediaProvider.toggleFavorite(file.id);
            debugPrint("Toggled favorite for id: ${file.id}");
          },
        );

        if (file.type == FileType.video) {
          return VideoThumbnailTile(
            videoPath: file.path,
            width: 100,
            height: 100,
            isFavorite: isFavorite,
            isSelected: isSelected,
            onTap: commonCallbacks.onTap,
            onDoubleTap: commonCallbacks.onDoubleTap,
            onLongPress: commonCallbacks.onLongPress,
            favoriteTap: commonCallbacks.favoriteTap,
            onSecondaryTapDown: commonCallbacks.onSecondaryTapDown,
          );
        } else if (file.type == FileType.image) {
          return ImageThumbnailWidget(
            path: file.path,
            id: file.id,
            isFavorite: isFavorite,
            isSelected: isSelected,
            onTap: commonCallbacks.onTap,
            onDoubleTap: commonCallbacks.onDoubleTap,
            onLongPress: commonCallbacks.onLongPress,
            favoriteTap: commonCallbacks.favoriteTap,
            onSecondaryTapDown: commonCallbacks.onSecondaryTapDown,
          );
        } else {
          return Center(
            child: Text(".${file.path.split(".").last} is not supported"),
          );
        }
      },
    );
  }
}

class _MediaCallbacks {
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final GestureTapDownCallback onSecondaryTapDown;
  final VoidCallback onLongPress;
  final VoidCallback favoriteTap;

  _MediaCallbacks({
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.favoriteTap,
    required this.onSecondaryTapDown,
  });
}
