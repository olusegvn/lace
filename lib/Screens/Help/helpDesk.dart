import 'package:flutter/material.dart';
import 'package:safh/shared/bottomNavigationBar.dart';
import 'package:safh/shared/loading.dart';


class HelpDesk extends StatefulWidget {
  Function showScreen;
  bool loading;
  HelpDesk({this.showScreen, this.loading=false});
  @override
  _HelpDeskState createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  @override
  Widget build(BuildContext context) {
    return widget.loading? Loading(): Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Icon(Icons.help, color: Colors.black, size: 40,),
        title: Text(
          'Help',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Please Contact",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 40
              ),
            ),
            Text(
              "thelaceapp@gmail.com",
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 40
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: LaceBottomNavBar(showScreen: widget.showScreen,callback: (){setState(() {widget.loading = true;});}),
    );
  }
}
