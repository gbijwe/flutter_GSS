import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/landing.dart';
import 'package:provider/provider.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified
  );
  await config.apply();
}

void main() async {
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  final mediaProvider = FileSystemMediaProvider();
  await mediaProvider.init();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => FileSystemMediaProvider()..loadSavedPath()),
        ChangeNotifierProvider.value(value: mediaProvider),
        ChangeNotifierProxyProvider<FileSystemMediaProvider, FolderMediaProvider>(
          create: (context) => FolderMediaProvider(mediaProvider.mediaRepo),
          update: (context, mediaProvider, previous) =>
              previous ?? FolderMediaProvider(mediaProvider.mediaRepo),
        ),
        ChangeNotifierProvider(create: (_) => FileSelectionActionProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(debugShowCheckedModeBanner: false, home: LandingScreen());
  }
}
