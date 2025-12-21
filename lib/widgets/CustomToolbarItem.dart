import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class customToolbarItem extends ToolbarItem {
  const customToolbarItem({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconData,
    this.color = MacosColors.black,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? iconData;
  final Color color;

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    if (displayMode == ToolbarItemDisplayMode.inToolbar) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconData != null) ...[
                MacosIcon(iconData, color: color, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ToolbarOverflowMenuItem(
        label: label,
        onPressed: () {
          onPressed?.call();
          Navigator.of(context).canPop();
        },
      );
    }
  }
}