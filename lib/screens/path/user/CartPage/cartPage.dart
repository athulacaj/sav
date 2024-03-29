import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'cartDatabase.dart';
import 'deliverySlot.dart';
import 'orderSucessFulPage.dart';

int? _minimumAmount;
bool? _showSpinner;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController _scrollController = ScrollController();
  FocusNode _focus = new FocusNode();
  @override
  void initState() {
    _minimumAmount = 0;
    _showSpinner = true;
    initFunctions();
    super.initState();
  }

  void initFunctions() async {
    _minimumAmount = 0;
    setState(() {
      _showSpinner = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IsInListProvider>(
      builder: (context, isInListProvider, child) {
        var _allDetailsList = isInListProvider.allDetails;
        // var totalAmount = isInList.totalAmount ?? 0;
        Size size = MediaQuery.of(context).size;

        return ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 30,
                      color: Color(0xff36b58b),
                    ),
                    SafeArea(
                      child: Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Your Cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close, size: 30)),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.grey.withOpacity(0.5)),
                            )),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          childAspectRatio: .8,
                          mainAxisSpacing: 5),
                      padding: EdgeInsets.all(0),
                      itemCount: _allDetailsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          delay: Duration(milliseconds: 100),
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 100.0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all((Radius.circular(3))),
                                    child: Container(
//
                                        height: 40,
                                        width: 40,
                                        child: _allDetailsList[index]
                                                    ['imageType'] ==
                                                'offline'
                                            ? Image.asset(
                                                '${_allDetailsList[index]['image']}',
                                                fit: BoxFit.fill,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    '${_allDetailsList[index]['image']}',
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    SpinKitThreeBounce(
                                                  color: Colors.grey,
                                                  size: 20.0,
                                                ),
                                              )),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    child: Text(
                                      '${_allDetailsList[index]['name']}'
                                          .split(':')[0],
                                      textAlign: TextAlign.left,
                                    ),
                                    width: double.infinity,
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    child: Text(
                                      '${_allDetailsList[index]['quantity']} ${_allDetailsList[index]['unit']}'
                                          .split(':')[0],
                                      textAlign: TextAlign.left,
                                    ),
                                    width: double.infinity,
                                  ),
                                  Spacer(),
                                  TextButton(
                                    child: Text('Edit',
                                        style: TextStyle(color: Colors.teal)),
                                    onPressed: () {
                                      showBottomSheet(_allDetailsList[index]);
                                    },
                                  ),
                                  Spacer(),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.withOpacity(0.5)),
                                    right: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.withOpacity(0.5)),
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _allDetailsList.length < 1
                    ? Expanded(
                        flex: 35,
                        child: Container(
                          child: Icon(
                            Icons.remove_shopping_cart,
                            color: Color(0xff36b58b),
                            size: 100,
                          ),
                        ),
                      )
                    : Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            border: Border(
                              top: BorderSide(
                                  width: 0.5,
                                  color: Colors.grey.withOpacity(0.5)),
                              bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.grey.withOpacity(0.5)),
                            )),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Provider.of<IsInListProvider>(context,
                                        listen: false)
                                    .removeAllDetails();
                                setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.delete,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.8)),
                                  Text('Empty Cart'),
                                ],
                              ),
                            ),
                            Spacer(),
                            Text('items:  ',
                                style: TextStyle(color: Colors.black)),
                            Consumer<IsInListProvider>(
                                builder: (context, isInList, child) {
                              return Text(
                                '${isInList.allDetails.length}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Colors.black),
                              );
                            }),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Quantity:  ',
                                style: TextStyle(color: Colors.black)),
                            Consumer<IsInListProvider>(
                                builder: (context, isInList, child) {
                              return Text(
                                '${isInList.totalQ} kg',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Colors.black),
                              );
                            }),
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                _allDetailsList.length < 1
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          color: Color(0xff36b58b),
                          alignment: Alignment.center,
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Map _userDetails = isInListProvider.userDetails!;
                          bool _isAdmin = _userDetails['isAdmin'] != null &&
                              _userDetails['isAdmin'];
                          List<DocumentSnapshot<Map<String, dynamic>>>
                              customerDatabaseList = [];
                          if (_isAdmin) {
                            _showSpinner = true;
                            setState(() {});
                            try {
                              customerDatabaseList = await FirebaseFirestore
                                  .instance
                                  .collection("customers")
                                  .orderBy("name", descending: false)
                                  .get()
                                  .then((value) => value.docs);
                              customerDatabaseList.removeAt(0);
                              customerDatabaseList =
                                  customerDatabaseList.reversed.toList();
                            } catch (e) {
                              print(e);
                            }
                            _showSpinner = false;
                            setState(() {});
                          }
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                            return DeliverySlot(
                                customerDatabaseList:
                                    _isAdmin ? customerDatabaseList : null);
                          }, transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset(0.0, 0.0);
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          }));
                        },
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          color: Color(0xff36b58b),
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              )),
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  String unit = 'kg';
  Future<List?> showBottomSheet(var _allDetailsList) {
    unit = _allDetailsList['unit'];
    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = _allDetailsList['quantity'].toString();
    return showModalBottomSheet<List>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        int selectedDeliveryBoy = -1;
        int selectedShop = -1;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size size = MediaQuery.of(context).size;
          Widget dropDown = DropdownButton<String>(
            value: unit,
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            iconSize: 30,
            elevation: 6,
            style: const TextStyle(color: Colors.blue, fontSize: 18),
            onChanged: (String? newValue) {
              setState(() {
                unit = newValue!;
              });
            },
            items: <String>['kg', 'no']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );

          return SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.all(8),
              height: size.height - 100,
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Stack(
                    children: [
                      Container(
                          width: size.width,
                          height: 140,
                          child: _allDetailsList['imageType'] != 'offline'
                              ? CachedNetworkImage(
                                  imageUrl: '${_allDetailsList['image']}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      SpinKitThreeBounce(
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                                )
                              : Image.asset(
                                  '${_allDetailsList['image']}',
                                  fit: BoxFit.cover,
                                )),
                      Material(
                        color: Colors.white,
                        elevation: 4,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: AutoSizeText(
                            '${_allDetailsList['name'].split(':')[0]}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: size.height - 451,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: TextField(
                                    controller: _textEditingController,
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      // _scrollController.animateTo(130,
                                      //     duration: Duration(milliseconds: 200),
                                      //     curve: Curves.linear);
                                    },
                                    decoration: InputDecoration(
                                      //fillColor: Colors.green
                                      hintText: 'quantity',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefix: Text(
                                        'Qty : ',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                  width: 100,
                                ),
                                SizedBox(width: 10),
                                Container(
                                    alignment: Alignment.bottomCenter,
                                    child: dropDown)
                              ],
                            ),
                          ),
                          height: 50,
                          width: size.width - 136,
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 80),
                              // width: _detail == true ? 0 : 120,
                              width: 120,
                              child: AnimatedContainer(
                                height: 50,
                                // height: _detail == true ? 0 : 50,
                                duration: Duration(milliseconds: 80),
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                        _scrollController.animateTo(0,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.linear);
                                      }
                                      Navigator.pop(context);
                                      onPressed(
                                          'add',
                                          double.parse(
                                              _textEditingController.text),
                                          _allDetailsList);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff36b58b)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Text(
                                        'ADD',
                                        style: TextStyle(
                                            color: Color(0xff36b58b),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    splashColor: Colors.tealAccent,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 80),
                              width: 120,
                              // width: 120,
                              child: AnimatedContainer(
                                // height: 50,
                                height: 50,
                                duration: Duration(milliseconds: 80),
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<IsInListProvider>(context,
                                              listen: false)
                                          .removeByName(
                                              _allDetailsList['name']);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Text(
                                        "REMOVE",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    splashColor: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 17,
                              width: 17,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            Spacer(),
                            // minus and add
                            // add to cart button
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void onPressed(
      String whatButton, double inputQuantity, var _allDetailsList) async {
    if (whatButton == 'add') {
      Map individualItem = {
        'name': '${_allDetailsList['name']}',
        'en': '${_allDetailsList['en']}',
        'image': '${_allDetailsList['image']}',
        'amount': _allDetailsList['amount'],
        'unit': unit,
        'quantity': inputQuantity,
        'baseAmount': _allDetailsList['amount'],
        'baseQuantity': _allDetailsList['baseQuantity'],
        'shopName': '${_allDetailsList['shopName']}',
        'imageType': _allDetailsList['imageType'],
      };
      Provider.of<IsInListProvider>(context, listen: false)
          .addAllDetails(individualItem, context);
    } else {
      Provider.of<IsInListProvider>(context, listen: false)
          .removeByName(_allDetailsList['name']);
    }
  }
}
