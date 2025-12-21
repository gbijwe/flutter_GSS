import 'package:flutter/cupertino.dart';
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
              if (iconData != null) ...[
                Icon(iconData, color: color, size: 16),
                const SizedBox(width: 8),
              ],
              Text(label, style: TextStyle(color: color, fontSize: 14)),
            ],
          ),
        ),
      ),
    ),
    inOverflowedBuilder: (context) {
      final subMenuKey = GlobalKey<ToolbarPopupState>();
      bool isSelected = false;
      
      // Convert PullDownMenuEntry items to ToolbarOverflowMenuItem
      List<ToolbarOverflowMenuItem> subMenuItems = dropdownItems
          .whereType<PullDownMenuItem>()
          .map((item) => ToolbarOverflowMenuItem(
                label: item.title,
                onPressed: () {
                  item.onTap?.call();
                  Navigator.of(context).pop();
                },
              ))
          .toList();

      return StatefulBuilder(
        builder: (context, setState) {
          return ToolbarPopup(
            key: subMenuKey,
            content: (context) => MouseRegion(
              child: ToolbarOverflowMenu(children: subMenuItems),
              onExit: (e) {
                subMenuKey.currentState?.removeToolbarPopupRoute();
                setState(() => isSelected = false);
              },
            ),
            verticalOffset: 0.0,
            horizontalOffset: 0.0,
            position: ToolbarPopupPosition.side,
            placement: ToolbarPopupPlacement.start,
            child: MouseRegion(
              onHover: (e) {
                subMenuKey.currentState?.openPopup().then(
                  (value) => setState(() => isSelected = false),
                );
                setState(() => isSelected = true);
              },
              child: ToolbarOverflowMenuItem(
                label: label,
                subMenuItems: subMenuItems,
                onPressed: () {},
                isSelected: isSelected,
              ),
            ),
          );
        },
      );
    },
  );
}