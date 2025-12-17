import 'dart:io';
// https://medium.com/@henryifebunandu/generate-thumbnails-from-video-files-in-your-flutter-apps-e559f1db16
enum FileType {
  image, 
  video, 
  unknown
}

extension FileTypeChecker on FileSystemEntity {
  FileType _getFileType() {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'heic':
        return FileType.image;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return FileType.video;
      default:
        return FileType.unknown;
    }
  }

  FileType get fileType => _getFileType();
}