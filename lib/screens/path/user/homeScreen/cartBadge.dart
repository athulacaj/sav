import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/screens/path/user/CartPage/cartPage.dart';

class CartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<IsInListProvider>(builder: (context, isInList, child) {
      var _allDetailsList = isInList.allDetails ;

      return IconButton(
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return CartPage();
          }, transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
        },
        icon: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
                left: 0,
                top: 4,
              ),
//              TweenAnimationBuilder(
//                duration: Duration(milliseconds: 1000),
//                tween: Tween<double>(begin: -10, end: 0),
//                curve: Curves.easeInOutBack,
//                builder: (BuildContext context, double value, Widget child) {
//                  return Positioned(
//                    right: 3,
//                    top: value,
//                    child: Container(
//                      child: Text(
//                        '${_allDetailsList.length}',
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 11),
//                      ),
//                      height: 17,
//                      width: 17,
//                      alignment: Alignment.center,
//                      decoration: BoxDecoration(
//                          color: Colors.redAccent,
//                          borderRadius: BorderRadius.all(Radius.circular(50))),
//                    ),
//                  );
//                },
//              ),
              _allDetailsList.length.isEven && _allDetailsList.length > 1
                  ? createCartAnimation(_allDetailsList)
                  : Container(),
              _allDetailsList.length.isOdd
                  ? createCartAnimation(_allDetailsList)
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}

createCartAnimation(var _allDetailsList) {
  return TweenAnimationBuilder(
    duration: Duration(milliseconds: 400),
    tween: Tween<double>(begin: -10, end: 0),
    curve: Curves.easeInOutBack,
    builder: (BuildContext context, double value, Widget? child) {
      return Positioned(
        right: 3,
        top: value,
        child: Container(
          child: Text(
            '${_allDetailsList.length}',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
          ),
          height: 17,
          width: 17,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      );
    },
  );
}
