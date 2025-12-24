import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';
import 'package:photo_buddy/provider/FaceClusteringProvider.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/provider/NavigatorStateProvider.dart';
import 'package:photo_buddy/screens/landing.dart';
import 'package:provider/provider.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  // First initialize the path context
  final pathContext = PathContextManager();
  await pathContext.init();

  final mediaProvider = FileSystemMediaProvider();
  await mediaProvider.init();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => FileSystemMediaProvider()..loadSavedPath()),
        ChangeNotifierProvider.value(value: mediaProvider),
        ChangeNotifierProvider(
          create: (_) {
            final faceProvider = FaceClusteringProvider(isar: mediaProvider.mediaRepo.isar);
            mediaProvider.setFaceClusteringProvider(faceProvider);
            return faceProvider;
          },
        ),
        ChangeNotifierProxyProvider<
          FileSystemMediaProvider,
          FolderMediaProvider
        >(
          create: (context) => FolderMediaProvider(mediaProvider.mediaRepo),
          update: (context, mediaProvider, previous) =>
              previous ?? FolderMediaProvider(mediaProvider.mediaRepo),
        ),
        ChangeNotifierProvider(create: (_) => FileSelectionActionProvider()),
        ChangeNotifierProvider(create: (_) => NavigatorStateProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      home: LandingScreen(),
      themeMode: ThemeMode.light,
      theme: MacosThemeData(
        typography: MacosTypography(
          color: MacosColors.black,
          body: TextStyle(fontFamily: 'SF Pro'),
        ),
      ),
    );
  }
}
