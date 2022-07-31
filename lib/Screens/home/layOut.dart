
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pointofsale/Screens/griddashboard.dart';
import 'package:pointofsale/bloc/home_bloc/HomeCubit.dart';
import 'package:pointofsale/bloc/home_bloc/HomeState.dart';
import 'package:pointofsale/shared/Global.dart';


class LayOutScreen extends StatelessWidget {
  const LayOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:  GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left,size: 25,)),
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        backgroundColor: HexColor("#e7e7e7"),
      ),
      backgroundColor:     HexColor("#e7e7e7"),
      // Color(0xff392850),
      body: BlocConsumer<HomeCubit,HomeState>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Text(
                          cubit.selectedProjectName,
                          style: GoogleFonts.openSans(
                              textStyle:  TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10,),
                        CircleAvatar(
                          backgroundImage: NetworkImage(cubit.selectedProjectImage),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GridDashboard()
            ],
          );
        },
        listener: (context,state)=>{},

      ),
    );
  }
}
