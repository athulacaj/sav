import 'dart:convert';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sav/screens/path/user/vegetables/logics/sortBasedOnNameClass.dart';
import 'package:sav/widgets/AutoCompleteTextField.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/providers/searchProvider.dart';
import 'package:sav/widgets/cartBadge.dart';
import 'SearchScreen.dart';
import 'logics/ItemsDataManager.dart';
import 'itemsContainer.dart';
import 'package:sav/screens/path/user/ViewCart_BottomNavBar.dart';
import 'logics/searchItemAutoComplete.dart';

var _details;
List? _itemdetails;
List<String> _cartItemsList = [];
bool isInList = false;
String? _whichSubcateogry;
//bool _isAnyContent;
bool _showSpinner = true;
String? _shopName;
bool _showSearch = false;
bool _showAllItems = true;
bool _isInitStateCalled = false;
Map? cartItemsMap;
List newList = [];
ButtonStyle kbuttonStyle =
    ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white));
MaterialStateProperty<Color?>? selectionColor =
    MaterialStateProperty.all(Colors.amberAccent);

class ByItems extends StatefulWidget {
  final String? title;
  final bool isClosed;
  ByItems({this.details, this.title, required this.isClosed});
  final List? details;
  @override
  _ByItemsState createState() => _ByItemsState();
}

TextEditingController _typeAheadController = TextEditingController();
SuggestionsBoxController _suggestionsBoxController = SuggestionsBoxController();
FocusNode _focus = new FocusNode();

class _ByItemsState extends State<ByItems> with SingleTickerProviderStateMixin {
  final TextEditingController _searchWordController = TextEditingController();
  late AnimationController _iconAnimationController;
  late ItemsDataManger _itemsDataManger;
  late String _title;
  bool _showFilterBox = false;
  late SortNameClass sortNameClass;
  int selectedLetter = -1;
  @override
  void initState() {
    _isInitStateCalled = true;
    _showSearch = false;
    initFunctions();
    super.initState();
    _itemsDataManger = ItemsDataManger(details: widget.details);
    setItemDetails();
    _title = widget.title!;
    _showFilterBox = false;
    // WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ItemSearchScreen(_itemdetails!))));
  }

  void initFunctions() {
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
    _details = widget.details;
    _shopName = widget.title;
    _showSpinner = false;
//    _itemdetails = isAnyContent(widget.details['items'], _whichSubcateogry);
    manageSearchFunction();
  }

  void manageSearchFunction() async {
    // adding all items to search items
    await Future.delayed(Duration(milliseconds: 200));
    Provider.of<SearchProvider>(context, listen: false)
        .initSearchResults(_itemdetails);
  }

