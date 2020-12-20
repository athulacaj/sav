import 'dart:convert';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/providers/searchProvider.dart';
import 'itemsContainer.dart';
import 'package:sav/screens/path/user/ViewCart_BottomNavBar.dart';

var _details;
List _itemdetails;
List<String> _cartItemsList = [];
bool isInList = false;
String _whichSubcateogry;
//bool _isAnyContent;
bool _showSpinner = true;
String _shopName;
bool _showSearch = false;
bool _showAllItems = true;
bool _isInitStateCalled = false;
Map cartItemsMap;
List newList = [];

class ByItems extends StatefulWidget {
  final String title;
  final fromWhere;
  final bool isClosed;
  ByItems({this.details, this.title, @required this.isClosed, this.fromWhere});
  final List details;
  @override
  _ByItemsState createState() => _ByItemsState();
}

TextEditingController _typeAheadController = TextEditingController();
SuggestionsBoxController _suggestionsBoxController = SuggestionsBoxController();
FocusNode _focus = new FocusNode();

class _ByItemsState extends State<ByItems> with SingleTickerProviderStateMixin {
  final TextEditingController _searchWordController = TextEditingController();
  AnimationController _iconAnimationController;
  @override
  @override
  void initState() {
    _isInitStateCalled = true;
    _showSearch = false;
    initFunctions();
    super.initState();
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
    _itemdetails = widget.details;
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

  @override
  Widget build(BuildContext context) {
//    initFunctions();
    _details = widget.details;
    _itemdetails =
        widget.details.where((e) => e['available'] != false).toList();
    print(_itemdetails);
    _cartItemsList = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3FD4A2),
        title: Text(widget.title),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, value, Widget child) {
          return ModalProgressHUD(
            inAsyncCall: _showSpinner,
            progressIndicator: RefreshProgressIndicator(),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        child: _itemdetails.length > 0
                            ? AnimationLimiter(
                                child: GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: 6, right: 4, top: 10, bottom: 75),
                                  itemCount: _itemdetails.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map items = _itemdetails[index];
                                    return AnimationConfiguration.staggeredList(
                                      delay: Duration(milliseconds: 100),
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: ItemsContainer(
                                            image: '${items['image']}',
                                            title: '${items['name']}',
                                            en: '${items['en']}',
                                            // amount: items['amount'],
                                            amount: 0,
                                            quantity: items['quantity'],
                                            unit: '${items['unit']}',
                                            index: index,
                                            isClosed: widget.isClosed,
                                            available: items['available'],
                                            shopName: widget.title,
                                            imageType: items['imageType']),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class SuggestionBox extends StatelessWidget {
  final Map suggestionDetails;
  SuggestionBox(this.suggestionDetails);

  @override
  Widget build(BuildContext context) {
    return Consumer<IsInList>(builder: (context, isInList, child) {
      var _detail;
      var _allDetails = isInList.allDetails ?? [];
      for (var _details in _allDetails) {
        if ('${suggestionDetails['name']}:$_shopName' == _details['name']) {
          _detail = true;
          break;
        } else {
          _detail = false;
        }
      }

      return IconButton(
        icon: _detail != true
            ? Icon(Icons.add,
                color: suggestionDetails['available'] == false
                    ? Colors.grey
                    : Color(0xff36b58b))
            : Icon(Icons.remove, color: Color(0xff36b58b)),
        onPressed: () {
          if (_detail != true && suggestionDetails['available'] != false) {
            onPressed('add', suggestionDetails, context);
          } else {
            onPressed('minus', suggestionDetails, context);
          }
        },
      );
    });
  }
}

Map cartItemsToMap(List cartItemsList) {
  Map cartItemsMap = {};
  if (cartItemsList != null) {
    for (var _details in cartItemsList) {
      cartItemsMap[_details['name']] = true;
    }
  }
  return cartItemsMap;
}

void onPressed(String whatButton, details, BuildContext context) async {
  if (whatButton == 'add') {
    Map individualItem = {
      'name': '${details['name']}:$_shopName',
      'image': '${details['image']}',
      'amount': details['amount'],
      'unit': details['unit'],
      'quantity': details['quantity'],
      'baseAmount': details['amount'],
      'baseQuantity': details['quantity'],
      'shopName': _shopName,
      'imageType': details['imageType'],
    };
    Provider.of<IsInList>(context, listen: false)
        .addAllDetails(individualItem, context);
  } else {
    Provider.of<IsInList>(context, listen: false)
        .removeByName('${details['name']}:$_shopName');
  }
}
