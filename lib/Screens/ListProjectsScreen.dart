import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owneaccount/Screens/login/login.dart';
import 'package:owneaccount/bloc/home_bloc/HomeCubit.dart';
import 'package:owneaccount/bloc/home_bloc/HomeState.dart';
import 'package:owneaccount/shared/Global.dart';
import 'package:owneaccount/shared/components/Componant.dart';
import 'package:owneaccount/shared/network/local/helper.dart';




class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            leadingWidth: 300,
             backgroundColor: Colors.grey[100],
            elevation: 0,

            leading: IconButton(

              icon: Row(
                children: [

                  Transform.rotate(
                      angle: 3.15,

                      child: const Icon(Icons.logout,color: AppColors.black,textDirection:TextDirection.rtl )),
                  const SizedBox(width: 5,),
                  const Text("تسجيل الخروج",style: TextStyle(color: Colors.red),),
                ],
              ), onPressed: () {

                NavigatToAndReplace(context, LoginScreen());
            },
            ),
          ),
          body: BlocConsumer<HomeCubit,HomeState>(
            listener: (context, state) =>{},
            builder: (context, state){
              var cubit  = HomeCubit.get(context);
              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // Text(
                            //   Global.userName,
                            //   style: GoogleFonts.openSans(
                            //       textStyle: const TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold)),
                            // ),
                            // const SizedBox(
                            //   height: 4,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'المشروعات',
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Flexible(
                    child: GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 1.0,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        crossAxisCount: 1,
                        crossAxisSpacing: 0,
                        mainAxisSpacing:cubit.listProjects.where((element) => element.listUserModel.any((element2) => element2.mangerMobile.trim() ==  Global.mobile.trim())).toList().length > 1 ? 20:0,
                        children: cubit.listProjects.where((element) => element.listUserModel.any((element2) => element2.mangerMobile.trim() ==  Global.mobile.trim())).map((data) {
                          return InkWell(
                            onTap: () async {
                            cubit.buildProjectData(context: context,data: data);

                            },
                            child: Card(
                              elevation: 3,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                      MediaQuery.of(context).size.height * 0.23,
                                      child:data.image != null && data.image != ''? Hero(

                                        tag: "nProjImage"+data.projectCode.toString(),
                                        child: Image.network(
                                          data.image,

                                          fit: BoxFit.contain,
                                          // width: 200,
                                        ),
                                      ):Hero(
                                          tag: "aProjImage"+data.projectCode.toString(),child: Image.asset("assets/person.jpg")),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data.projectName,
                                    style: GoogleFonts.caveat(
                                        textStyle: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                  )
                ],
              );
            },

          ),
        );
        //    ListView.separated(
        //
        //     itemBuilder: (context,index){
        //       return buildGridProjects(context: context,model:cubit.listProjects[index]);
        //     },
        //     separatorBuilder: (context,index)=>const SizedBox(height: 10),
        //     itemCount: cubit.listProjects.length
        // );
      },
    );
  }
}

