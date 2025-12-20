import 'package:flutter/foundation.dart';

class FileSelectionActionProvider extends ChangeNotifier {
  final Set<int> _selectedFileIds = {};

  Set<int> get selectedFileIds => _selectedFileIds;

  void toggleFileSelection(int id) {
    debugPrint("File id: $id selection toggled");  
    if (_selectedFileIds.contains(id)) {
      _selectedFileIds.remove(id);
    } else {
      _selectedFileIds.add(id);
    }
    notifyListeners();
  }

  bool isFileSelected(int id) {
    return _selectedFileIds.contains(id);
  }

  void clearSelection() {
    _selectedFileIds.clear();
    notifyListeners();
  }
}