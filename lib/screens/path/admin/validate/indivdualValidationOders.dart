import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/providers/provider.dart';

class IndividualValidationOrders extends StatefulWidget {
  final Map singleOrderList;
  final String name;
  IndividualValidationOrders(
      {required this.singleOrderList, required this.name});
  @override
  _IndividualValidationOrdersState createState() =>
      _IndividualValidationOrdersState();
}

class _IndividualValidationOrdersState
    extends State<IndividualValidationOrders> {
  @override
  Widget build(BuildContext context) {
    List itemsList = widget.singleOrderList['details'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36b58b),
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itemsList.length,
                itemBuilder: (BuildContext context, int i) {
                  Map order = itemsList[i];
                  return Container(
                    // height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['name'],
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${order['quantity']} ${order['unit']}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 6),
            FlatButton(
                color: Colors.greenAccent,
                onPressed: () {
                  IsInListProvider isInListProvider =
                      Provider.of<IsInListProvider>(context, listen: false);
                  isInListProvider.fromOrdersToCart(itemsList);
                  print(widget.singleOrderList['userData']);
                  isInListProvider.addUser(widget.singleOrderList['userData']);
                  showToast("${itemsList.length} Items Added to cart");
                },
                child: Text("Add to cart"))
          ],
        ),
      ),
    );
  }
}
