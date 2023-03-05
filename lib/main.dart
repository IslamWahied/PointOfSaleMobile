// @dart=2.9
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:owneaccount/shared/Global.dart';
import 'package:owneaccount/styles/colors.dart';

import 'Screens/splash/splash_screen.dart';
import 'bloc/home_bloc/HomeCubit.dart';
import 'bloc/login_bloc/loginCubit.dart';
import 'shared/network/local/shared_helper.dart';

import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseMessaging.instance;

  await CachHelper.init();
  //DioHelper.init();

  //fire base
  FirebaseMessaging.onMessage.listen((event) {
    // print('onMessage');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // print('A new onMessageOpenedApp event was published!');
    // Navigator.pushNamed(context, '/message',
    //     arguments: MessageArguments(message, true));
  });
  FirebaseMessaging.onBackgroundMessage((message) {
    print('onBackgroundMessage!');
  });
  Global.fireBaseToken = await FirebaseMessaging.instance.getToken() ?? '';

  bool isUserLogin = await CachHelper.GetData(key: 'isUserLogin') ?? false;
  bool isAdmin = await CachHelper.GetData(key: 'isAdmin') ?? false;
  String mobile = await CachHelper.GetData(key: 'mobile') ?? '';

  int projectId = await CachHelper.GetData(key: 'ProjectId') ?? 0;


  if (isUserLogin && mobile.trim() != '') {
    Global.isAdmin = isAdmin ?? false;
    Global.mobile = mobile;
    Global.projectCode = projectId ?? 0;
    Global.userName = await CachHelper.GetData(key: 'userName');
    Global.departMent = await CachHelper.GetData(key: 'departmentId');
    Global.imageUrl = await CachHelper.GetData(key: 'imageUrl');
  }

  runApp(MyApp(isUserLogin: false));
}

class MyApp extends StatelessWidget {
  String userName;
  String mobile;
  int departmentId;
  bool isUserLogin;

  MyApp({
    Key key,
    this.isUserLogin,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()..getUsers()),

          // BlocProvider(create: (context) => RegisterCubit()
            // ..getAllProjects()..getUsers()
         // ),
          BlocProvider(
              create: (context) => HomeCubit()
                  ..getAllProjects()
                  ..getUsers()

                // ..getUsersAccount()
          ),
        ],
        child: MaterialApp(
          theme: Constants.lightTheme,
          builder: EasyLoading.init(),

          debugShowCheckedModeBanner: false,

          // home:const ActivationCodeScreen(),
          home:Scaffold(
            body: DoubleBackToCloseApp(
              child:
              // isUserLogin ? const HomeLayout() :
              SplashScreen() ,
              snackBar:   const SnackBar(
                content: Text('اضغط مره اخري للخروج',textAlign: TextAlign.center,),
              ),
            ),

          )
          ,
        ));
  }
}
