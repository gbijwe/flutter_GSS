import 'package:flutter/cupertino.dart';

class NavigatorStateProvider extends ChangeNotifier {
  int _currentIndex = 1; 
  final int favoritesIndex = 3;
  final int folderStartIndex = 11;
  
  int _currentFolderId = -1; 

  int get currentIndex => _currentIndex;

  bool get isFoldersView => _currentIndex > folderStartIndex;

  int get currentFolderId => _currentFolderId;

  void updateIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      if (newIndex <= folderStartIndex) {
        _currentFolderId = -1; 
      }
      notifyListeners();
    }
  }

  void setCurrentFolderId(int folderId) {
    if (folderId != _currentFolderId) {
      _currentFolderId = folderId;
      notifyListeners();
    }
  }

  bool isFavoritesView() {
    return _currentIndex == favoritesIndex;
  }
}