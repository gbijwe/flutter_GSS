import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

MacosScaffold toolBarScaffold({
  required String title,
  required List<Widget> children,
  List<ToolbarItem>? actions,
  double titleWidth = 200.0,
  bool centerTitle = false,
  bool enableBlur = true,
}) {
  return MacosScaffold(
    toolBar: ToolBar(
      title: Text(title),
      actions: actions,
      titleWidth: titleWidth,
      centerTitle: centerTitle,
      enableBlur: enableBlur,
    ),
    children: children,
  );
}
