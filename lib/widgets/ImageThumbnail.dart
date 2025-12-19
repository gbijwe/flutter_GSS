import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class ImageThumbnailWidget extends StatelessWidget {
  ImageThumbnailWidget({
    super.key,
    required this.path,
    required this.id,
    required this.isFavorite,
    required this.onTap,
  });

  // final FileSystemEntity file;
  final String path;
  final int id;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: MacosColors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              CupertinoIcons.exclamationmark_circle,
            ), // Handle video/errors
          ),

          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(2),
              // decoration: BoxDecoration(
              //   color: CupertinoColors.black.withAlpha(15),
              //   borderRadius: BorderRadius.circular(4),
              // ),
              child: isFavorite
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
        ],
      ),
    );
  }
}
