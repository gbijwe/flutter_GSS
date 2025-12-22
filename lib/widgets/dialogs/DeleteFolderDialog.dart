import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:provider/provider.dart';

class DeleteFolderDialog extends StatefulWidget {
  const DeleteFolderDialog({super.key, required this.folderId});

  final int folderId;

  @override
  State<DeleteFolderDialog> createState() => _DeleteFolderDialogState();
}

class _DeleteFolderDialogState extends State<DeleteFolderDialog> {

  @override
  Widget build(BuildContext context) {
    return MacosAlertDialog(
      appIcon: const MacosIcon(CupertinoIcons.folder_badge_minus),
      title: const Text('Delete this folder permanently?'),
      message: Wrap(children: [const Text('Are you sure you want to delete the selected folder?\nThis action is irreversible.')]),
      primaryButton: PushButton(
        color: MacosColors.systemRedColor,
        controlSize: ControlSize.large,
        borderRadius: BorderRadius.circular(100),
        child: const Text('Delete this folder'),
        onPressed: () async {
          await context.read<FolderMediaProvider>().deleteFolder(widget.folderId);
          if (context.mounted) Navigator.of(context).pop();
        },
      ),
      // secondaryButton: PushButton(
      //   controlSize: ControlSize.large,
      //   borderRadius: BorderRadius.circular(100),
      //   secondary: true,
      //   child: const Text('Cancel'),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
    );
  }
}
