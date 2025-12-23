import 'package:flutter/foundation.dart';
import 'package:open_file_macos/open_file_macos.dart';

Future<void> openFileInFinder(String filePath) async {
  final openFileMacosPlugin = OpenFileMacos();

  try {
    // Option A: Open the file with its default application
    // await openFileMacosPlugin.open(filePath);

    // Option B: Highlight the file in a new Finder window (Reveal in Finder)
    await openFileMacosPlugin.open(filePath, viewInFinder: true);

  } catch (e) {
    debugPrint('Error opening file: $e');
  }
}
