import 'package:flutter/foundation.dart';

class FileSelectionActionProvider extends ChangeNotifier {
  final Set<int> _selectedFileIds = {};
  bool _selectionMode = false;

  // getters
  Set<int> get selectedFileIds => _selectedFileIds;
  bool get selectionMode => _selectionMode; 

  void toggleFileSelection(int id) {
    debugPrint("File id: $id selection toggled");  
    if (_selectedFileIds.contains(id)) {
      _selectedFileIds.remove(id);
    } else {
      _selectedFileIds.add(id);
    }
    notifyListeners();
  }

  void toggleSelectionMode() {
    _selectionMode = !_selectionMode;

    if (!_selectionMode) {
      _selectedFileIds.clear();
    }
    notifyListeners();
  }

  bool isFileSelected(int id) {
    return _selectedFileIds.contains(id);
  }

  bool get hasSelection => _selectedFileIds.isNotEmpty;

  void clearSelection() {
    _selectedFileIds.clear();
    notifyListeners();
  }
}