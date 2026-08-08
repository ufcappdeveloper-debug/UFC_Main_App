import 'package:flutter/cupertino.dart';

Widget cupertinoLoading({EdgeInsetsGeometry? padding})=>
 Padding(
   padding: padding ?? EdgeInsets.all(0),
   child: CupertinoActivityIndicator(),
 );