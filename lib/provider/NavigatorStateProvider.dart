import 'package:flutter/cupertino.dart';

class NavigatorStateProvider extends ChangeNotifier {
  int _currentIndex = 1; 
  final favoritesIndex = 3;

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  bool isFavoritesView() {
    return _currentIndex == favoritesIndex;
  }
}