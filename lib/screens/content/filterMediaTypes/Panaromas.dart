import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/provider/FileSystemMediaProvider.dart';
import 'package:photo_buddy/screens/content/ContentTemplate.dart';
import 'package:photo_buddy/widgets/thumbnails/MediaThumbnailWrapper.dart';
import 'package:provider/provider.dart';

class PanaromasPage extends StatefulWidget {
  const PanaromasPage({super.key});

  @override
  State<PanaromasPage> createState() => _PanaromasPageState();
}

class _PanaromasPageState extends State<PanaromasPage> {
  @override
  Widget build(BuildContext context) {
    return ContentTemplateWidget(
      title: 'Panaromas',
      children: [
        ContentArea(
          builder: (context, scrollcontroller) {
            return _buildRecentlyAddedContentArea();
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyAddedContentArea() {
    final mediaProvider = context.watch<FileSystemMediaProvider>();
    final panaromas = mediaProvider.panaromicImages;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: panaromas.isEmpty
              ? Center(
                  child: Text(
                    "No panaromic images found or no directory selected",
                  ),
                )
              : GridView.builder(
                  itemCount: panaromas.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    final file = panaromas[index];

                    if (file.type == FileType.video || file.type == FileType.image) {
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
