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

bool? _showSpinner;
bool disposing = false;

class ItemsContainer extends StatefulWidget {
  final String? image;
  final String? title;
  final String en;
  final int? amount;
  final double? quantity;
  final String? unit;
  final int? index;
  final String? imageType;
  final String? shopName;
  final bool? available;
  final bool isClosed;
  final bool showFilterBox;
  ItemsContainer(
      {this.image,
      this.title,
      this.amount,
      this.index,
      this.quantity,
      this.shopName,
      this.imageType,
      this.available,
      required this.en,
      required this.isClosed,
      required this.showFilterBox,
      this.unit});

  @override
  _ItemsContainerState createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  double? _quantity = 0.0;
  int? _amount = 0;
  var _image;
  var _name;
  var index;
  var _unit;
  String? _shopName;
  List<String> _cartItemsList = [];
  AnimationController? rotationController;
  void _onpress;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _showSpinner = true;
    disposing = false;
    initFunctions();
    _quantity = widget.quantity;
    _textEditingController.text = '';
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

  void onPressed(String whatButton, double inputQuantity) async {
    Map individualItem = {
      'name': '$_name',
      'en': widget.en,
      'image': '$_image',
      'amount': _amount,
      'quantity': inputQuantity,
      'baseAmount': widget.amount,
      'unit': unit,
      'baseQuantity': widget.quantity,
      'shopName': '$_shopName',
      'imageType': widget.imageType,
    };
    if (inputQuantity > 0) {
      print('quantity $inputQuantity');
      Provider.of<IsInListProvider>(context, listen: false)
          .addAllDetails(individualItem, context);
    } else {
      if (whatButton == 'add') {
        _amount = widget.amount;
        _quantity = inputQuantity;
        Map individualItem = {
          'name': '$_name',
          'image': '$_image',
          'amount': _amount,
          'unit': unit,
          'quantity': inputQuantity,
          'baseAmount': widget.amount,
          'baseQuantity': widget.quantity,
          'shopName': '$_shopName',
          'imageType': widget.imageType,
        };
        Provider.of<IsInListProvider>(context, listen: false)
            .addAllDetails(individualItem, context);
      } else {
        Provider.of<IsInListProvider>(context, listen: false)
            .removeByName(_name);
      }
    }
  }

  void getProviderData() async {
    if (disposing == false) {
      await Future.delayed(Duration(milliseconds: 100));
      initFunctions();

      var dataByName = Provider.of<IsInListProvider>(context, listen: false)
          .getDetailsByName(_name);
      _amount = dataByName != null ? dataByName['amount'] : 0;
      _quantity = dataByName != null ? dataByName['quantity'] : 0.0;
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
    Size size = MediaQuery.of(context).size;
    // getProviderData();
    initFunctions();
    bool _detail = false;
    var _providerDataList =
        Provider.of<IsInListProvider>(context, listen: true).allDetails;
    Map? providerData;
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
        if (providerData != null) {
          _textEditingController.text = '${providerData['quantity']}';
        }
        showBottomSheet();
      },
      child: Container(
        // width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                      // width: size.width / 3 - 8.7,
                      width: ((size.width - 10) / 3) - 8.7,
                      height: 115,
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
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width / 3 - 8.7,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        Spacer(),
                        AutoSizeText(
                          '${_name.split(':')[0]}',
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
                          Colors.black12.withOpacity(0.3),
                          Colors.black45
                        ])),
                  ),
                ),
                _detail == true
                    ? Positioned(
                        child: Container(
                        // width: size.width / 3 - 8.7,
                        width: ((size.width - 10) / 3) - 8.7,
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${providerData!['quantity']} ${providerData['unit']}',
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
          color: Colors.grey,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }

  String unit = "kg";
  Future<List?> showBottomSheet() {
    unit = "kg";
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
            child: Container(
              padding: EdgeInsets.all(8),
              height: size.height - 200,
              // color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 90,
                          height: 70,
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
                      SizedBox(width: 20),
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
                                    onTap: () {},
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
                            Container(
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

                                            Navigator.pop(context);
                                            onPressed(
                                                'add',
                                                double.parse(
                                                    _textEditingController
                                                        .text));
                                            _textEditingController.clear();
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
                                            Provider.of<IsInListProvider>(
                                                    context,
                                                    listen: false)
                                                .removeByName(_name);
                                            _textEditingController.clear();
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
