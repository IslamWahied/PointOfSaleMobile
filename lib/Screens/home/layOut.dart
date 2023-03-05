
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:owneaccount/Screens/griddashboard.dart';
import 'package:owneaccount/bloc/home_bloc/HomeCubit.dart';
import 'package:owneaccount/bloc/home_bloc/HomeState.dart';



class LayOutScreen extends StatelessWidget {
  const LayOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:  GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left,size: 33,)),
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
                       if(cubit.selectedProjectImage == null || cubit.selectedProjectImage == '')
                          Hero(
                          tag: "aProjImage"+cubit.projectCode.toString(),
                          child: const CircleAvatar(
                            backgroundImage: ExactAssetImage('assets/images/person.jpg'),
                            // Optional as per your use case
                            // minRadius: 30,
                            // maxRadius: 70,
                          ),
                        ),

                        if(cubit.selectedProjectImage != null && cubit.selectedProjectImage != '')
                          Hero(
                            tag: "nProjImage"+cubit.projectCode.toString(),
                          child: CircleAvatar(
                            backgroundImage:  NetworkImage(cubit.selectedProjectImage),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              GridDashboard(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:   [
                      Icon(Icons.update_outlined,size: 18,color: Colors.grey[700]),
                      const SizedBox(width: 3,),
                      Text('اخر تحديث',style: TextStyle(color: Colors.grey[800]),),
                    ],
                  ),
                  if(cubit.lisLastUpdateModel.isNotEmpty)
                  Text(cubit.lisLastUpdateModel!.first.lastUpdateDate??"",style: TextStyle(color: Colors.grey[700]),)
                ],
              ),
              const SizedBox(height: 10,)
            ],
          );
        },
        listener: (context,state)=>{},

      ),
    );
  }
}
