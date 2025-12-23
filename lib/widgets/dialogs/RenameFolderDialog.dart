import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:provider/provider.dart';

class RenameFolderDialog extends StatefulWidget {
  const RenameFolderDialog({super.key, required this.folderId, required this.folderName});
  final int folderId; 
  final String folderName;

  @override
  State<RenameFolderDialog> createState() => _RenameFolderDialogState();
}

class _RenameFolderDialogState extends State<RenameFolderDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MacosAlertDialog(
      // appIcon: const MacosIcon(CupertinoIcons.folder_open),
      title: const Text('Rename'),
      message: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Name'),
              Flexible(
                child: MacosTextField(
                  controller: _nameController,
                  placeholder: widget.folderName,
                  autofocus: true,
                ),
              ),
            ],
          ),
        ],
      ),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        child: const Text('Rename'),
        onPressed: () async {
          if (_nameController.text.isNotEmpty) {
            await context.read<FolderMediaProvider>().renameFolder(
              widget.folderId,
              _nameController.text,
            );
            if (context.mounted) Navigator.of(context).pop();
          }
        },
      ),
      secondaryButton: PushButton(
        controlSize: ControlSize.large,
        secondary: true,
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
