import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owneaccount/bloc/login_bloc/loginCubit.dart';
import 'package:owneaccount/bloc/login_bloc/loginState.dart';
import 'package:owneaccount/components/background.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';




class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: Background(
        child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context, state) {

            if (state is LoginErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red[500],
                  content: Text(
                    state.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  behavior: SnackBarBehavior.floating,
                  padding: const EdgeInsets.all(10.0),
                  duration: const Duration(milliseconds: 5000)));
            }
          },
          builder: (context,state){
            var cubit  = LoginCubit.get(context);
            return  SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
               // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: size.height * 0.1),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 30
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child:TextFormField(
                      maxLength: 11,

                      controller: cubit.textMobileControl,
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000912),
                        ),
                      ),

                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintText: "رقم الموبيل",
                        hintStyle: TextStyle(
                          color: Color(0xffA6B0BD),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.phone,color:  Colors.orange),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 75,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        cubit.changValidState();
                      },
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Container(
                  //   alignment: Alignment.center,
                  //   margin: EdgeInsets.symmetric(horizontal: 40),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       labelText: "Password"
                  //     ),
                  //     obscureText: true,
                  //   ),
                  // ),



                  SizedBox(height: size.height * 0.05),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    child:  RoundedLoadingButton(
                        height: 60,

                        controller: cubit.loginBtnController,
                        successColor: Colors.green,
                        color: cubit.isValid ? Colors.orange[500] : Colors.orange[200],
                        disabledColor: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'دخول',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        animateOnTap: false,
                        onPressed: () {

                          if (cubit.isValid) {
                            cubit.getActivationCode(context);
                          }
                        }),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 18),
                    child: Text(
                      "Terms & Conditions",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Color(0xffA6B0BD),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )

                //
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}