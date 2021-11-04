import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/widgets/AutoCompleteTextField.dart';

class AutoCompleteNameClass {
  late List<DocumentSnapshot<Map<String, dynamic>>> customerDatabaseList;
  late List<ArbitrarySuggestionType> customersList = [];
  late FocusNode focusNode;
  late GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> key;
  AutoCompleteNameClass(
      {required List<DocumentSnapshot<Map<String, dynamic>>>
          customerDatabaseList,
      var key}) {
    this.customerDatabaseList = customerDatabaseList;
    this.key = key;
    createDataList();
    focusNode = FocusNode();
  }

  void createDataList() {
    for (DocumentSnapshot<Map<String, dynamic>> customer
        in customerDatabaseList) {
      customersList.add(new ArbitrarySuggestionType(customer['name'],
          customer['shop'], customer['area'], customer['phone']));
    }
  }

  Widget textField(
      {required TextEditingController nameController,
      required TextEditingController shopController,
      required TextEditingController areaController,
      required TextEditingController phoneController,
      required Function focusChange}) {
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
                        shopController.text = '';
                        areaController.text = '';
                        phoneController.text = '';
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
        itemSubmitted: (item) async {
          nameController.text = item.name;
          areaController.text = item.area;
          shopController.text = item.shop;
          phoneController.text = item.phone;
        },
        onFocusChanged: (bool isFocusChanged) {
          focusChange(isFocusChanged);
        },
        focusNode: focusNode,
        key: key,
        controller: nameController,
        suggestionsAmount: 40,
        clearOnSubmit: false,
        // submitOnSuggestionTap: false,
        suggestions: customersList,
        itemBuilder: (context, suggestion) => new Padding(
            child: new ListTile(
                title: new Text(suggestion.name),
                trailing: new Text("area: ${suggestion.area}")),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
        itemSorter: (a, b) => a.name == b.name ? 0 : 1,
        // : a.id > b.id
        //     ? -1
        //     : 1,

        itemFilter: (suggestion, input) {
          return suggestion.name
                  .toLowerCase()
                  .startsWith(input.toLowerCase()) ||
              suggestion.area.toLowerCase().startsWith(input.toLowerCase());
        });
  }
}

class ArbitrarySuggestionType {
  String name, shop, area, phone;
  ArbitrarySuggestionType(this.name, this.shop, this.area, this.phone);
}
