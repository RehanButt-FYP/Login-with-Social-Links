import 'SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatefulWidget {
  SignUp ({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}


class _WelcomePageState extends State<SignUp > {


  final _formKey=GlobalKey<FormState>();     /////=====This variable use to validate form inputs
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  bool showProgressSpinner=false;
  String _name;
  String _password;
  String _email;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff413564),
          title: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Color(0xff634670),
        body: ModalProgressHUD(
          inAsyncCall: showProgressSpinner,
          child: SingleChildScrollView(
            child: Container(
              height: height/1.1,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff413564), Color(0xFF5F3567)],
                  )),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height / 40,
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: height / 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        width: width / 1.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: height / 60,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Container(
                              width: width / 1.2,
                              height: height / 15,
                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xff634670),
                                  //primaryColorDark: Colors.grey,
                                ),
                                child: Center(
                                  child: TextFormField(
                                    controller: _nameController,
                                    style: TextStyle(color: Colors.white70),
                                    cursorColor: Color(0xffcfbfd6),
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                        hintText: 'Ali talib',
                                        hintStyle: TextStyle(
                                          color: Color(0xffcfbfd6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white10,
                                        border: InputBorder.none

                                      //suffixStyle: const TextStyle(color: Colors.green)
                                    ),

                                    // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: height / 60,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Container(
                              width: width / 1.2,
                              height: height / 15,
                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xff634670),
                                  //primaryColorDark: Colors.grey,
                                ),
                                child: Center(
                                  child: TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(color: Colors.white70),
                                    cursorColor: Color(0xffcfbfd6),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                        hintText: 'helo@gmail.com',
                                        hintStyle: TextStyle(
                                          color: Color(0xffcfbfd6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white10,
                                        border: InputBorder.none

                                      //suffixStyle: const TextStyle(color: Colors.green)
                                    ),

                                    // The validator receives the text that the user has entered.
                                    validator: validateEmail
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: height / 60,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Container(
                              width: width / 1.2,
                              height: height / 15,
                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xff634670),
                                  //primaryColorDark: Colors.grey,
                                ),
                                child: Center(
                                  child: TextFormField(
                                    controller: _passController,
                                    style: TextStyle(color: Colors.white70),
                                    cursorColor: Color(0xffcfbfd6),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          color: Color(0xffcfbfd6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white10,
                                        border: InputBorder.none

                                      //suffixStyle: const TextStyle(color: Colors.green)
                                    ),

                                    // The validator receives the text that the user has entered.
                                    validator: validatePass,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),

                            SizedBox(
                              height: height / 20,
                            ),
                            ButtonTheme(
                              minWidth: width / 1.2,
                              height: height / 17,
                              child: FlatButton(
//                    shape: new RoundedRectangleBorder(
////                        borderRadius: new BorderRadius.circular(15.0),
////                        side: BorderSide(color: Color(0xffff351f)
////                        )
////                    ),
                                color: Colors.white,
                                textColor: Color(0xff634670),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: width / 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {

                                 _name=_nameController.text;
                                 _email=_emailController.text;
                                 _password=_passController.text;

                                  final form = _formKey.currentState;
                                  //////////////////////////////

                                  if (form.validate())
                                  {
                                    setState(() {
                                      showProgressSpinner=true;
                                    });
                                    print(_name);

                                    print(_email);

                                    print(_password);

                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(email: _email, password: _password)
                                        .then((AuthResult result) {

                                      FirebaseUser user = result.user;
//
//                                      DatabaseReference dbref=FirebaseDatabase.instance.reference().child('Broker').child(user.uid);
//                                      dbref.set({
//
//                                        'Name':_name,
//                                        'Email': user.email,
//
//                                      });

                                      setState(() {
                                        showProgressSpinner=false;
                                      });
//                                      Navigator.push(
//                                          context, MaterialPageRoute(builder: (context) => SignIn()));

                                    }).catchError((e) {
                                      setState(() {
                                        showProgressSpinner=false;
                                      });
                                      print(e);
                                    });

                                  }




                                  ///////////////////////////////////
//                                  Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder: (context) => SignIn()));
                                },
                              ),
                            ),
                            SizedBox(
                              height: height / 40,
                            ),

                            Container(
                              //color: Colors.white70,
                              width: width/1.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Already have an account?  ',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: height / 60,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SignIn()));
                                    },
                                    child: Text(
                                      'Login here',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: height / 60,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



String validatePass(String value) {
  if (value.length < 6)
    return 'Password must be more than 5 charater';
  else
    return null;
}


String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
