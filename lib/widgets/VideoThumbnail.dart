import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class VideoThumbnailWidget extends StatelessWidget {
  const VideoThumbnailWidget({super.key, required this.file});

  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: MacosColors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: CupertinoColors.systemGrey3,
        child: Icon(
          CupertinoIcons.play_circle_fill,
          size: 48,
          color: CupertinoColors.activeOrange,
        ),
      ),
    );
  }
}
