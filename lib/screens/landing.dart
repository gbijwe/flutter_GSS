import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_buddy/screens/content/AllMedia.dart';
import 'package:photo_buddy/screens/content/Favorites.dart';
import 'package:photo_buddy/screens/content/People.dart';
import 'package:photo_buddy/screens/content/RecentlyAdded.dart';
import 'package:photo_buddy/screens/content/Timeline.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Panaromas.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Photos.dart';
import 'package:photo_buddy/screens/content/filterMediaTypes/Videos.dart';
import 'package:photo_buddy/widgets/CustomSideBarItem.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int pageIdx = 0;

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
      case 11:
        return Center(child: Text('New folder 1'));
      case 12:
        return Center(child: Text('New folder 2'));
      default:
        return Center(child: Text('Select an item'));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                expandDisclosureItems: true,
                disclosureItems: [
                  customSideBarItem(
                    label: 'New folder 1',
                    iconData: CupertinoIcons.folder,
                    isSelected: pageIdx == 11,
                  ),
                  customSideBarItem(
                    label: 'New folder 2',
                    iconData: CupertinoIcons.folder,
                    isSelected: pageIdx == 12,
                  ),
                ],
              ),
            ],
            currentIndex: pageIdx,
            onChanged: (i) {
              setState(() {
                pageIdx = i;
              });
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
