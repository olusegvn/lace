import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  double width;
  double height;
  dynamic userData;
  ProfilePicture({this.userData, this.width, this.height});
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    try{
      return Container(
        height: widget.height?? 35,
        width: widget.width?? 35,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          image: DecorationImage(image: NetworkImage(widget.userData['profilePictureUrl']),fit: BoxFit.cover),
        ),
      );
    }catch(e){
      return Icon(Icons.person_pin, size: 150,);
    }
  }
}
