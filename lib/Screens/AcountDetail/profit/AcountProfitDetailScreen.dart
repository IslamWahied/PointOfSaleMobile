// @dart=2.9

import 'package:intl/intl.dart' as intl;
import 'package:owneaccount/Screens/lip.dart';
import 'package:flutter/material.dart';

class AcountProfitDetailScreen extends StatelessWidget {
  String selectedIcon;
  String heroTag;
  String titleName;
  int typeId;

  AcountProfitDetailScreen({Key key, this.selectedIcon, this.heroTag, this.titleName,this.typeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: heroTag,
                  child: Image.asset(
                    selectedIcon,
                    width: 30,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(titleName,
                    style: const TextStyle(fontSize: 25, color: AppColors.black)),
              ],
            ),
            centerTitle: true,
            elevation: 0,
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 33,
                )),
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.grey[100],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 5,),
                SfDateRangePicker(
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) async {
                    if (args.value is PickerDateRange) {
                      cubit.startDate = args.value.startDate;
                      cubit.endDate = args.value.endDate;

                      if(cubit.endDate != null){
                        cubit.startDate  =  DateTime(cubit.startDate.year,cubit.startDate.month, cubit.startDate.day - 1);
                        cubit.endDate  =  DateTime(cubit.endDate.year,cubit.endDate.month, cubit.endDate.day + 1);
                      }

                      await cubit.getDataByTypId(id: typeId);
                    }
                  },
                  selectionMode: DateRangePickerSelectionMode.range,
                  headerHeight: 40,

                  initialSelectedRange: PickerDateRange(
                    DateTime.now(),
                    DateTime(DateTime.now().year, DateTime.now().month, 1),
                  ),
                ),

//                 Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10, left: 10),
//                     child: SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.1,
//                         width: double.infinity,
//                         child: DropdownSearch(
//                           showClearButton: true,
//
//                           clearButton: cubit.empCode != null && cubit.empCode != 0?  InkWell(
//                             onTap: () async {
//                               cubit.empCode = 0;
//
//                               await cubit.getDataByTypId(id: typeId);
//                               cubit.emit(SelectCategoryState());
//                             },
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.red,
// size: 32,
//
//
//                             ),
//                           ):SizedBox(),
//
//                           popupBackgroundColor: Colors.grey[250],
//                           maxHeight:
//                               MediaQuery.of(context).size.height * 0.35,
//                           dropdownSearchDecoration: InputDecoration(
//                               hintText: "المستخدمين",
//                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                               fillColor: Colors.black,
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(25.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(25.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.black,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               floatingLabelAlignment: FloatingLabelAlignment.center,
//                               alignLabelWithHint: true,
//                               labelStyle: const TextStyle(
//                                 color: AppColors.black,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 20)),
//                           items: cubit.listEmployeeModel
//                               .where((element) => element.EmployeeCode != 0)
//                               .map((e) => e.EmployeeName)
//                               .toList(),
//                           selectedItem: cubit.empCode != null &&
//                                   cubit.empCode != 0
//                               ? cubit.listEmployeeModel
//                                   .where((element) =>
//                                       element.EmployeeCode == cubit.empCode)
//                                   .first
//                                   .EmployeeName
//                               : '',
//                           showSearchBox: true,
//                           mode: Mode.MENU,
//                           onChanged: (value) async {
//                             cubit.empCode = cubit.listEmployeeModel.where((element) => element.EmployeeCode != 0 && element.EmployeeName.toString().toLowerCase().trim() == value.toString()
//                                                 .toLowerCase()
//                                                 .trim())
//                                     .first
//                                     .EmployeeCode ??
//                                 0;
//
//                             await cubit.getDataByTypId(id: typeId);
//                             cubit.emit(SelectCategoryState());
//                           },
//                         )),
//                   ),
//                 ),
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 21),
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Colors.grey[300],
                        spreadRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(41),
                    color: Colors.white,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              Column(
                                children: [
                                  Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(

                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: Image.asset(
                                              "assets/images/discount.png",
                                              height: 25,
                                              width: 25,
                                            ),
                                            backgroundColor:
                                            IconColors.transfer
                                            ,
                                          ),
                                          Text("الخصومات",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                      FontWeight.w800)),
                                          Countup(
                                            begin: 0,
                                            end: cubit.discount ?? 0,
                                            duration: const Duration(
                                                seconds: 2),
                                            separator: ',',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                    height: 1,
                                                    color: Constants
                                                        .tertiary,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Column(

                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: Image.asset(
                                              "assets/images/expenses.png",
                                              height: 25,
                                              width: 25,
                                            ),
                                            backgroundColor:
                                            IconColors.transfer
                                            ,
                                          ),
                                          Text("المصروفات",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                  FontWeight.w800)),
                                          Countup(
                                            begin: 0,
                                            end: cubit.expenses ?? 0,
                                            duration: const Duration(
                                                seconds: 2),
                                            separator: ',',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                height: 1,
                                                color: Constants
                                                    .tertiary,
                                                fontWeight:
                                                FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Column(



                                        children: [

                                          CircleAvatar(
                                            radius: 20,
                                            child: Image.asset(
                                              "assets/images/revenue.png",
                                              height: 25,
                                              width: 25,
                                            ),
                                            backgroundColor:
                                            Colors.green[100]
                                            ,
                                          ),
                                          Text('الايرادات',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontWeight:
                                                      FontWeight.w800)),
                                          Countup(
                                            begin: 0,
                                            end: cubit.sales ?? 0,
                                            duration: const Duration(
                                                seconds: 2),
                                            separator: ',',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                    height: 1,
                                                    color: Colors.green[300],
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8),
                                    child: Divider(color: Colors.grey),
                                  ),

                                  Column(


                                    children: [
                                      Text("الربح أو الخسارة",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[600],
                                              fontWeight:
                                              FontWeight.w800)),
                                      SizedBox(height: 3,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          cubit.sales - (cubit.expenses + cubit.discount) > 0? Icon(Icons.add,color: Colors.green[300],): Text("-",style: const TextStyle(color: Constants.tertiary,fontSize: 25,fontWeight: FontWeight.w900),),
                                          Countup(
                                            begin: 0,
                                            end: cubit.sales - (cubit.expenses + cubit.discount),
                                            duration: const Duration(
                                                seconds: 2),
                                            separator: ',',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                height: 1,
                                                color:cubit.sales - (cubit.expenses + cubit.discount) > 0 ? Colors.green[300] :Constants.tertiary,
                                                fontWeight:
                                                FontWeight.w700,
                                                fontSize: 28),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),


                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -80,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: Colors.grey[200],
                              child: cubit.selectedProjectImage != null &&
                                      cubit.selectedProjectImage.trim() !=
                                          ''
                                  ? Hero(
                                      tag: "aProjImage",
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            cubit.selectedProjectImage),
                                      ),
                                    )
                                  : const Hero(
                                      tag: "aProjImage",
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            AssetImage('assets/person.jpg'),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              cubit.selectedProjectName,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
