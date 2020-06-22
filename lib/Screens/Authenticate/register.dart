import 'package:flutter/material.dart';
import 'package:safh/Services/Auth.dart';
import 'package:safh/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  bool loading;
  Register({this.toggleView, this.loading=false});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String firstname;
  String lastname;
  String email;
  String phoneNo;
  String password;
  String confirmPassword;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return widget.loading? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: SingleChildScrollView(
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
                          validator: (val) => val.isEmpty? "First Name Field is empty": null,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "First Name",
                            ),
                            onChanged: (value){firstname = value.trim();}),
                      ),Container(
                        margin:  EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 43,
                        width: MediaQuery.of(context).size.width/1.3,
                        decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                        ),
                        child: TextFormField(
                            validator: (val) => val.isEmpty? "Last Name Field is empty": null,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Last Name",
                            ),
                            onChanged: (value){lastname = value.trim();}),
                      ),
                      Container(
                        margin:  EdgeInsets.symmetric( vertical: 15),
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
                              hintText: "E-Mail",
                            ),
                            onChanged: (value){email = value.trim();}),
                      ),
                      Container(
                        margin:  EdgeInsets.symmetric( vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 43,
                        width: MediaQuery.of(context).size.width/1.3,
                        decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                        ),
                        child: TextFormField(
                            validator:(val) => RegExp(r'\+\d{14}').hasMatch(val)? "Last Name Field is empty": null,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                            ),
                            onChanged: (value){phoneNo = value.trim();}),
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
                            validator: (val) => val.length < 7? "Password must be more than 7 charecters.": null,
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
                      Container(
                        margin:  EdgeInsets.symmetric( vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 43,
                        width: MediaQuery.of(context).size.width/1.3,
                        decoration: BoxDecoration(
                            border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.black))
                        ),
                        child: TextFormField(
                            validator: (val) => val != password? "Password does not match": null,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                            ),
                            obscureText: true,
                            onChanged: (value){confirmPassword = value.trim();}),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        height: 50,
                        child: FlatButton(
                          color: Colors.black,
                          splashColor: Colors.white,
                          onPressed: () async{
                            if(_formKey.currentState.validate()){
                              setState(() {widget.loading = true;});
                              dynamic result = await _auth.registerUserWithEmailAndPassword(firstname=firstname, lastname=lastname, email=email, phoneNo=phoneNo, password=password);
                              if(result == null){
                                showAlert(context, "Failed !", "Failed to create E-Mail Account.\nPlease check form and try again.", Colors.redAccent[100]);
                                setState(() {widget.loading = false;});
                              }else{
                                showAlert(context, "Success !", "Account Successfully created.", Colors.greenAccent[100]);
                              }
                            };
                          },
                          child: Text(
                            "Sign Up",
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
                          onPressed: (){setState(() {widget.loading = true;});widget.toggleView();},
                          child: Text(
                            "Login" ,
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
      ),
    );
  }
  void register(){

  }
  void showAlert(BuildContext context, String title, String content, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        backgroundColor: color,
      )
    );
  }
}
