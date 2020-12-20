import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  List all = [];
  List searchResults = [];

  void initSearchResults(var itemDetails) {
    all = itemDetails;
    searchResults = itemDetails;
    notifyListeners();
  }

  void revertResult() {
    searchResults = all;
    notifyListeners();
  }

  void getSearchResults(var results) {
    searchResults = results;
    notifyListeners();
  }
}
