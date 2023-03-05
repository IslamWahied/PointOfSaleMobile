// @dart=2.9

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:owneaccount/Screens/lip.dart';




class AcountExpensesDetailScreen extends StatelessWidget {
  String selectedIcon;
  String heroTag;
  String titleName;
  int typeId;

  AcountExpensesDetailScreen({Key key, this.selectedIcon, this.heroTag, this.titleName,this.typeId})
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

            controller:cubit.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10,),
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
                const SizedBox(height: 5,),
                Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: double.infinity,
                            child: DropdownSearch(

                              clearButtonProps: ClearButtonProps(

                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 32,


                                ),
                                onPressed: () async {
                                  await  cubit.clearUserButton(typeId:typeId);
                                }
                              ),
                              dropdownButtonProps: DropdownButtonProps(

                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(

                                dropdownSearchDecoration: InputDecoration(
                                    hintText: "المستخدمين",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    fillColor: Colors.black,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    alignLabelWithHint: true,
                                    labelStyle: const TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20)),

                              ),


                              // maxHeight:
                              // MediaQuery.of(context).size.height * 0.35,

                              items: cubit.listEmployeeModel
                                  .where((element) => element.EmployeeCode != 0)
                                  .map((e) => e.EmployeeName)
                                  .toList(),
                              selectedItem: cubit.empCode != null &&
                                  cubit.empCode != 0
                                  ? cubit.listEmployeeModel
                                  .where((element) =>
                              element.EmployeeCode == cubit.empCode)
                                  .first
                                  .EmployeeName
                                  : '',

                              // showSearchBox: true,
                              // mode: Mode.MENU,
                              onChanged: (value) async {
                                cubit.empCode = cubit.listEmployeeModel.where((element) => element.EmployeeCode != 0 && element.EmployeeName.toString().toLowerCase().trim() == value.toString()
                                    .toLowerCase()
                                    .trim())
                                    .first
                                    .EmployeeCode ??
                                    0;

                                await cubit.getDataByTypId(id: typeId);
                                cubit.emit(SelectCategoryState());
                              },
                            )),
                      ),
                    ),
                    const SizedBox(height: 60),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 21),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 70,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(typeId == 3?'عدد الورديات':'عدد الطلبات',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey[600],
                                                        fontWeight:
                                                        FontWeight.w800)),
                                                Countup(
                                                  begin: 0,
                                                  end: double.parse(cubit.totalOrderNumber ?? "0"),
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
                                                      fontSize: 25),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text('اجمالي المبالغ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey[600],
                                                        fontWeight:
                                                        FontWeight.w800)),
                                                Countup(
                                                  begin: 0,
                                                  end: double.parse(cubit.totalOrderAmount??
                                                      "0"),
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
                                                      fontSize: 25),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 25),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        child: RoundedLoadingButton(
                                            width: 80,
                                            height: 40,
                                            controller: cubit.callBtnController,

                                            // color: Colors.green,
                                            color: Colors.green,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "التفاصيل",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            animateOnTap: false,
                                            onPressed: () {
                                              cubit.changeShowDetailState();
                                            }),
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
                                const SizedBox(height: 10),
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
                    )
                  ],
                ),


                if(cubit.isShowAllAccount)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 21),
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      cubit.changeOnlyDayOnlyState();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13.0, vertical: 7.0),
                                      decoration: BoxDecoration(
                                        color: cubit.isShowTodayAccountOnly? Colors.green[400] : Colors.transparent,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child:   Text("اليوم",
                                        style: TextStyle(color: cubit.isShowTodayAccountOnly?Colors.white:Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      cubit.changeOnlyDayOnlyState();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13.0, vertical: 7.0),
                                      decoration: BoxDecoration(
                                        color: !cubit.isShowTodayAccountOnly? Colors.green[400] : Colors.transparent,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child:   Text(
                                        "الكل",
                                        style: TextStyle(color: !cubit.isShowTodayAccountOnly?Colors.white:Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "التفاصيل",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.grey[200]),
                        ),
                        const SizedBox(height : 10),

                        (cubit.list.where((element) => convertStringToDateTime(element.Date).day == DateTime.now().day && convertStringToDateTime(element.Date).month ==DateTime.now().month && convertStringToDateTime(element.Date).year == DateTime.now().year).toList().isNotEmpty && cubit.isShowTodayAccountOnly) ||
                            (cubit.list.toList().isNotEmpty &&!cubit.isShowTodayAccountOnly )?
                        ListView.separated(

                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var  model;

                              if(cubit.isShowTodayAccountOnly){
                                model = cubit.list.where((element) =>convertStringToDateTime(element.Date).day == DateTime.now().day && convertStringToDateTime(element.Date).month ==DateTime.now().month && convertStringToDateTime(element.Date).year == DateTime.now().year).toList()[index];
                              }
                              else{
                                model = cubit.list.toList()[index];
                              }


                              return Material(
                                color: Colors.transparent,
                                child: ListTile(

                                  title:Text(model.Employee_Name == "لايوجد"?cubit.selectedProjectName:model.Employee_Name),
                                  subtitle:Text(intl.DateFormat('yyyy-MM-dd\nhh:mm a').format(convertStringToDateTime(model.Date))),

                                  trailing:Text("-\$ ${model.ExpensesQT}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent)),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    child: Image.asset(
                                      "assets/images/expenses.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                    backgroundColor:
                                          IconColors.transfer
                                         ,
                                  ),
                                  enabled: true,
                                  onTap: () {},
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 5),
                            itemCount: cubit.isShowTodayAccountOnly?  cubit.list.where((element) => convertStringToDateTime(element.Date).day == DateTime.now().day && convertStringToDateTime(element.Date).month ==DateTime.now().month && convertStringToDateTime(element.Date).year == DateTime.now().year).toList().length:cubit.list.length
                        )  :Text("لا يوجد نتائج",style: TextStyle(fontSize: 16,color: Colors.grey[700],fontWeight: FontWeight.w200),)
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
