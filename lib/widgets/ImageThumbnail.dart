import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class ImageThumbnailWidget extends StatelessWidget {
  const ImageThumbnailWidget({super.key, required this.file});

  final FileSystemEntity file; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: MacosColors.systemGrayColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        File(file.path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(CupertinoIcons.exclamationmark_circle), // Handle video/errors
      ),
    );
  }
}
