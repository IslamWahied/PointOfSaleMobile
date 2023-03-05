// @dart=2.9
import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:owneaccount/Screens/ListProjectsScreen.dart';
import 'package:owneaccount/Screens/login/login.dart';
import 'package:owneaccount/shared/Global.dart';
import 'package:owneaccount/shared/network/local/helper.dart';
import 'package:owneaccount/shared/network/local/shared_helper.dart';



class SplashScreen extends StatefulWidget {

  final Color backgroundColor = Colors.white;

  final TextStyle styleTextUnderTheLoader = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 6000), () async {

      CachHelper.SetData(
          key: CachHelper.hightDivice, value: MediaQuery.of(context).size.height);
      CachHelper.SetData(key: CachHelper.wightDivice, value: MediaQuery.of(context).size.width);

      Global.mobile =  CachHelper.GetData(key: 'mobile')??'';
      Global.userName =  CachHelper.GetData(key: 'userName')??'';


      if(Global.mobile != null && Global.userName != null && Global.mobile != '' && Global.userName != ''){
        NavigatToAndReplace(context, const ProjectsListScreen());

      }
      else{
        NavigatToAndReplace(context, LoginScreen());
      }


    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarGlow(
                glowColor: Colors.white,
                endRadius: 90.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: Material(     // Replace this child with your own
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 100,
                    ),
                    radius: 60.0,
                  ),
                ),
              ),
const SizedBox(height: 10,),
 const Text("Loading...",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16),),

            ],
          ),
        ),
      ),
    );
  }
}
