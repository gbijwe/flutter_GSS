import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/content/folders/FolderTemplate.dart';
import 'package:photo_buddy/widgets/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/VideoThumbnail.dart';
import 'package:provider/provider.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  final int folderId;
  final String folderName;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<MediaItem> folderMediaItems = [];
  bool isLoading = true;
  FolderMediaProvider? _folderProvider; 

  @override
  void initState() {
    super.initState();
    _loadFolderMedia();
    
    if (_folderProvider == null) {
      _folderProvider = context.read<FolderMediaProvider>();
      _folderProvider!.addListener(_onFolderChanged);
    }
  }

  @override
  void didUpdateWidget(FolderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderId != widget.folderId) {
      _loadFolderMedia();
    }
  }

  @override 
  void dispose() {
    _folderProvider?.removeListener(_onFolderChanged);
    super.dispose();
  }

  void _onFolderChanged() {
    _loadFolderMedia();
  }

  Future<void> _loadFolderMedia() async {
    final folderProvider = context.read<FolderMediaProvider>();
    final media = await folderProvider.getMediaInFolder(widget.folderId);

    setState(() {
      folderMediaItems = media;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FolderTemplateWidget(
      title: widget.folderName,
      folderId: widget.folderId,
      children: [
        ContentArea(
          builder: (context, scrollcontroller) {
            return _buildFolderContentArea(context);
          },
        ),
      ],
    );
  }

  Widget _buildFolderContentArea(BuildContext context) {
    if (isLoading) {
      return Center(child: ProgressCircle());
    }
    final mediaProvider = context.read<FileSystemMediaProvider>();
    final selectionStatusProvider = context
        .watch<FileSelectionActionProvider>();
    final selectionActionProvider = context.read<FileSelectionActionProvider>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: folderMediaItems.isEmpty
              ? Center(child: Text("No media in this folder"))
              : GridView.builder(
                  itemCount: folderMediaItems.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = folderMediaItems[index];

                    if (file.type == FileType.video) {
                      return Selector<FileSystemMediaProvider, bool>(
                        selector: (_, p) => p.isFavorite(file.id),
                        builder: (_, isFavorite, __) => VideoThumbnailTile(
                          videoPath: file.path,
                          width: 100,
                          height: 100,
                          isFavorite: isFavorite,
                          isSelected: selectionStatusProvider.isFileSelected(
                            file.id,
                          ),
                          onTap: selectionStatusProvider.selectionMode
                              ? () {
                                  selectionActionProvider.toggleFileSelection(
                                    file.id,
                                  );
                                }
                              : () {},
                          favoriteTap: () {
                            mediaProvider.toggleFavorite(file.id);
                            debugPrint("Toggled favorite for id: ${file.id}");
                          },
                          onLongPress: () {
                              if (selectionStatusProvider.selectionMode ==
                                  false) {
                                selectionActionProvider.toggleSelectionMode();
                              }
                              selectionActionProvider.toggleFileSelection(
                                file.id,
                              );
                            },
                        ),
                      );
                    } else if (file.type == FileType.image) {
                      return Selector<FileSystemMediaProvider, bool>(
                        selector: (_, p) => p.isFavorite(file.id),
                        builder: (context, isFavorite, child) {
                          return ImageThumbnailWidget(
                            path: file.path,
                            id: file.id,
                            isFavorite: isFavorite,
                            onTap: selectionStatusProvider.selectionMode
                                ? () {
                                    selectionActionProvider.toggleFileSelection(
                                      file.id,
                                    );
                                  }
                                : () {},
                            isSelected: selectionStatusProvider.isFileSelected(
                              file.id,
                            ),
                            onDoubleTap: () {},
                            favoriteTap: () {
                              mediaProvider.toggleFavorite(file.id);
                              debugPrint("Toggled favorite for id: ${file.id}");
                            },
                            onLongPress: () {
                              if (selectionStatusProvider.selectionMode ==
                                  false) {
                                selectionActionProvider.toggleSelectionMode();
                              }
                              selectionActionProvider.toggleFileSelection(
                                file.id,
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          ".${file.path.split(".").last.toString()} is not supported",
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}
