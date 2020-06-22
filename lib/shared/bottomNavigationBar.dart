import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safh/Screens/Help/helpDesk.dart';
import 'package:safh/Screens/Home/Home.dart';
import 'package:safh/Screens/wallet/wallet.dart';

class LaceBottomNavBar extends StatefulWidget {
  final Function showScreen;
  final Function callback;
  LaceBottomNavBar({this.showScreen, this.callback});
  @override
  _LaceBottomNavBarState createState() => _LaceBottomNavBarState();
}

class _LaceBottomNavBarState extends State<LaceBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: (int index) => changeScreen(index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet, color: Colors.black, size: 25,),
            title: Text(
              "Wallet",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            backgroundColor: Colors.white,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.compare, color: Colors.black, size: 40,),
            title: Text(
              "Gallery",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            backgroundColor: Colors.white,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.black, size: 25,),
            title: Text(
              "Help",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            backgroundColor: Colors.white,
          ),

        ],
      ),
    );
  }

  void changeScreen(int index){
    print(index);
    switch(index){
      case 0:
        {
          widget.callback();
          widget.showScreen(Wallet(showScreen: widget.showScreen));
          break;
        }
      case 1:
        {
          widget.callback();
          widget.showScreen(Home(showScreen: widget.showScreen));
          break;
        }

      case 2:
        {
          widget.callback();
          widget.showScreen(HelpDesk(showScreen: widget.showScreen));
          break;
        }
    }
  }
}
