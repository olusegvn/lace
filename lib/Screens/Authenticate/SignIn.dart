import 'package:flutter/material.dart';
import 'package:safh/Services/Auth.dart';
import 'package:safh/models/laceSnackBar.dart';
import 'package:safh/models/showAlert.dart';
import 'package:safh/shared/loading.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String username = "";
  String password = "";
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final showAlert = ShowAlert();
  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
       body: Center(
         child: Container(
           child: Form(
             key: _formKey,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text(
                     "lace",
                   style: TextStyle(
                     fontSize: 60,
                     fontWeight: FontWeight.w100,
                     letterSpacing: 2.0,
                   ),
                 )
                 ,
                 SizedBox(height: 10),

                 Container(
                   margin:  EdgeInsets.symmetric(vertical: 15),
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   height: 43,
                   width: MediaQuery.of(context).size.width/1.3,
                   decoration: BoxDecoration(
                       border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                   ),
                   child: TextFormField(
                       validator: (val) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())? null : "Invalid E-Mail",
                       cursorColor: Colors.black,
                       style: TextStyle(
                         fontWeight: FontWeight.w300,
                         fontSize: 18,
                       ),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: "Username",
                       ),
                       onChanged: (value){username = value.trim();}),
                 ),
                 Container(
                   margin:  EdgeInsets.symmetric(vertical: 15),
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   height: 43,
                   width: MediaQuery.of(context).size.width/1.3,
                   decoration: BoxDecoration(
                       border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                   ),
                   child: TextFormField(
                       validator: (val) => val.length < 8? "Password must be more than 8 charecters.": null,
                       cursorColor: Colors.black,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                      obscureText: true,
                      onChanged: (value){password = value.trim();}),
                 ),
                 SizedBox(height: 5,),
                 Container(
                   height: 50,
                   width: MediaQuery.of(context).size.width/1.3,
                   child: FlatButton(
                     color: Colors.black,
                     splashColor: Colors.white,
                     onPressed: () async{
                       if(_formKey.currentState.validate()){
                         setState(() {
                           loading = true;
                         });
                         dynamic result = await _auth.signInUserWithEmailAndPassword(username, password);
                         if(result == null){
                           LaceSnackBar().showSnackBar(context, 'Failed to Sign In.\nPlease check form and try again.', Colors.redAccent[100]);
                           setState(() {loading = false;});
                         }else{
                         }
                       };
                     },
                     child: Text(
                       "Login",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 17,
                         fontWeight: FontWeight.w300,
                       ),

                     ),
                   ),
                 ),
                 Container(
                   height: 50,
                   width: MediaQuery.of(context).size.width/1.3,
                   child: FlatButton(
                     splashColor: Colors.black54,
                     color: Colors.white,
                     onPressed: (){widget.toggleView();setState(() {loading = true;});},
                     child: Text(
                       "Sign Up",
                       style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                       ),
                     ),
                   ),
                 )
               ],
             ),
           ),
         ),
       ),
    );
  }

  void validate(){

  }
}
