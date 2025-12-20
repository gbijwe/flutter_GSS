import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/content/folders/FolderTemplate.dart';
import 'package:photo_buddy/widgets/ImageThumbnail.dart';
import 'package:photo_buddy/widgets/VideoThumbnail.dart';
import 'package:provider/provider.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key, required this.folderId, required this.folderName});

  final int folderId;
  final String folderName;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<MediaItem> folderMediaItems = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
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
                          onTap: () => null,
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
                            onDoubleTap: () {},
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