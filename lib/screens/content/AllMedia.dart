import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/content/ContentTemplate.dart';
import 'package:photo_buddy/widgets/dialogs/LoadingDialog.dart';
import 'package:photo_buddy/widgets/thumbnails/MediaThumbnailWrapper.dart';
import 'package:provider/provider.dart';

class AllMediaPage extends StatefulWidget {
  const AllMediaPage({super.key});

  @override
  State<AllMediaPage> createState() => _AllMediaPageState();
}

class _AllMediaPageState extends State<AllMediaPage> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<FileSystemMediaProvider>(context);

    // Show/hide loading dialog based on loading state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mediaProvider.isLoading && !_isDialogShowing) {
        _isDialogShowing = true;
        LoadingDialog.show(context, message: 'Loading the media...');
      } else if (!mediaProvider.isLoading && _isDialogShowing) {
        _isDialogShowing = false;
        Future.delayed(Duration(seconds: 10), () {
          LoadingDialog.hide(context);
        });
      }
    });

    return ContentTemplateWidget(
      title: 'All Media',
      children: [
        ContentArea(
          builder: (context, scrollcontroller) {
            return _buildRecentlyAddedContentArea(context);
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyAddedContentArea(BuildContext context) {
    final mediaProvider = Provider.of<FileSystemMediaProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: mediaProvider.mediaFiles.isEmpty
              ? Center(child: Text("No media found or no directory selected"))
              : GridView.builder(
                  itemCount: mediaProvider.mediaFiles.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = mediaProvider.mediaFiles[index];
                    ;

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
