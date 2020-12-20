import 'package:flutter/material.dart';

const KTabTextStyle = TextStyle(fontSize: 16);
BoxDecoration contaionerButtonDecoration = BoxDecoration(
  border: Border.all(color: Colors.purple),
  borderRadius: BorderRadius.all(Radius.circular(11)),
);
BoxDecoration contaionerBlackOutlineButtonDecoration = BoxDecoration(
  border: Border.all(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(4)),
);

InputDecoration textFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 12),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
);
