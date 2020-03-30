import 'SignUp.dart';
import 'Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<SignIn> {

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn= new GoogleSignIn();


  String _userName;
  String _pwd;
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey=GlobalKey<FormState>();
  final _userNameController=TextEditingController();
  final _pwdController=TextEditingController();
  bool showProgressSpinner=false;


  Future<FirebaseUser> googleSignIn() async{

    setState(() {
      showProgressSpinner=true;
    });
    final GoogleSignInAccount googleUser= await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth=await googleUser.authentication;
    
    final AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    AuthResult authResult=await _firebaseAuth.signInWithCredential(credential);

    //final FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);
    //final FirebaseUser firebaseUser = (await _firebaseAuth.signInWithCredential(credential)).user;


    if(authResult==null)
      {
        setState(() {
          showProgressSpinner=false;
        });

             // Fluttertoast.showToast(msg: "Sign In fail");
              return null;
      }
    else
      {

        FirebaseUser userDetail=authResult.user;

        String email=userDetail.email;
        String name=userDetail.displayName;

//        DatabaseReference newGoogleUser=FirebaseDatabase.instance.reference().child("Broker").push();
//        newGoogleUser.set({
//          'name':name,
//          'email':email
//        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>Profile()));
        setState(() {
          showProgressSpinner=false;
        });
      return authResult.user;
      }

//    FirebaseUser userDetail=authResult.user;
//
//    provideDetail prvideInfo= new provideDetail(userDetail.providerId);
  }
  bool _isLoggedIn = false;
  Map userProfile;


  ////////////Sign in with facebook

   _signInWithFacebook() async {
     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
     final FacebookLoginResult result =
     await facebookLogin.logIn(['email']);
     if (result.status == FacebookLoginStatus.loggedIn) {
       final AuthCredential credential = FacebookAuthProvider.getCredential(
         accessToken: result.accessToken.token,
       );
       final FirebaseUser user =
           (await _auth.signInWithCredential(credential)).user;

       assert(user.email != null);
       assert(user.displayName != null);
       assert(!user.isAnonymous);
       assert(await user.getIdToken() != null);

       final FirebaseUser currentUser = await _auth.currentUser();
       assert(user.uid == currentUser.uid);
       if (user != null) {
         print('Successfully signed in with Facebook. ' + user.uid);
         return true;
       } else {
         print('Failed to sign in with Facebook. ');
         return false;
       }
     }
     else
     {
       print('Failed to sign in with Facebook. ');
       return false;
     }


   }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff634670),
        appBar: AppBar(
          backgroundColor: Color(0xff413564),
          title: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),


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
                      'Sign In',
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
                                    controller: _userNameController,
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
                                    validator:validateEmail,
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
                                    controller: _pwdController,
                                    style: TextStyle(color: Colors.white70),
                                    cursorColor: Color(0xffcfbfd6),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: new InputDecoration(
                                        hintText: '........',
                                        hintStyle: TextStyle(
                                          color: Color(0xffcfbfd6),
                                          fontWeight: FontWeight.bold,
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
//                                  Navigator.push(context,
//                                      MaterialPageRoute(builder: (context) => forgotPassword()));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: height / 60,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
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
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: width / 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showProgressSpinner = true;
                                  });

                                  final form=_formKey.currentState;

                                  if(form.validate())
                                    {

                                      _userName=_userNameController.text;
                                      _pwd=_pwdController.text;
                                      
                                      _firebaseAuth.signInWithEmailAndPassword(email: _userName, password: _pwd).then((AuthResult r){

                                        if(r!=null)
                                        {
                                          setState(() {
                                            showProgressSpinner = false;
                                          });

//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (context) =>QOLproducts()));

                                        }
                                        else
                                          {
                                            setState(() {
                                              showProgressSpinner = false;
                                            });
                                        //    Fluttertoast.showToast(msg: "Please Enter Valid Username and Password");
                                          }
                                      }).catchError((e) {
                                        setState(() {
                                          showProgressSpinner = false;
                                        });
                                     //   Fluttertoast.showToast(msg: "You have Enter Wrong Username or Password");
                                        //     print(e);
                                      });;
                                      

                                    }
                                  else
                                    {
                                      setState(() {
                                        showProgressSpinner = false;
                                      });

                                    }
                                 },
                              ),
                            ),
                            SizedBox(
                              height: height / 40,
                            ),
                            Center(
                              child: Container(
                                width: width / 1.2,
                                height: height / 18,
                                child: SignInButton(

                                  Buttons.Google,
                                  text: "Sign in with Google",
                                  onPressed: googleSignIn,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 40,
                            ),
                            Center(
                              child: Container(
                                width: width / 1.2,
                                height: height / 18,
                                child: SignInButton(

                                  Buttons.Facebook,
                                  text: "Sign in with Facebook",
                                  onPressed: _signInWithFacebook,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 20,
                            ),
                            Container(
                              //color: Colors.white70,
                              width: width/1.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Dont have account?  ',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: height / 60,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      'Register here',
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

    ));
  }
}



class provideDetail{


  final String providerDetail;
  provideDetail(this.providerDetail);

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
