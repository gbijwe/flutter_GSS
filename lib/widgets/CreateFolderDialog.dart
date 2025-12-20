import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:provider/provider.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MacosAlertDialog(
      appIcon: const MacosIcon(CupertinoIcons.folder_badge_plus),
      title: const Text('Create New Folder'),
      message: Column(
        children: [
          const SizedBox(height: 16),
          MacosTextField(
            controller: _nameController,
            placeholder: 'Folder name',
          ),
        ],
      ),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        child: const Text('Create'),
        onPressed: () async {
          if (_nameController.text.isNotEmpty) {
            await context.read<FolderMediaProvider>().createFolder(
              name: _nameController.text,
            );
            Navigator.of(context).pop();
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