  void dispose() {
    // Clean up the controller when the Widget is disposed
    _searchWordController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  void setItemDetails() {
    _details = widget.details;
    _itemdetails = _itemsDataManger.details;
    _itemdetails = _itemdetails!.where((e) => e['available'] != false).toList();
    sortNameClass = SortNameClass(_itemdetails);
    sortNameClass.sort();
    print(_itemdetails);
    print(sortNameClass.lettersList);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _cartItemsList = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text(_title),
        actions: [
          IconButton(
              onPressed: () {
                _showFilterBox = !_showFilterBox;
                clearSort();
                setState(() {});
              },
              icon: Container(
                color: _showFilterBox ? Colors.blue : null,
                child: Icon(
                  Icons.sort,
                ),
              )),
          CartBadge(),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, value, child) {
          return ModalProgressHUD(
            inAsyncCall: _showSpinner,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 5,
                  height: size.height,
                  width: size.width - 10,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                style: selectedEnum(_title) ==
                                        CategoryEnum.vegetables
                                    ? kbuttonStyle.copyWith(
                                        backgroundColor: selectionColor)
                                    : null,
                                onPressed: () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  await _itemsDataManger
                                      .categoryChange("vegetables");
                                  _title = "Vegetables";
                                  _showSpinner = false;
                                  selectedLetter = -1;
                                  setItemDetails();
                                  setState(() {});
                                },
                                child: Text('Vegetables')),
                            TextButton(
                                style: selectedEnum(_title) ==
                                        CategoryEnum.driedFish
                                    ? kbuttonStyle.copyWith(
                                        backgroundColor: selectionColor)
                                    : null,
                                onPressed: () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  await _itemsDataManger
                                      .categoryChange("driedFish");
                                  _title = "Dried Fish";
                                  _showSpinner = false;
                                  setItemDetails();
                                  selectedLetter = -1;
                                  setState(() {});
                                },
                                child: Text('Dry Fish')),
                            TextButton(
                                style:
                                    selectedEnum(_title) == CategoryEnum.fruits
                                        ? kbuttonStyle.copyWith(
                                            backgroundColor: selectionColor)
                                        : null,
                                onPressed: () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  await _itemsDataManger
                                      .categoryChange("fruits");
                                  selectedLetter = -1;
                                  _title = "Fruits";
                                  _showSpinner = false;
                                  setItemDetails();
                                  setState(() {});
                                },
                                child: Text('Fruits')),
                            TextButton(
                                style:
                                    selectedEnum(_title) == CategoryEnum.others
                                        ? kbuttonStyle.copyWith(
                                            backgroundColor: selectionColor)
                                        : null,
                                onPressed: () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  await _itemsDataManger
                                      .categoryChange("others");
                                  _title = "Other Items";
                                  selectedLetter = -1;
                                  _showSpinner = false;
                                  setItemDetails();
                                  setState(() {});
                                },
                                child: Text('Other Items')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: _itemdetails!.length > 0
                              ? GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: 6,
                                      right: 4,
                                      top: 2,
                                      bottom: _showFilterBox ? 170 : 70),
                                  itemCount: _itemdetails!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map items = _itemdetails![index];
                                    return ItemsContainer(
                                        image: '${items['image']}',
                                        title: '${items['name']}',
                                        en: '${items['en']}',
                                        // amount: items['amount'],
                                        amount: 0,
                                        quantity: double.parse(
                                            '${items['quantity']}'),
                                        unit: '${items['unit']}',
                                        index: index,
                                        isClosed: widget.isClosed,
                                        available: items['available'],
                                        shopName: widget.title,
                                        showFilterBox: _showFilterBox,
                                        imageType: items['imageType']);
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                )
                              : Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.announcement,
                                        size: 60,
                                        color: Color(0xff36b58b),
                                      ),
                                      SizedBox(height: 10),
                                      Text('no items'),
                                      SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(
                        child: ViewCartBottomNavigationBar(),
                      )
//                  : Container(),
                    ],
                  ),
                ),
                _showFilterBox
                    ? Positioned(
                        top: 0,
                        left: 2,
                        width: size.width,
                        height: size.height - 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 3),
                              color: Colors.white,
                              width: size.width,
                              child: Wrap(
                                children: lettersWidget(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                // Positioned(
                //     left: 0,
                //     width: 50,
                //     height: size.height - 80,
                //     child: Container(
                //       padding: EdgeInsets.only(bottom: 3),
                //       color: Colors.white,
                //       width: size.width,
                //       child: Wrap(
                //         direction: Axis.vertical,
                //         verticalDirection: VerticalDirection.up,
                //         children: lettersWidget(),
                //       ),
                //     ))
              ],
            ),
          );
        },
      ),
    );
  }

  void clearSort() {
    selectedLetter = -1;
    _itemdetails = sortNameClass.clear();
  }

  List<Widget> lettersWidget() {
    List<Widget> list = [];
    int length = sortNameClass.lettersList.length;
    if (length >= 1) {
      for (int i = 0; i <= length; i++) {
        Widget toAdd = LetterButton(
          sortNameClass: sortNameClass,
          i: length == i ? i - 1 : i,
          onclick: (String l) {
            if (length == i) {
              clearSort();
            } else {
              _itemdetails = sortNameClass.filterBaseOnLetter(l);
              selectedLetter = i;
            }
            setState(() {});
          },
          isClearButton: length == i,
          selected: selectedLetter,
        );

        list.add(toAdd);
      }
      return list;
    }
    return [];
  }
}

class LetterButton extends StatelessWidget {
  final SortNameClass sortNameClass;
  final int i, selected;
  final Function onclick;
  final bool? isClearButton;
  LetterButton(
      {required this.sortNameClass,
      required this.i,
      required this.onclick,
      required this.isClearButton,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isClear = isClearButton != null && isClearButton!;
    String l = sortNameClass.lettersList[i];

    return Material(
      elevation: 2,
      child: InkWell(
        onTap: () {
          onclick(l);
        },
        child: Container(
            color: isClear
                ? Colors.white
                : selected == i
                    ? Colors.blueAccent
                    : Colors.blueGrey.withOpacity(.06),
            child: isClear ? Icon(Icons.cancel_outlined) : Text(l),
            // color: Colors.blue,
            alignment: Alignment.center,
            height: size.height * .08,
            width: size.width / 7.12),
      ),
    );
  }
}
