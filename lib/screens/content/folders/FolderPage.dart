import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/provider/NavigatorStateProvider.dart';
import 'package:photo_buddy/screens/content/folders/FolderTemplate.dart';
import 'package:photo_buddy/widgets/thumbnails/MediaThumbnailWrapper.dart';
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NavigatorStateProvider>().setCurrentFolderId(
          widget.folderId,
        );
      }
    });

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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NavigatorStateProvider>().setCurrentFolderId(
          widget.folderId,
        );
      }
    });
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

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: folderMediaItems.isEmpty
              ? Center(child: Text("This folder is currently empty"))
              : GridView.builder(
                  itemCount: folderMediaItems.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = folderMediaItems[index];

                    if (file.type == FileType.video ||
                        file.type == FileType.image) {
                      return MediaThumbnailWrapper(file: file);
                    } else {
                      return Center(
                        child: Text(
                          ".${file.path.split(".").last.toString()} is not supported",
                        ),
                      ); // Unknown file type
                    }
                  },
                ),
        ),
      ],
    );
  }
}
