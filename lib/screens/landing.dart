import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/provider/FileSelectionActionProvider.dart';
import 'package:photo_buddy/provider/FolderMediaProvider.dart';
import 'package:photo_buddy/screens/content/AllMedia.dart';
import 'package:photo_buddy/screens/content/Favorites.dart';
import 'package:photo_buddy/screens/content/People.dart';
import 'package:photo_buddy/screens/content/RecentlyAdded.dart';
import 'package:photo_buddy/screens/content/Timeline.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Panaromas.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Photos.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Videos.dart';
import 'package:photo_buddy/screens/content/folders/FolderPage.dart';
import 'package:photo_buddy/widgets/CreateFolderDialog.dart';
import 'package:photo_buddy/widgets/CustomSideBarItem.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int pageIdx = 1;

  Widget _getContentWidget() {
    switch (pageIdx) {
      case 0:
        return RecentlyAddedPage();
      case 1:
        return AllMediaPage();
      case 2:
        return TimelinePage();
      case 3:
        return FavoritesPage();
      case 4:
        return PeoplePage();
      case 5:
        return PhotosPage();
      case 6:
        return VideosPage();
      case 7:
        return Center(child: Text('Selfies'));
      case 8:
        return Center(child: Text('Live Photos'));
      case 9:
        return Center(child: Text('Portraits'));
      case 10:
        return PanaromasPage();
      default:
        final folderIdx = pageIdx - 11;
        final folders = context.read<FolderMediaProvider>().folders;
        if (folderIdx >= 0 && folderIdx < folders.length) {
          final folder = folders[folderIdx];
          return FolderPage(folderId: folder.id, folderName: folder.name);
        }
        return Center(child: Text('Select an item'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final folders = context.watch<FolderMediaProvider>().folders;

    return MacosWindow(
      titleBar: null,
      sidebar: Sidebar(
        builder: (context, scrollcontroller) {
          return SidebarItems(
            scrollController: scrollcontroller,
            itemSize: SidebarItemSize.medium,
            items: [
              customSideBarItem(
                label: 'Recently Added',
                iconData: CupertinoIcons.clock,
                isSelected: pageIdx == 0,
              ),
              customSideBarItem(
                label: 'All Media',
                iconData: CupertinoIcons.photo_on_rectangle,
                isSelected: pageIdx == 1,
              ),
              customSideBarItem(
                label: 'Timeline',
                iconData: CupertinoIcons.calendar,
                isSelected: pageIdx == 2,
              ),
              customSideBarItem(
                label: 'Favourites',
                iconData: CupertinoIcons.heart,
                isSelected: pageIdx == 3,
              ),
              customSideBarItem(
                label: 'People',
                iconData: CupertinoIcons.person_2,
                isSelected: pageIdx == 4,
              ),
              SidebarItem(
                label: Text("Media Types"),
                section: true,
                expandDisclosureItems: true,
                disclosureItems: [
                  customSideBarItem(
                    label: 'Photos',
                    iconData: CupertinoIcons.photo,
                    isSelected: pageIdx == 5,
                  ),
                  customSideBarItem(
                    label: 'Videos',
                    iconData: CupertinoIcons.video_camera,
                    isSelected: pageIdx == 6,
                  ),
                  customSideBarItem(
                    label: 'Selfies',
                    iconData: CupertinoIcons.person_crop_square,
                    isSelected: pageIdx == 7,
                  ),
                  customSideBarItem(
                    label: 'Live Photos',
                    iconData: CupertinoIcons.tag_circle,
                    isSelected: pageIdx == 8,
                  ),
                  customSideBarItem(
                    label: 'Portraits',
                    iconData: CupertinoIcons.person_crop_rectangle,
                    isSelected: pageIdx == 9,
                  ),
                  customSideBarItem(
                    label: 'Panorama',
                    iconData: CupertinoIcons.photo_on_rectangle,
                    isSelected: pageIdx == 10,
                  ),
                ],
              ),

              SidebarItem(
                label: Text("Folders"),
                section: true,
                expandDisclosureItems: true,
                disclosureItems: [
                  ...folders.asMap().entries.map((folder) {
                    final idx = folder.key;
                    final folderItem = folder.value;
                    final folderPageIdx = 11 + idx;

                    return customSideBarItem(
                      label: folderItem.name,
                      iconData: CupertinoIcons.folder,
                      isSelected: pageIdx == folderPageIdx,
                      contextMenuBuilder: (context) {
                        return MacosSheet(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MacosListTile(
                                  leading: MacosIcon(
                                    CupertinoIcons.plus_circle,
                                  ),
                                  title: Text('Create Folder'),
                                  onClick: () {
                                    Navigator.pop(context);
                                    showMacosAlertDialog(
                                      context: context,
                                      builder: (context) =>
                                          CreateFolderDialog(),
                                    );
                                  },
                                ),
                                MacosListTile(
                                  leading: MacosIcon(
                                    CupertinoIcons.delete,
                                    color: MacosColors.systemRedColor,
                                  ),
                                  title: Text(
                                    'Delete Folder',
                                    style: TextStyle(
                                      color: MacosColors.systemRedColor,
                                    ),
                                  ),
                                  onClick: () {
                                    Navigator.pop(context);
                                    this.context
                                        .read<FolderMediaProvider>()
                                        .deleteFolder(folderItem.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
                trailing: GestureDetector(
                  onTap: () {
                    showMacosAlertDialog(
                      context: context,
                      builder: (context) => CreateFolderDialog(),
                    );
                  },
                  child: MacosIcon(
                    CupertinoIcons.plus,
                    color: MacosColors.black.withAlpha(75),
                    size: 16.0,
                  ),
                ),
              ),
            ],
            currentIndex: pageIdx,
            onChanged: (i) {
              setState(() {
                pageIdx = i;
              });
              // clear selections on page change
              context.read<FileSelectionActionProvider>().clearSelection();
            },
          );
        },
        minWidth: 200,
        decoration: BoxDecoration(color: MacosColors.white),
      ),
      child: _getContentWidget(),
    );
  }
}
