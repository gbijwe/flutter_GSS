import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:macos_ui/macos_ui.dart';

@immutable
class ImageThumbnailWidget extends StatelessWidget {
  ImageThumbnailWidget({
    super.key,
    required this.path,
    required this.id,
    required this.isFavorite,
    required this.onDoubleTap,
    required this.favoriteTap,
    this.isSelected = false,
    this.onLongPress, 
  });

  // final FileSystemEntity file;
  final String path;
  final int id;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback onDoubleTap;
  final VoidCallback favoriteTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, // add a preview mechanism
      onDoubleTap: onDoubleTap, // open preview
      onLongPress: onLongPress, // select this file
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? CupertinoColors.activeBlue : MacosColors.transparent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: MacosColors.black.withAlpha(15),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ]
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              height: 200, 
              width: 200,
              errorBuilder: (_, __, ___) => Icon(
                CupertinoIcons.exclamationmark_circle,
              ), // Handle video/errors
            ),
      
            // Show favorite icon overlay
            Positioned(
              right: 2.0, 
              bottom: 2.0,
              child: GestureDetector(
                onTap: favoriteTap,
                child: Container(
                  padding: EdgeInsets.all(2),
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
            ),

            // Show Selection Overlay
            Positioned(
              left: 2.0, 
              top: 2.0,
              child: Container(
                padding: EdgeInsets.all(2),
                child: isSelected
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
  }
}
