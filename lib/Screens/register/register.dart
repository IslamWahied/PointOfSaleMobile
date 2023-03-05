import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:owneaccount/bloc/login_bloc/loginCubit.dart';
import 'package:owneaccount/bloc/login_bloc/loginState.dart';
import 'package:owneaccount/components/background.dart';
import 'package:owneaccount/styles/colors.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';



class ActivationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
    builder: (context, state) {

    var cubit  = LoginCubit.get(context);
     return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              "كود التفعيل",
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
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: PinCodeTextField(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              cursorHeight: 20,
              enablePinAutofill: true,
              appContext: context,
              length: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              animationType: AnimationType.fade,
              validator: (v) {
                if (v?.length == 6) {
                  cubit.verifiedIsValid = true;
                  cubit.emit(Refresh());

                  return null;
                } else {
                  cubit.verifiedIsValid = false;
                  cubit.emit(Refresh());

                  return null;
                }
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                activeColor: Colors.white,
                activeFillColor: Colors.white,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 32,
                fieldWidth: 35,

                selectedColor: Colors.white,

                // fieldOuterPadding: EdgeInsets.all(1.5),
                selectedFillColor: Colors.white,
                inactiveColor:
                HexColor('#ededed').withOpacity(.1),
                inactiveFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration:
              const Duration(milliseconds: 300),
              enableActiveFill: true,
              useExternalAutoFillGroup: true,
              errorAnimationController: cubit.errorController,
              controller: cubit.textVerifiedCodeControl,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  spreadRadius: 5,
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 30,
                )
              ],
              onChanged: (String value) {},
            ),
          ),

          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CountdownTimer(
                onEnd: () {
                  cubit.timerEnd = true;
                },
                endTime: cubit.endTime,
                widgetBuilder: (_, time) {
                  return cubit.timerEnd
                      ? GestureDetector(
                    onTap: () {
                      cubit.endTime = DateTime.now()
                          .millisecondsSinceEpoch +
                          4000 * 30;
                      cubit.timerEnd = false;
                      cubit.resendActivationCode(
                          context);
                      cubit.emit(
                          Refresh());
                    },
                    child: const Text(
                      'ارسال',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.deepOrange,
                          fontSize: 18,
                          decoration: TextDecoration
                              .underline),
                    ),
                  )
                      : Text(
                    '${time?.min ?? '0'}:${time?.sec ?? '0'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(width: 10),
              RichText(
                text: const TextSpan(
                    text: "اعادة ارسال كود التفعيل؟ ",
                    children: [],
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ],
          ),


          SizedBox(height: size.height * 0.05),

          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child:RoundedLoadingButton(
                height: 60,
                controller: cubit.verifiedBtnController,
                successColor: Colors.green,
                color: cubit.verifiedIsValid
                    ?  Constants.primary
                    : Colors.grey[500],
                disabledColor: Colors.grey,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: const [
                    Text(
                      'تفعيل',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    // Icon(Icons.arrow_forward_outlined, color: Colors.white,)
                  ],
                ),
                animateOnTap: false,
                onPressed: () {
                  if (cubit.verifiedIsValid) {
                    cubit.activationNumber(context);
                  }
                }) ,
          ),


        ],
      );
    }
        ),
      ),
    );
  }
}