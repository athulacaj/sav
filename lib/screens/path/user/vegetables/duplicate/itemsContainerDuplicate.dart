import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sav/functions/quantityFormat.dart';
import 'package:sav/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? _showSpinner;
bool disposing = false;

class ItemsContainer extends StatefulWidget {
  final String? image;
  final String? title;
  final amount;
  final int? quantity;
  final String? unit;
  final int? index;
  final String? imageType;
  final String? shopName;
  final bool? available;
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
      required this.isClosed,
      this.unit});

  @override
  _ItemsContainerState createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  int? _quantity = 0;
  int? _amount = 0;
  var _image;
  var _name;
  var index;
  var _unit;
  String? _shopName;
  List<String> _cartItemsList = [];
  AnimationController? rotationController;
  void _onpress;

  @override
  void initState() {
    _showSpinner = true;
    disposing = false;
    initFunctions();
    _quantity = widget.quantity;
// pasted here to test there is blink effect;
    super.initState();
  }

  void initFunctions() {
    _image = widget.image;
    _amount = widget.amount;
    index = widget.index;
    _unit = widget.unit;
    _shopName = widget.shopName ?? '';
    _name = '${widget.title}:$_shopName';
  }

  void onPressed(String whatButton) async {
    Map individualItem = {
      'name': '$_name',
      'image': '$_image',
      'amount': _amount,
      'quantity': _quantity,
      'baseAmount': widget.amount,
      'unit': _unit,
      'baseQuantity': widget.quantity,
      'shopName': '$_shopName',
      'imageType': widget.imageType,
    };
    if (_quantity! > 0) {
      print('quantity $_quantity');
      Provider.of<IsInListProvider>(context, listen: false)
          .addAllDetails(individualItem, context);
    } else {
      if (whatButton == 'add') {
        _amount = widget.amount;
        _quantity = widget.quantity;
        Map individualItem = {
          'name': '$_name',
          'image': '$_image',
          'amount': _amount,
          'unit': _unit,
          'quantity': _quantity,
          'baseAmount': widget.amount,
          'baseQuantity': widget.quantity,
          'shopName': '$_shopName',
          'imageType': widget.imageType,
        };
        Provider.of<IsInListProvider>(context, listen: false)
            .addAllDetails(individualItem, context);
      } else {
        Provider.of<IsInListProvider>(context, listen: false).removeByName(_name);
      }
    }
  }

  void getProviderData() async {
    if (disposing == false) {
      await Future.delayed(Duration(milliseconds: 100));
      initFunctions();

      var dataByName =
          Provider.of<IsInListProvider>(context, listen: false).getDetailsByName(_name);
      _amount = dataByName != null ? dataByName['amount'] : 0;
      _quantity = dataByName != null ? dataByName['quantity'] : 0;
    }
  }

  @override
  void dispose() {
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
    getProviderData();
    initFunctions();
    return Padding(
      padding: EdgeInsets.only(left: 6),
      child: Container(
        height: 105,
        margin: EdgeInsets.only(bottom: 5),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 70,
                      height: 60,
                      child: widget.imageType != 'offline'
                          ? CachedNetworkImage(
                              imageUrl: '${widget.image}',
                              fit: BoxFit.fill,
                              placeholder: (context, url) => SpinKitThreeBounce(
                                color: Colors.grey,
                                size: 20.0,
                              ),
                            )
                          : Image.asset(
                              '${widget.image}',
                              fit: BoxFit.fill,
                            )),
                  SizedBox(width: 8),
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
                            Expanded(
                              child: AutoSizeText(
                                '${_name.split(':')[0]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            Text(
                              '₹ ${widget.amount} ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.5),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            Text(
                              '${widget.quantity} ${widget.unit}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13.5),
                            ),
                            Spacer(),
                            // minus and add
                            Consumer<IsInListProvider>(
                              builder: (context, isInList, child) {
                                var _detail;
                                var _allDetails = isInList.allDetails;
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
                                                              IsInListProvider>(context,
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
                                                    _quantity = _quantity! -
                                                        widget.quantity!;
                                                    _amount = _amount! -
                                                        widget.amount as int?;

                                                    onPressed('null');
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
                                                              IsInListProvider>(context,
                                                          listen: false)
                                                      .getDetailsByName(_name);
                                                  _amount = dataByName != null
                                                      ? dataByName['amount']
                                                      : 0;
                                                  _quantity = dataByName != null
                                                      ? dataByName['quantity']
                                                      : 0;
//
                                                  _quantity = _quantity! +
                                                      widget.quantity!;
                                                  _amount = _amount! +
                                                      widget.amount as int?;
                                                  onPressed('null');
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
                            Container(
                              alignment: Alignment.center,
                              child: Consumer<IsInListProvider>(
                                  builder: (context, isInList, child) {
                                var _detail;
                                var _allDetails = isInList.allDetails;
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
                                  width: _detail == true ? 0 : 100,
                                  child: AnimatedContainer(
                                    height: _detail == true ? 0 : 30,
                                    duration: Duration(milliseconds: 80),
                                    child: Padding(
                                      padding: _detail == true
                                          ? EdgeInsets.all(0)
                                          : EdgeInsets.all(0),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            onPressed('add');
                                          },
                                          child: _detail == true
                                              ? null
                                              : Container(
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff36b58b)),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  child: Text(
                                                    'ADD',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff36b58b),
                                                        fontWeight:
                                                            FontWeight.w600),
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
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            widget.available == false || widget.isClosed
                ? GestureDetector(
                    child: Container(
                      height: double.infinity,
                      color: Colors.grey.withOpacity(0.25),
                    ),
                    onTap: () {},
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
