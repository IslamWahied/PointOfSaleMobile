//@dart=2.9
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:owneaccount/Screens/ListProjectsScreen.dart';
import 'package:owneaccount/Screens/register/register.dart';
import 'package:owneaccount/models/user/user_model.dart';
import 'package:owneaccount/shared/components/Componant.dart';
import 'package:owneaccount/shared/network/local/helper.dart';
import 'package:owneaccount/shared/network/local/shared_helper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../shared/Global.dart';
import 'loginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isValid = false;
  bool verifiedIsValid = false;
  bool isAdmin = false;

  int endTime = DateTime.now().millisecondsSinceEpoch + 4000 * 30;
  bool timerEnd = false;
  TextEditingController textVerifiedCodeControl = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldLoginKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldVerifiedKey =
      GlobalKey<ScaffoldState>();
  RoundedLoadingButtonController loginBtnController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController verifiedBtnController =
      RoundedLoadingButtonController();
  TextEditingController textMobileControl = TextEditingController();

  String verificationCode = '';
  resendActivationCode(context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2' + textMobileControl.text.toString().trim(),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int resendToken) {
        verificationCode = verificationId;

        emit(LoginSuccessState());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  activationNumber(context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: LoginCubit.get(context).verificationCode,
        smsCode: textVerifiedCodeControl.text);
      signInWithPhoneAuthCredential(phoneAuthCredential, context);
  }
  bool activationDone = false;
  List<UserModel> listUser = [];


  getUsers() async {
    FirebaseFirestore.instance.collection('UsersInfo').snapshots().listen((event) {
      listUser = event.docs.map((x) => UserModel.fromJson(x.data())).toList();

    }).onError((handleError) {
      if (kDebugMode) {
        print(handleError);
      }
    });
  }

  signInWithPhoneAuthCredential(phoneAuthCredential, context) async {
    try {
      final authCredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        activationDone = true;

        // var userModel = listUser.firstWhere((element) => element.mangerMobile.trim() == textMobileControl.text.trim());
        //
        // Global.userName = userModel.mangerName;
        //
        // Global.mobile = userModel.mangerMobile.trim();
        //
        // await CachHelper.SetData(key: 'mobile', value: Global.mobile);
        // await CachHelper.SetData(key: 'userName', value: Global.userName);


       //NavigatToAndReplace(context, const LayOutScreen());
       NavigatToAndReplace(context, const ProjectsListScreen());

      }
    } on FirebaseAuthException catch (e) {
      if (e.message == 'The verification ID used to create the phone auth credential is invalid.')
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '!كود التحقق الذي تم ادخاله غير صحيح',
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(10.0),
            duration: Duration(milliseconds: 2000)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              e.message.toString(),
              textAlign: TextAlign.center,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.all(10.0),
            duration: const Duration(milliseconds: 2000)));
      }
    }
  }




  getActivationCode(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if ((Global.mobile != textMobileControl.text || verificationCode == null || verificationCode.trim() == '') && textMobileControl.text.trim() != '' && textMobileControl.text != null) {

     // bool isUser = listUser.any((element) => element.mangerMobile.toString().trim() == textMobileControl.text.toString().trim());


      if(true){
        loginBtnController.start();
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2' + textMobileControl.text.trim(),
          verificationCompleted: (PhoneAuthCredential credential) {
            loginBtnController.success();
            loginBtnController.reset();

            emit(LoginSuccessState());
          },
          verificationFailed: (FirebaseAuthException e) {
            loginBtnController.error();
            loginBtnController.reset();

            if (e.message ==
                'We have blocked all requests from this device due to unusual activity. Try again later.') {
              emit(LoginErrorState(
                  ' لقد حظرنا جميع الطلبات الواردة من هذا الجهاز نظرًا\n ! لوجود نشاط غير معتاد حاول مرة أخرى في وقت لاحق'));
            } else {
              emit(LoginErrorState(e.message ?? e.code));
            }
          },
          codeSent: (String verificationId, int resendToken) {
            Global.mobile = textMobileControl.text.trim();

            verificationCode = verificationId;
            loginBtnController.success();
            loginBtnController.reset();

            emit(LoginSuccessState());

            navigateTo(context, ActivationScreen());
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
      else{
        emit(LoginErrorState('لا يوجد مشروعات لهذا الرقم'));
      }


    } else if (textMobileControl.text.trim() != '' && textMobileControl.text != null && Global.mobile == textMobileControl.text.trim()) {
    //  navigatTo(context, const ActivationCodeScreen());
    }
  }





 // AllCasesModel data;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  changValidState() {
    if (textMobileControl.text.trim() != '' &&
        textMobileControl.text.length == 11 &&
        textMobileControl.text != null) {
      isValid = true;
    } else {
      isValid = false;
    }
    emit(LoginSuccessState());
  }

  restLoginCubit() {
    textMobileControl.text = '';

    verifiedIsValid = false;
    isValid = false;

    emit(ChangeInScreenState());
  }

  // UserModel userModel;
  // Project projectModel;

  getUserData() {
    FirebaseFirestore.instance
        .collection('User')
        .doc(Global.mobile)
        .get()
        .then((value) {
   //   userModel = UserModel.fromJson(value.data());

      if (kDebugMode) {}
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
