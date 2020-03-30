import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(milliseconds: 3000);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      backgroundColor: Color(0xffdee3e0),
      body: new Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff413564), Color(0xFF5F3567)],
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            SizedBox(height: height/10,),
//            Container(
////              decoration: BoxDecoration(
////                  color: Colors.transparent
////              ),
//              child:
//                Image.asset('Images/splashlogo.png',
//                  height: height/3,),
//
//            ),
            SizedBox(height: height/10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("LOADING",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    )
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
