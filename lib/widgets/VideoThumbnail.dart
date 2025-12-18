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

  const VideoThumbnailTile({
    super.key,
    required this.videoPath,
    this.width = 200,
    this.height = 200,
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
      debugPrint("Error generating thumbnail: $e");
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
          return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: MacosColors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
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
              ],
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
