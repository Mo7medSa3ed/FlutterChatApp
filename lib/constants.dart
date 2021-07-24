import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 16.0;


goTo(context,screan){
  return Navigator.of(context).push(MaterialPageRoute(builder: (_)=>screan));
}
goToWithReplaceMent(context,screan){
  return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>screan));
}
goToWithRemoveUntill(context,screan){
  return Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>screan) , (r)=>false);
}