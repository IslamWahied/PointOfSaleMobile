
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:owneaccount/bloc/home_bloc/HomeCubit.dart';
import 'package:owneaccount/bloc/home_bloc/HomeState.dart';
import 'package:owneaccount/shared/network/cuntUp.dart';

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
                children: cubit.listItems2.map((data) {
        return InkWell(
        onTap: () async {
          cubit.empCode = 0;
       cubit.startDate =   DateTime(DateTime.now().year, DateTime.now().month,0);

          cubit.endDate =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
          cubit.isShowTodayAccountOnly = true;
          cubit.isShowAllAccount = false;
          await   cubit.getDataByTypId(id: data.id);
await cubit.goToDetail(
  context:   context,
  title: data.title,
  typeId: data.id,
  detailIcon:  "detailIcon"+data.id.toString(),
  img:data.img ,

);
        },
        child: Container(
        decoration: BoxDecoration(
        color: HexColor(color), borderRadius: BorderRadius.circular(10)),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Hero(
          tag: "detailIcon"+data.id.toString(),
          child: Image.asset(
          data.img,
          width: 42,
          ),
        ),
        const SizedBox(
        height: 14,
        ),
        Text(
        data.title,
        style: GoogleFonts.openSans(
        textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 19,
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
          Column(
            children: [

              Countup(
                begin: 0,
                end:double.parse(data.event),
                duration: const Duration(seconds: 3),
                separator: ',',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Colors.blue, fontSize: 15),
              ),
              const Text("جنية"),
            ],
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


