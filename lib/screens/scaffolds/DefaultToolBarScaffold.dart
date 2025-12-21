import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

MacosScaffold defaultToolBarScaffold({
  required String title,
  required List<Widget> children,
  required String source,
  List<ToolbarItem>? actions,
  double titleWidth = 300.0,
  bool centerTitle = false,
  bool enableBlur = true,
}) {
  return MacosScaffold(
    toolBar: ToolBar(
      title: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan( 
          style: const TextStyle(
            color: CupertinoColors.black,
          ),
          children: [
            TextSpan(
              text: "$title\n",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: source,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: CupertinoColors.systemGrey2,
              ),
            ),
          ],
        ),
      ),
      actions: actions,
      titleWidth: titleWidth,
      centerTitle: centerTitle,
      enableBlur: enableBlur,
    ),
    children: children,
  );
}
