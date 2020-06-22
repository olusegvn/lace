import 'dart:io';

import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

typedef void StringCallback(String val);
class LaceSearchableDropDown extends StatefulWidget {
  String subject;
  final dynamic listItems;
  final StringCallback callback;
  final Color underlineColor;
  LaceSearchableDropDown({this.listItems, this.subject, this.callback, this.underlineColor});
  @override
  _LaceSearchableDropDownState createState() => _LaceSearchableDropDownState();
}

class _LaceSearchableDropDownState extends State<LaceSearchableDropDown> {
  @override
  Widget build(BuildContext context) {
    return   SearchableDropdown.single(
      value: widget.subject,
      hint: widget.subject,
      clearIcon: Icon(Icons.clear, color: widget.underlineColor,),
      iconEnabledColor: widget.underlineColor,
      iconDisabledColor: Colors.grey,
      menuBackgroundColor: Colors.white,
      dialogBox: false,
      menuConstraints: BoxConstraints(
        minHeight: 10,
        minWidth: 300,
        maxHeight: 400,
        maxWidth: 2000,
      ),

      isExpanded: true,
      underline: Container(
        height: 1.3,
        color: widget.underlineColor,
      ),
      style: TextStyle(
          letterSpacing: 1.5,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.black
      ),

      items: widget.listItems,
      onChanged: (val) => widget.callback(val),
    );
  }
}
