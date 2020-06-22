import 'package:flutter/material.dart';

typedef void StringCallback(String val);
class LaceInputField extends StatefulWidget {
  String label;
  double height;
  double width;
  EdgeInsets padding;
  EdgeInsets margin;
  Color borderColor;
  dynamic validator;
  TextInputType keyboardType;
  final StringCallback callback;
  LaceInputField({this.label, this.height, this.width, this.callback, this.validator, this.padding, this.margin, this.keyboardType, this.borderColor});
  @override
  _LaceInputFieldState createState() => _LaceInputFieldState();
}

class _LaceInputFieldState extends State<LaceInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide(width: 1, color: widget.borderColor?? Colors.black))
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType,
          validator: (val) => val.isEmpty? "Field is Empty": null,
          cursorColor: Colors.black,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.label,
          ),
          onChanged: (val) => widget.callback(val)),
    );
  }
}





