import 'package:flutter/material.dart';

List getSuggestions(var itemsList, String searchWordAllCase) {
  List<String> result = [];
  String searchWord = searchWordAllCase.toLowerCase();
  List filteredMap = [];
  if (searchWord != '') {
    filteredMap = [];

    for (Map itemMap in itemsList) {
//    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
      bool available = itemMap['available'];
      String item = itemMap['name'].toString().toLowerCase();
      String keyWords = itemMap['search'].toString().toLowerCase();
      final alphanumeric = RegExp('$searchWord');
      bool a = alphanumeric.hasMatch(item);
      bool b = alphanumeric.hasMatch(keyWords);
      if (a == true || b == true) {
        filteredMap.add(itemMap);
      }
    }
  } else {
    filteredMap = itemsList;
  }
  return filteredMap;
}

InputDecoration kautoCompleteTextFieldDecoration = InputDecoration(
  hintText: 'search',
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(2.0))),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);
