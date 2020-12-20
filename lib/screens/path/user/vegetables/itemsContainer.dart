import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sav/functions/quantityFormat.dart';
import 'package:sav/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';

bool _showSpinner;
bool disposing = false;

class ItemsContainer extends StatefulWidget {
  final String image;
  final String title;
  final String en;
  final amount;
  final int quantity;
  final String unit;
  final int index;
  final String imageType;
  final String shopName;
  final bool available;
  final bool isClosed;
  ItemsContainer(
      {this.image,
      this.title,
      this.amount,
      this.index,
      this.quantity,
      this.shopName,
      this.imageType,
      this.available,
      @required this.en,
      @required this.isClosed,
      this.unit});

  @override
  _ItemsContainerState createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  var _quantity = 0;
  var _amount = 0;
  var _image;
  var _name;
  var index;
  var _unit;
  String _shopName;
  List<String> _cartItemsList = [];
  AnimationController rotationController;
  void _onpress;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    _showSpinner = true;
    disposing = false;
    initFunctions();
    _quantity = widget.quantity;
    _textEditingController.text = '1';
// pasted here to test there is blink effect;
//     KeyboardVisibilityNotification().addNewListener(onHide: () {
//       _scrollController.animateTo(0,
//           duration: Duration(milliseconds: 200), curve: Curves.linear);
//     });
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    print('changed focus');
  }

  void initFunctions() {
    _image = widget.image;
    _amount = widget.amount;
    index = widget.index;
    _unit = widget.unit;
    _shopName = widget.shopName ?? '';
    _name = '${widget.title}';
  }

  void onPressed(String whatButton, int inputQuantity) async {
    Map individualItem = {
      'name': '$_name',
      'en': widget.en,
      'image': '$_image',
      'amount': _amount,
      'quantity': inputQuantity,
      'baseAmount': widget.amount,
      'unit': _unit,
      'baseQuantity': widget.quantity,
      'shopName': '$_shopName',
      'imageType': widget.imageType,
    };
    if (inputQuantity > 0) {
      print('quantity $inputQuantity');
      Provider.of<IsInList>(context, listen: false)
          .addAllDetails(individualItem, context);
    } else {
      if (whatButton == 'add') {
        _amount = widget.amount;
        _quantity = inputQuantity;
        Map individualItem = {
          'name': '$_name',
          'image': '$_image',
          'amount': _amount,
          'unit': _unit,
          'quantity': inputQuantity,
          'baseAmount': widget.amount,
          'baseQuantity': widget.quantity,
          'shopName': '$_shopName',
          'imageType': widget.imageType,
        };
        Provider.of<IsInList>(context, listen: false)
            .addAllDetails(individualItem, context);
      } else {
        Provider.of<IsInList>(context, listen: false).removeByName(_name);
      }
    }
  }

  void getProviderData() async {
    if (disposing == false) {
      await Future.delayed(Duration(milliseconds: 100));
      initFunctions();

      var dataByName =
          Provider.of<IsInList>(context, listen: false).getDetailsByName(_name);
      _amount = dataByName != null ? dataByName['amount'] : 0;
      _quantity = dataByName != null ? dataByName['quantity'] : 0;
    }
  }

  @override
  void dispose() {
    // TODO: implement
    _quantity = 0;
    _amount = 0;
    _image = '';
    _name = '';
    var index;
    var _unit;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getProviderData();
    initFunctions();
    bool _detail = false;
    var _providerDataList = Provider.of<IsInList>(context).allDetails ?? [];
    Map providerData;
    for (var _details in _providerDataList) {
      if (_details['name'] == _name) {
        _detail = true;
        providerData = _details;
        break;
      } else {
        _detail = false;
      }
    }
    return InkWell(
      onTap: () {
        showBottomSheet();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                    width: size.width / 3 - 8.7,
                    height: 120,
                    child: widget.imageType != 'offline'
                        ? CachedNetworkImage(
                            imageUrl: '${widget.image}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SpinKitThreeBounce(
                              color: Colors.grey,
                              size: 20.0,
                            ),
                          )
                        : Image.asset(
                            '${widget.image}',
                            fit: BoxFit.cover,
                          )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width / 3 - 8.7,
                    height: 40,
                    child: Column(
                      children: [
                        Spacer(),
                        AutoSizeText(
                          '${_name.split(':')[0]} ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.black12.withOpacity(0.05),
                          Colors.black45
                        ])),
                  ),
                ),
                _detail == true
                    ? Positioned(
                        child: Container(
                        width: size.width / 3 - 8.7,
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${providerData['quantity']} kg',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        color: Color(0xffFFF200),
                      ))
                    : Container(),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }

  Future<List> showBottomSheet() {
    return showModalBottomSheet<List>(
      isScrollControlled: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        int selectedDeliveryBoy = -1;
        int selectedShop = -1;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size size = MediaQuery.of(context).size;
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
                          child: widget.imageType != 'offline'
                              ? CachedNetworkImage(
                                  imageUrl: '${widget.image}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      SpinKitThreeBounce(
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                                )
                              : Image.asset(
                                  '${widget.image}',
                                  fit: BoxFit.cover,
                                )),
                      Material(
                        color: Colors.white,
                        elevation: 4,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: AutoSizeText(
                            '${_name.split(':')[0]}',
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
                          alignment: Alignment.center,
                          child: SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  child: TextField(
                                    focusNode: _focus,
                                    controller: _textEditingController,
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      _scrollController.animateTo(130,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.linear);
                                    },
                                    decoration: InputDecoration(
                                      //fillColor: Colors.green
                                      hintText: 'quantity',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefix: Text(
                                        'Qty : ',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      suffix: Text(
                                        'kg',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                  width: 100,
                                ),
                              ],
                            ),
                            width: 150,
                          ),
                          height: 50,
                          width: size.width - 136,
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Consumer<IsInList>(
                                  builder: (context, isInList, child) {
                                var _detail;
                                var _allDetails = isInList.allDetails ?? [];
                                for (var _details in _allDetails) {
                                  if (_details['name'] == _name) {
                                    _detail = true;
                                    break;
                                  } else {
                                    _detail = false;
                                  }
                                }
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 80),
                                  // width: _detail == true ? 0 : 120,
                                  width: 120,
                                  child: AnimatedContainer(
                                    height: 50,
                                    // height: _detail == true ? 0 : 50,
                                    duration: Duration(milliseconds: 80),
                                    child: Padding(
                                      padding: _detail == true
                                          ? EdgeInsets.all(0)
                                          : EdgeInsets.all(0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                              _scrollController.animateTo(0,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.linear);
                                            }
                                            Navigator.pop(context);
                                            onPressed(
                                                'add',
                                                int.parse(_textEditingController
                                                    .text));
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
                                );
                              }),
                            ),
                            SizedBox(height: 20),
                            Container(
                              child: Consumer<IsInList>(
                                  builder: (context, isInList, child) {
                                var _detail;
                                var _allDetails = isInList.allDetails ?? [];
                                for (var _details in _allDetails) {
                                  if (_details['name'] == _name) {
                                    _detail = true;
                                    break;
                                  } else {
                                    _detail = false;
                                  }
                                }
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 80),
                                  width: _detail == true ? 120 : 0,
                                  // width: 120,
                                  child: AnimatedContainer(
                                    // height: 50,
                                    height: _detail == true ? 50 : 0,
                                    duration: Duration(milliseconds: 80),
                                    child: Padding(
                                      padding: _detail == true
                                          ? EdgeInsets.all(0)
                                          : EdgeInsets.all(0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<IsInList>(context,
                                                    listen: false)
                                                .removeByName(_name);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.redAccent),
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
                                );
                              }),
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
                            Consumer<IsInList>(
                              builder: (context, isInList, child) {
                                var _detail;
                                var _allDetails = isInList.allDetails ?? [];
                                for (var _details in _allDetails) {
                                  if (_details['name'] == _name) {
                                    _detail = true;
                                    break;
                                  } else {
                                    _detail = false;
                                  }
                                }
                                getProviderData();
                                return _detail == true
                                    ? Container(
                                        width: 110,
                                        child: Row(children: <Widget>[
                                          Material(
                                            child: Container(
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                child: Icon(Icons.remove,
                                                    size: 32,
                                                    color: Colors.white),
                                                onTap: () {
//
                                                  var dataByName = Provider.of<
                                                              IsInList>(context,
                                                          listen: false)
                                                      .getDetailsByName(_name);
                                                  _amount = dataByName != null
                                                      ? dataByName['amount']
                                                      : 0;
                                                  _quantity = dataByName != null
                                                      ? dataByName['quantity']
                                                      : 0;
//
                                                  if (_quantity != 0) {
                                                    _quantity = _quantity -
                                                        widget.quantity;
                                                    _amount =
                                                        _amount - widget.amount;

                                                    // onPressed('null');
                                                  }
                                                },
                                                splashColor: Colors.white70,
                                              ),
                                              height: 35,
                                            ),
                                            color: Color(0xff36b58b),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                topLeft: Radius.circular(5)),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: AutoSizeText(
                                              '${quantityFormat(_quantity, _unit)}',
                                              style: TextStyle(
                                                  color: Color(0xff36b58b),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 1,
                                            ),
                                            alignment: Alignment.center,
                                            height: 35,
                                            width: 40,
                                          ),
                                          Spacer(),
                                          Material(
                                            color: Color(0xff36b58b),
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            child: Container(
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                child: Icon(Icons.add,
                                                    size: 32,
                                                    color: Colors.white),
                                                onTap: () {
                                                  var dataByName = Provider.of<
                                                              IsInList>(context,
                                                          listen: false)
                                                      .getDetailsByName(_name);
                                                  _amount = dataByName != null
                                                      ? dataByName['amount']
                                                      : 0;
                                                  _quantity = dataByName != null
                                                      ? dataByName['quantity']
                                                      : 0;
//
                                                  _quantity = _quantity +
                                                      widget.quantity;
                                                  _amount =
                                                      _amount + widget.amount;
                                                  // onPressed('null');
                                                  setState(() {});
                                                },
                                                splashColor: Colors.white70,
                                              ),
                                              height: 35,
                                            ),
                                          ),
                                        ]),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.blueGrey
                                                  .withOpacity(0.5)),
                                        ))
                                    : Container();
                              },
                            ),
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
}
