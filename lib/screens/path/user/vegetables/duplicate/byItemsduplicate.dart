// import 'dart:convert';
//
// import 'package:animated_icon_button/animated_icon_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:provider/provider.dart';
// import 'package:sav/providers/provider.dart';
// import 'package:sav/providers/searchProvider.dart';
// import '../search.dart';
// import 'package:sav/screens/path/user/ViewCart_BottomNavBar.dart';
//
// import '../itemsContainer.dart';
//
// var _details;
// List _itemdetails;
// List<String> _cartItemsList = [];
// bool isInList = false;
// String _whichSubcateogry;
// //bool _isAnyContent;
// bool _showSpinner = true;
// String _shopName;
// bool _showSearch = false;
// bool _showAllItems = true;
// bool _isInitStateCalled = false;
// Map cartItemsMap;
//
// class ByItems extends StatefulWidget {
//   final String shopName;
//   final fromWhere;
//   final bool isClosed;
//   ByItems(
//       {this.details, this.shopName, @required this.isClosed, this.fromWhere});
//   final details;
//   @override
//   _ByItemsState createState() => _ByItemsState();
// }
//
// TextEditingController _typeAheadController = TextEditingController();
// SuggestionsBoxController _suggestionsBoxController = SuggestionsBoxController();
// FocusNode _focus = new FocusNode();
//
// class _ByItemsState extends State<ByItems> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchWordController = TextEditingController();
//   AnimationController _iconAnimationController;
//   @override
//   @override
//   void initState() {
//     _isInitStateCalled = true;
//     _showSearch = false;
//     initFunctions();
//     super.initState();
//   }
//
//   void initFunctions() {
//     _iconAnimationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 200),
//       reverseDuration: Duration(milliseconds: 200),
//     );
//     _details = widget.details;
//     _shopName = widget.shopName;
//     _whichSubcateogry =
//         _details['subCategory'] != null ? _details['subCategory'][0] : null;
// //    showSpinnerFunction();
//     _showSpinner = false;
// //    _itemdetails = isAnyContent(widget.details['items'], _whichSubcateogry);
//     _itemdetails = widget.details['items'];
//     manageSearchFunction();
//   }
//
//   void manageSearchFunction() async {
//     // adding all items to search items
//     await Future.delayed(Duration(milliseconds: 200));
//     Provider.of<SearchProvider>(context, listen: false)
//         .initSearchResults(_itemdetails);
//   }
//
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     _searchWordController.dispose();
//     _iconAnimationController.dispose();
//     super.dispose();
//   }
//
//   List isAnyContent(List items, String category) {
//     bool toReturn = false;
//     List itemsSorted = [];
//     for (var item in items) {
//       if (item['category'] == category) {
//         itemsSorted.add(item);
//       } else {}
//     }
//     return itemsSorted;
//   }
//
//   @override
//   Widget build(BuildContext context) {
// //    initFunctions();
//     _details = widget.details;
//     _itemdetails = isAnyContent(widget.details['items'], _whichSubcateogry);
// //    _itemdetails =
// //        Provider.of<SearchProvider>(context, listen: false).searchResults;
// //        Provider.of<SearchProvider>(context, listen: false).searchResults;
//
//     _cartItemsList = [];
//     return Scaffold(
//       body: Consumer<SearchProvider>(
//         builder: (context, value, Widget child) {
//           if (_isInitStateCalled == false) {
//             _itemdetails = value.searchResults;
//           }
//           _isInitStateCalled = false;
//           return ModalProgressHUD(
//             inAsyncCall: _showSpinner,
//             progressIndicator: RefreshProgressIndicator(),
//             child: Stack(
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     SafeArea(
//                         child: Container(
//                       height: 55,
//                       width: double.infinity,
//                       color: Color(0xff36b58b),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(width: 2),
// //                              Icon(Icons.ellips),
//                           AnimatedIconButton(
//                             animationController: _iconAnimationController,
//                             size: 25,
//                             onPressed: () {
//                               if (_showSearch == true) {
//                                 _suggestionsBoxController.close();
//                                 Provider.of<SearchProvider>(context,
//                                         listen: false)
//                                     .revertResult();
//                                 _iconAnimationController.reverse();
//                                 _showSearch = false;
//                                 setState(() {});
//                               } else {
//                                 Navigator.pop(context);
//                               }
//                             },
//                             endIcon: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             startIcon: Icon(
//                               Icons.arrow_back,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(width: _showSearch == true ? 0 : 10),
//                           _showSearch == false
//                               ? Text(
//                                   widget.shopName,
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 18),
//                                 )
//                               : Container(),
//                           Spacer(),
//                           AnimatedContainer(
//                             height: 40,
// //                                margin: EdgeInsets.only(left: 4, right: 6),
//                             width: _showSearch == true
//                                 ? MediaQuery.of(context).size.width - 65
//                                 : 0,
//                             duration: Duration(milliseconds: 550),
//                             child: _showSearch == true
//                                 ? TypeAheadField(
// //                      hideOnEmpty: true,
//                                     suggestionsBoxController:
//                                         _suggestionsBoxController,
//                                     textFieldConfiguration:
//                                         TextFieldConfiguration(
//                                       controller: _typeAheadController,
//                                       focusNode: _focus,
//                                       autofocus: true,
//                                       textAlign: TextAlign.center,
//                                       decoration:
//                                           kautoCompleteTextFieldDecoration
//                                               .copyWith(
//                                         suffixIcon: IconButton(
//                                           icon: Icon(Icons.clear_all),
//                                           onPressed: () {
//                                             _typeAheadController.clear();
// //                                                _suggestionsBoxController
// //                                                    .close();
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     suggestionsCallback: (pattern) async {
//                                       _itemdetails = isAnyContent(
//                                           widget.details['items'],
//                                           _whichSubcateogry);
//
//                                       List suggestionList =
//                                           getSuggestions(_itemdetails, pattern);
// //                                          Provider.of<SearchProvider>(context,
// //                                                  listen: false)
// //                                              .getSearchResults(suggestionList);
//                                       return suggestionList;
//                                     },
//                                     itemBuilder: (context, suggestion) {
//                                       return ListTile(
//                                         leading: SuggestionBox(suggestion),
//                                         title: suggestion['available'] == false
//                                             ? Text(
//                                                 suggestion['name'],
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     decoration: TextDecoration
//                                                         .lineThrough),
//                                               )
//                                             : Text(
//                                                 suggestion['name'],
//                                               ),
//                                         trailing: Text(
//                                           '₹ ${suggestion['amount']} / ${suggestion['quantity']} ${suggestion['unit']}',
//                                           textAlign: TextAlign.start,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w300,
//                                               fontSize: 13.5),
//                                         ),
//                                       );
//                                     },
//                                     onSuggestionSelected: (suggestion) {
//                                       List toAdd = [suggestion];
//                                       Provider.of<SearchProvider>(context,
//                                               listen: false)
//                                           .getSearchResults(toAdd);
//                                     })
//                                 : Container(),
//                           ),
//                           _showSearch == false
//                               ? GestureDetector(
//                                   onTap: () {
//                                     _iconAnimationController.forward();
//                                     _showSearch = true;
//                                     setState(() {});
//                                   },
//                                   child: CircleAvatar(
//                                     backgroundColor: Colors.white,
//                                     radius: 16,
//                                     child: Icon(Icons.search,
//                                         color: Colors.black, size: 20),
//                                   ),
//                                 )
//                               : Container(),
//                           SizedBox(width: 8),
//                         ],
//                       ),
//                     )),
//                     SizedBox(height: 4),
//                     Container(
//                       height: _whichSubcateogry != null ? 30 : 0,
//                       child: ListView.builder(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _details['subCategory'] != null
//                             ? _details['subCategory'].length
//                             : 0,
//                         itemBuilder: (BuildContext context, int index) {
//                           var subCategory = _details['subCategory'][index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5),
//                             child: FlatButton(
//                               color: _whichSubcateogry == subCategory
//                                   ? Colors.deepPurple
//                                   : Colors.white,
//                               onPressed: () {
//                                 setState(() {
//                                   _whichSubcateogry = subCategory;
//                                   _itemdetails = isAnyContent(
//                                       widget.details['items'],
//                                       _whichSubcateogry);
//                                 });
//                               },
//                               child: Text(
//                                 '$subCategory',
//                                 style: TextStyle(
//                                   color: _whichSubcateogry == subCategory
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 4),
//                         child: _itemdetails.length > 0
//                             ? AnimationLimiter(
//                                 child: GridView.builder(
//                                   padding: EdgeInsets.only(
//                                       left: 6, right: 4, top: 10, bottom: 75),
//                                   itemCount: _itemdetails.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     Map items = _itemdetails[index];
//                                     return AnimationConfiguration.staggeredList(
//                                       delay: Duration(milliseconds: 100),
//                                       position: index,
//                                       duration:
//                                           const Duration(milliseconds: 500),
//                                       child: SlideAnimation(
//                                         verticalOffset: 100.0,
//                                         child: ItemsContainer(
//                                             image: '${items['image']}',
//                                             title: '${items['name']}',
//                                             en: '${items['en']}',
//
//                                             // amount: items['amount'],
//                                             amount: 0,
//                                             quantity: items['quantity'],
//                                             unit: '${items['unit']}',
//                                             index: index,
//                                             isClosed: widget.isClosed,
//                                             available: items['available'],
//                                             shopName: widget.shopName,
//                                             imageType: items['imageType']),
//                                       ),
//                                     );
//                                   },
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 3),
//                                 ),
//                               )
//                             : Container(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Icon(
//                                       Icons.announcement,
//                                       size: 60,
//                                       color: Color(0xff36b58b),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Text('no items'),
//                                     SizedBox(height: 50),
//                                   ],
//                                 ),
//                               ),
//                       ),
//                     ),
// //
//                     SizedBox(
//                       child: ViewCartBottomNavigationBar(),
//                     )
// //                  : Container(),
//                   ],
//                 ),
//                 _showSearch == true
//                     ? Positioned(
//                         bottom: 60,
//                         right: 35,
//                         child: FloatingActionButton(
//                           child: Text('Clear'),
//                           onPressed: () {
//                             Provider.of<SearchProvider>(context, listen: false)
//                                 .revertResult();
//                             _iconAnimationController.reverse();
//                             _showSearch = false;
//                             setState(() {});
//                           },
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class SuggestionBox extends StatelessWidget {
//   final Map suggestionDetails;
//   SuggestionBox(this.suggestionDetails);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<IsInList>(builder: (context, isInList, child) {
//       var _detail;
//       var _allDetails = isInList.allDetails ?? [];
//       for (var _details in _allDetails) {
//         if ('${suggestionDetails['name']}:$_shopName' == _details['name']) {
//           _detail = true;
//           break;
//         } else {
//           _detail = false;
//         }
//       }
//
//       return IconButton(
//         icon: _detail != true
//             ? Icon(Icons.add,
//                 color: suggestionDetails['available'] == false
//                     ? Colors.grey
//                     : Color(0xff36b58b))
//             : Icon(Icons.remove, color: Color(0xff36b58b)),
//         onPressed: () {
//           if (_detail != true && suggestionDetails['available'] != false) {
//             onPressed('add', suggestionDetails, context);
//           } else {
//             onPressed('minus', suggestionDetails, context);
//           }
//         },
//       );
//     });
//   }
// }
//
// Map cartItemsToMap(List cartItemsList) {
//   Map cartItemsMap = {};
//   if (cartItemsList != null) {
//     for (var _details in cartItemsList) {
//       cartItemsMap[_details['name']] = true;
//     }
//   }
//   return cartItemsMap;
// }
//
// void onPressed(String whatButton, details, BuildContext context) async {
//   if (whatButton == 'add') {
//     Map individualItem = {
//       'name': '${details['name']}:$_shopName',
//       'image': '${details['image']}',
//       'amount': details['amount'],
//       'unit': details['unit'],
//       'quantity': details['quantity'],
//       'baseAmount': details['amount'],
//       'baseQuantity': details['quantity'],
//       'shopName': _shopName,
//       'imageType': details['imageType'],
//     };
//     Provider.of<IsInList>(context, listen: false)
//         .addAllDetails(individualItem, context);
//   } else {
//     Provider.of<IsInList>(context, listen: false)
//         .removeByName('${details['name']}:$_shopName');
//   }
// }
