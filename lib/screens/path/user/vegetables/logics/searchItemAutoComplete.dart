import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/widgets/AutoCompleteTextField.dart';

class SearchAutoComplete {
  late List itemsDatabaseList;
  late List<ArbitrarySuggestionType> itemsDataList = [];
  late FocusNode focusNode;
  TextEditingController nameController = TextEditingController();
  late GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> key;
  SearchAutoComplete({required List itemsDatabaseList, required var key}) {
    this.itemsDatabaseList = itemsDatabaseList;
    this.key = key;
    createDataList();
    focusNode = FocusNode();
  }

  void createDataList() {
    for (Map data in itemsDatabaseList) {
      itemsDataList.add(new ArbitrarySuggestionType(data['name'], data));
    }
  }

  Widget textField({required Function focusChange}) {
    return AutoCompleteTextField<ArbitrarySuggestionType>(
        decoration: new InputDecoration(
            hintText: "Enter name or Area",
            suffix: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        nameController.text = '';
                        FocusScope.of(key.currentContext!).unfocus();
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10),
                        child: Icon(Icons.close),
                      )),
                  IconButton(
                      onPressed: () {
                        focusNode.unfocus();
                        FocusScope.of(key.currentContext!).unfocus();
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10),
                        child: Icon(Icons.check),
                      )),
                ],
              ),
            )),
        submitOnSuggestionTap: false,
        itemSubmitted: (item) async {
          nameController.text = item.name;
        },
        onFocusChanged: (bool isFocusChanged) {
          focusChange(isFocusChanged);
        },
        focusNode: focusNode,
        key: key,
        controller: nameController,
        suggestionsAmount: 6,
        clearOnSubmit: false,
        // submitOnSuggestionTap: false,
        suggestions: itemsDataList,
        itemBuilder: (context, suggestion) => new Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(suggestion.name),
                SizedBox(
                    width: 40,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        showToast("${suggestion.name} $value kg added");
                      },
                    ))
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
        itemSorter: (a, b) => a.name == b.name ? 0 : 1,
        // : a.id > b.id
        //     ? -1
        //     : 1,

        itemFilter: (suggestion, input) {
          List nameSplitted = [];
          return searchFound(suggestion, input);
          // return suggestion.name
          //         .toLowerCase()
          //         .startsWith(input.toLowerCase()) ||
          //     suggestion.name
          //         .toLowerCase()
          //         .contains(RegExp(r'input.toLowerCase()'));
        });
  }

  bool searchFound(ArbitrarySuggestionType suggestion, String input) {
    bool result = suggestion.name.toLowerCase().startsWith(input.toLowerCase());
    if (result) return true;
    List suggestionSplitted = suggestion.name.split(" ");
    for (String s in suggestionSplitted) {
      if (s.toLowerCase().startsWith(input.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}

class ArbitrarySuggestionType {
  String name;
  Map data;
  ArbitrarySuggestionType(this.name, this.data);
}
