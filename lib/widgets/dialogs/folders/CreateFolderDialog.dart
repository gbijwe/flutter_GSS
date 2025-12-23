import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/widgets/dialogs/templates/GaussianBlurDialog.dart';
import 'package:provider/provider.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                const Text('Name', style: TextStyle(fontSize: 13),),
                const SizedBox(width : 6),
                Flexible(
                  child: MacosTextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _controller,
                    placeholder: 'Folder name',
                    autofocus: true,
                    style: TextStyle(
                      color: MacosColors.black
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        onPressed: _handleFolderCreate,
        child: const Text('Create folder'),
      ),
      secondaryButton: PushButton(
        controlSize: ControlSize.large,
        secondary: true,
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _handleFolderCreate() async {
    if (_controller.text.isEmpty) return;

    final folderActions = context.read<FolderMediaProvider>();

    await folderActions.createFolder(name: _controller.text);

    if (mounted) {
      if (folderActions.hasError) {
        showMacosAlertDialog(
          context: context,
          barrierColor: MacosColors.black.withAlpha(30),
          builder: (context) {
            return GaussianBlurDialog(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20,
                  right: 20,
                  bottom: 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Couldn't create a new folder",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: MacosColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (folderActions.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        folderActions.errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: MacosColors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                    const SizedBox(height: 18),
                    AdaptiveButton(
                      label: "Alright!",
                      style: AdaptiveButtonStyle.filled,
                      onPressed: () {
                        folderActions.clearError();
                        Navigator.of(context).pop();
                      },
                      color: MacosColors.white,
                      textColor: MacosColors.black,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
