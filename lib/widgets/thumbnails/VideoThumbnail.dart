import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class VideoThumbnailTile extends StatefulWidget {
  final String videoPath;
  final double width;
  final double height;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback onTap;
  final GestureTapDownCallback onSecondaryTapDown;
  final VoidCallback? favoriteTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const VideoThumbnailTile({
    super.key,
    required this.videoPath,
    this.width = 200,
    this.height = 200,
    this.isFavorite = false,
    this.isSelected = false,
    required this.onTap,
    this.favoriteTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.onSecondaryTapDown
  });

  @override
  State<VideoThumbnailTile> createState() => _VideoThumbnailTileState();
}

class _VideoThumbnailTileState extends State<VideoThumbnailTile> {
  final _plugin = FcNativeVideoThumbnail();
  Future<File?>? _thumbFuture;

  @override
  void initState() {
    super.initState();
    _thumbFuture = _generateThumbnail();
  }

  Future<File?> _generateThumbnail() async {
    try {
      // 1. Get the system temp directory
      final tempDir = await getTemporaryDirectory();

      // 2. Create a unique filename for this video's thumbnail
      // We use the video filename + .jpg
      final videoFileName = p.basename(widget.videoPath);
      final thumbPath = p.join(tempDir.path, '${videoFileName}_thumb.jpg');
      final thumbFile = File(thumbPath);

      // 3. Check if we already generated it previously (Caching)
      if (await thumbFile.exists()) {
        return thumbFile;
      }

      // 4. Generate the thumbnail if it doesn't exist
      // This saves the image to 'destFile'
      final generated = await _plugin.getVideoThumbnail(
        srcFile: widget.videoPath,
        destFile: thumbPath,
        width: widget.width.toInt(),
        height: widget.height.toInt(),
        format: 'jpeg',
        quality: 90,
      );

      if (generated) {
        return thumbFile;
      }
      return null;
    } catch (e) {
      debugPrint(
        "Error generating thumbnail: $e. File path: ${widget.videoPath}",
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _thumbFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          // SUCCESS: Show the generated image
          return GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap, // for preview
            onLongPress: widget.onLongPress, // for selection
            onSecondaryTapDown: widget.onSecondaryTapDown,
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: widget.isSelected ? CupertinoColors.activeBlue : MacosColors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.antiAlias,
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Image.file(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    cacheWidth: widget.width.toInt(), // Memory optimization
                  ),
                  // Play Icon Overlay
                  Container(
                    color: CupertinoColors.black.withAlpha(10),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.play_circle_fill,
                        color: CupertinoColors.white.withAlpha(100),
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2.0,
                    bottom: 2.0,
                    child: GestureDetector(
                      onTap: widget.favoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        // decoration: BoxDecoration(
                        //   color: CupertinoColors.black.withAlpha(15),
                        //   borderRadius: BorderRadius.circular(4),
                        // ),
                        child: widget.isFavorite
                            ? Icon(
                                CupertinoIcons.heart_fill,
                                color: CupertinoColors.systemRed,
                                size: 16,
                              )
                            : Icon(
                                CupertinoIcons.heart,
                                color: CupertinoColors.white,
                                size: 16,
                              ),
                      ),
                    ),
                  ),

                  // Selection Overlay
                  Positioned(
                    left: 2.0,
                    top: 2.0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: widget.isSelected
                          ? Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: CupertinoColors.activeBlue,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // LOADING / ERROR
          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: MacosColors.transparent),
              borderRadius: BorderRadius.circular(8),
              color: CupertinoColors.systemGrey,
            ),
            child: const Center(
              child: CupertinoActivityIndicator(color: CupertinoColors.white),
            ),
          );
        }
      },
    );
  }
}
