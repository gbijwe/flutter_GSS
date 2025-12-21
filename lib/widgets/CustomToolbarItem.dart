import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

CustomToolbarItem customToolbarItem({
  required String label, 
  required VoidCallback? onPressed,
  IconData? iconData,
  Color color = MacosColors.black,
}) {
  return CustomToolbarItem(
    inToolbarBuilder: (context) => GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration( 
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(6),
          ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconData != null ? MacosIcon(iconData, color: color, size: 16) : SizedBox.shrink(),
            iconData != null ? SizedBox(width: 8,) : SizedBox.shrink(),
            Text(label, style: TextStyle(
              color: color,
              fontSize: 14,
            ),)
          ]
        ),
      ),
    ),
  );
}