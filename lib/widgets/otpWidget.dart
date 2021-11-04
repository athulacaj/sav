import 'package:flutter/material.dart';

class OtpWidget extends StatefulWidget {
  final TextEditingController parentTextEditingController;
  OtpWidget(this.parentTextEditingController);
  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  List<TextEditingController> controllerList = [];
  List<FocusNode> focusNodeList = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      TextEditingController textEditingController = TextEditingController();
      controllerList.add(textEditingController);
      FocusNode focusNode = FocusNode();
      focusNodeList.add(focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        child: Row(
          children: [
            for (int i = 0; i < 6; i++)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: controllerList[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    focusNode: focusNodeList[i],
                    onChanged: (String value) {
                      if (value.length == 0) {
                        focusNodeList[i].previousFocus();
                      } else {
                        focusNodeList[i].nextFocus();
                      }
                      controllOtpFields(i);
                    },
                  ),
                ),
              )
          ],
        ));
  }

  void controllOtpFields(int currentIndex) {
    TextEditingController currentController = controllerList[currentIndex];
    String enteredOtp = currentController.text;
    if (currentIndex == 5) {
      currentController.text = enteredOtp.substring(0, 1);
    } else if (enteredOtp.length > 1) {
      currentController.text = enteredOtp.substring(0, 1);
      controllerList[currentIndex + 1].text = enteredOtp.substring(1, 2);
    }
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp = otp + controllerList[i].text;
    }
    widget.parentTextEditingController.text = otp;
  }

  @override
  void deactivate() {
    super.deactivate();
    for (int i = 0; i < 6; i++) {
      controllerList[i].dispose();
      focusNodeList[i].dispose();
    }
  }
}
