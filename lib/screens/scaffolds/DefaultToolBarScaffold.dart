import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

MacosScaffold defaultToolBarScaffold({
  required String title,
  required List<Widget> children,
  required String source,
  List<ToolbarItem>? actions,
  double titleWidth = 200.0,
  bool centerTitle = false,
  bool enableBlur = true,
}) {
  return MacosScaffold(
    toolBar: ToolBar(
      title: RichText(text: TextSpan(text: "$title\n$source",), maxLines: 2, overflow: TextOverflow.ellipsis,),
      actions: actions,
      titleWidth: titleWidth,
      centerTitle: centerTitle,
      enableBlur: enableBlur,
    ),
    children: children,
  );
}
