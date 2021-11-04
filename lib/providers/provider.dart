import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void saveUserData(Map? userData) async {
  final localData = await SharedPreferences.getInstance();

  String user = jsonEncode(userData);
  localData.setString('userNew', user);
}

double calculateTotalQuantity(var allDetails) {
  double totalQ = 0;
  for (var _alldetail in allDetails) {
    totalQ = totalQ + _alldetail['quantity'];
  }
  return totalQ;
}

class IsInListProvider extends ChangeNotifier {
//  bool isInList = false;
  List allDetails = []; //cart items
  int indianHour = 24;
  double? totalQ;
  Map? userDetails;
  String? userName;
  bool showSpinner = false;
  String? fcmId;
  setFcmId(String id) {
    fcmId = id;
    notifyListeners();
  }

  setIndianH(int h) {
    indianHour = h;
    notifyListeners();
  }

  // adding user information when login
  void addUser(Map? user) async {
    userDetails = user;
    saveUserData(user);
    notifyListeners();
  }

  void isShowSpinner(bool showspinner) async {
    showSpinner = showspinner;
    notifyListeners();
  }

  void addAllDetails(Map detailsMap, BuildContext context) async {
    bool isInList = false;
    // updating data
    for (int i = 0; i < allDetails.length; i++) {
      if (allDetails[i]['name'] == detailsMap['name']) {
        allDetails[i] = detailsMap;
        isInList = true;
        break;
      }
    }
    print('length all items ${allDetails.length}');

    if (allDetails.length == 0) {
      // if no items do not check anything just add
      allDetails.add(detailsMap);
    } else if (isInList == false) {
      checkSameShop(detailsMap, allDetails, () {
        allDetails.add(detailsMap);
      }, () {
        removeAllDetails();
      }, context);
    }
    totalQ = calculateTotalQuantity(allDetails);
    allDetails = sort(allDetails);
    notifyListeners();
  }

  List sort(List allDetails) {
    List tempAllDetails = [];
    List tempAllDetailsVeg = [];
    List tempAllDetailsFish = [];
    List tempAllDetailsOther = [];
    for (Map data in allDetails) {
      if (data['shopName'] == 'Vegetables') {
        tempAllDetailsVeg.add(data);
      } else if (data['shopName'] == 'Dried Fish') {
        tempAllDetailsFish.add(data);
      } else {
        tempAllDetailsOther.add(data);
      }
    }
    tempAllDetails =
        tempAllDetailsVeg + tempAllDetailsFish + tempAllDetailsOther;
    return tempAllDetails;
  }

  void removeByName(String? name) {
    for (int i = 0; i < allDetails.length; i++) {
      if (allDetails[i]['name'] == name) {
        allDetails.removeAt(i);
      }
    }
    totalQ = calculateTotalQuantity(allDetails);
    notifyListeners();
  }

  getDetailsByName(String? name) {
    var toReturn;
    for (int i = 0; i < allDetails.length; i++) {
      if (allDetails[i]['name'] == name) {
        toReturn = allDetails[i];
      }
    }
    totalQ = calculateTotalQuantity(allDetails);
    notifyListeners();
    return toReturn;
  }

  void removeAllDetails() {
    allDetails = [];
    isReOrder = false;
    totalQ = calculateTotalQuantity(allDetails);
    notifyListeners();
  }

  // applicable for only admins reordering from cart
  bool isReOrder = false;
  void fromOrdersToCart(List ordersItemList) {
    allDetails = ordersItemList;
    totalQ = calculateTotalQuantity(allDetails);
    this.isReOrder = true;
    notifyListeners();
  }
}

//
//
//

void checkSameShop(Map newDetails, List allDetails, Function addDetails,
    Function deleteItems, BuildContext context) async {
  bool isSameShop = true;
  bool isSameCategory = true;
  bool isNewlyAddedCategoryIsFood = true;
  bool isAlreadyAddedCategoryIsFood = true;
  // isFoodCategory is the new added item is food or not

  String? newShopName = newDetails['shopName'];
  String? newCategory = newDetails['category'];
  String? addedShopName;
  print(newCategory);
  // check the product category is same
  if (newCategory != 'food') {
    isNewlyAddedCategoryIsFood = false;
  }

  for (int i = 0; i < allDetails.length; i++) {
    addedShopName = allDetails[i]['shopName'];
    String? addedCategory = allDetails[i]['category'];
    if (addedCategory != 'food') {
      isAlreadyAddedCategoryIsFood = false;
      break;
    }
    if (addedCategory == 'food') {
      isAlreadyAddedCategoryIsFood = true;
      // check the shop is same
      if (addedShopName != newShopName) {
        isSameShop = false;
        print(' not allowed from diff shop');
        break;
      }

      //check the already added category is food when adding food
    } else if (addedCategory != 'food' && newCategory == 'food') {
      isSameCategory = false;
      break;
    }
  }
  // isFoodCategory is the new added item is food or not
  if (isAlreadyAddedCategoryIsFood == false &&
      isNewlyAddedCategoryIsFood == false) {
    addDetails();
  } else if (isNewlyAddedCategoryIsFood && isAlreadyAddedCategoryIsFood) {
    if (isSameShop) {
      addDetails();
    } else {
      String? type = await (showBottomSheet(context, addedShopName, newShopName)
          as FutureOr<String?>);
      if (type == 'remove') {
        deleteItems();
        addDetails();
      }
    }
  } else {
    //  food cannot order wit other items
    String? type = await (showBottomSheet(context, addedShopName, newShopName)
        as FutureOr<String?>);

    if (type == 'remove') {
      deleteItems();
      addDetails();
    }
  }
}

Future showBottomSheet(
    BuildContext context, String? oldShopName, String? newShopName) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: const Text(
                'Clear your cart?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 20, top: 5, bottom: 5),
              child: RichText(
                text: TextSpan(
                    text: 'Your cart has existing items from ',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: oldShopName == null
                            ? 'Daily Needs.'
                            : '$oldShopName.',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' Do You want to clear it and add items from ',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: newShopName == null
                            ? 'Daily Needs'
                            : '$newShopName',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '?',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                      ),
                    ]),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, 'cancel');
                  },
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Proceed with existing items',
                        style: TextStyle(color: Colors.purple)),
                    decoration: BoxDecoration(
                        // color: Colors.purple,
                        border: Border.all(color: Colors.purple),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Material(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, 'remove');
                  },
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Ink(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Text('Clear Cart',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    },
  );
}
