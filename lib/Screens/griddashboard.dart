
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pointofsale/bloc/home_bloc/HomeCubit.dart';
import 'package:pointofsale/bloc/home_bloc/HomeState.dart';

class GridDashboard extends StatelessWidget {







  @override
  Widget build(BuildContext context) {

    var color = "#f7f7f7";
    return BlocConsumer<HomeCubit,HomeState>(
      listener: (context, state) => {},
        builder: (context,state){
        var cubit = HomeCubit.get(context);
        return  Flexible(
            child: GridView.count(
                childAspectRatio: 1.0,
                padding: const EdgeInsets.only(left: 16, right: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: cubit.listItems.map((data) {
        return InkWell(
        onTap: (){

        },
        child: Container(
        decoration: BoxDecoration(
        color: HexColor(color), borderRadius: BorderRadius.circular(10)),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Image.asset(
        data.img,
        width: 42,
        ),
        const SizedBox(
        height: 14,
        ),
        Text(
        data.title,
        style: GoogleFonts.openSans(
        textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600)),
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        // Text(
        //   data.subtitle,
        //   style: GoogleFonts.openSans(
        //       textStyle: const TextStyle(
        //           color: Colors.black38,
        //           fontSize: 10,
        //           fontWeight: FontWeight.w600)),
        // ),
        const SizedBox(
        height: 14,
        ),
        Text(
        data.event,
        style: GoogleFonts.openSans(
        textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 11,
        fontWeight: FontWeight.w600)),
        ),
        ],
        ),
        ),
        );
        }).toList()));
        },


    );
  }
}


