import 'package:flutter/material.dart';
import 'package:sav/widgets/AutoCompleteTextField.dart';

import 'logics/searchItemAutoComplete.dart';

class ItemSearchScreen extends StatefulWidget {
  final List itemDetails;
  ItemSearchScreen(this.itemDetails);

  @override
  _ItemSearchScreenState createState() => _ItemSearchScreenState();
}

class _ItemSearchScreenState extends State<ItemSearchScreen> {
  SearchAutoComplete? searchAutoComplete;
  GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> _key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchAutoComplete = new SearchAutoComplete(
        itemsDatabaseList: widget.itemDetails, key: _key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            searchAutoComplete!.textField(focusChange: () {}),
          ],
        ),
      ),
    );
  }
}
