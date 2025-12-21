import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pull_down_button/pull_down_button.dart';

CustomToolbarItem customDropdownToolbarItem({
  required String label,
  IconData? iconData,
  required List<PullDownMenuEntry> dropdownItems,
  Color color = MacosColors.black,
}) {
  return CustomToolbarItem(
    inToolbarBuilder: (context) => PullDownButton(
      position: PullDownMenuPosition.automatic,
      itemBuilder: (context) => dropdownItems,
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu,
        padding: EdgeInsets.zero,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.folder_badge_plus, color: color, size: 16,),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: color, fontSize: 14),),
            ],
          ),
        ),
      ),
    ),
  );
}
