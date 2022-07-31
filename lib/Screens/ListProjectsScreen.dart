import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pointofsale/Screens/home/layOut.dart';
import 'package:pointofsale/bloc/home_bloc/HomeCubit.dart';
import 'package:pointofsale/bloc/home_bloc/HomeState.dart';

import 'package:pointofsale/shared/network/local/helper.dart';


class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        // var cubit = HomeCubit.get(context);

        return Scaffold(
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
                        mainAxisSpacing: 0,
                        children: cubit.listProjects.map((data) {
                          return InkWell(
                            onTap: () async {
                              cubit.selectedProjectName = data.projectName;
                              cubit.selectedProjectImage = data.image;
                              cubit.projectCode = data.projectCode;

                            await  cubit.getAllExpenses().then((value) async {
                              await  cubit.getAllSaleMaster().then((value) async {
                                await  cubit.buildItemsList().then((value) {
                                  navigatTo(context, const LayOutScreen());
                                });
                              });
                            });

                            },
                            child: Card(
                              elevation: 3,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                    MediaQuery.of(context).size.height * 0.25,
                                    child: Image.network(
                                      data.image,

                                      fit: BoxFit.contain,
                                      // width: 200,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    data.projectName,
                                    style: GoogleFonts.caveat(
                                        textStyle: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
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

