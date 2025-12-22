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
      title: const Text('Create a New Folder'),
      message: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Name'),
                Flexible(
                  child: MacosTextField(
                    controller: _nameController,
                    placeholder: 'Folder name',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        child: const Text('Create folder'),
        // child: const Text('Save media to this folder'),
        onPressed: () async {
          if (_nameController.text.isNotEmpty) {
            await context.read<FolderMediaProvider>().createFolder(
              name: _nameController.text,
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
