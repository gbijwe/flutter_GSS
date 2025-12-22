import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

SidebarItem customSideBarItem({
  required String label, 
  required IconData iconData,
  required bool isSelected,
  Color selectedColor = const Color(0x1C000000),
  Color iconColor = MacosColors.systemBlueColor,
  Widget Function(BuildContext)? contextMenuBuilder, 
}) {
  if (contextMenuBuilder != null) {
    return SidebarItem(
      leading: MacosIcon(iconData, color: isSelected ? iconColor : MacosColors.black),
      label: Builder(
        builder: (context) => GestureDetector(
          onSecondaryTapDown: (details) {
            showMacosSheet(
              context: context,
              barrierDismissible: true,
              builder: contextMenuBuilder,
            );
          },
          child: Text(label, style: TextStyle(color: MacosColors.black)),
        ),
      ),
      selectedColor: selectedColor,
    );
  }
  return SidebarItem(
    leading: MacosIcon(iconData, color: isSelected ? iconColor : MacosColors.black,),
    label: Text(label, style: TextStyle(
      color: MacosColors.black,
    ),),
    selectedColor: selectedColor,
  );
}