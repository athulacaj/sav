import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget {
  final String? title;
  final String? whichScreen;
  CommonAppbar({this.title, this.whichScreen});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 5),
              Text(
                '$title',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 16),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (whichScreen == 'MyOrders') {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'Home_Screen', (Route<dynamic> route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Color(0xff36b58b),
            border: Border(
              bottom:
                  BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.5)),
            )),
      ),
    );
  }
}
