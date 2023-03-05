// @dart=2.9


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owneaccount/Screens/AcountDetail/cancelInvoice/AcountCancelInvoiceDetailScreen.dart';
import 'package:owneaccount/Screens/AcountDetail/discount/AcountDiscountDetailScreen.dart';
import 'package:owneaccount/Screens/AcountDetail/expenses/AcountExpencesDetailScreen.dart';
import 'package:owneaccount/Screens/AcountDetail/profit/AcountProfitDetailScreen.dart';
import 'package:owneaccount/Screens/AcountDetail/sales/AcountDetailScreen.dart';
import 'package:owneaccount/Screens/AcountDetail/shifts/AcountShiftsDetailScreen.dart';
import 'package:owneaccount/Screens/home/layOut.dart';
import 'package:owneaccount/Screens/login/login.dart';

import 'package:owneaccount/models/Expenses/ExpensesModel.dart';
import 'package:owneaccount/models/Item/itemModel.dart';
import 'package:owneaccount/models/LastUpdateDate/LastUpdateDateModel.dart';
import 'package:owneaccount/models/SaleMaster/SaleMasterModel.dart';
import 'package:owneaccount/models/Shifts/shiftModel.dart';
import 'package:owneaccount/models/project/projectModel.dart';
import 'package:owneaccount/models/user/employeeModel.dart';
import 'package:owneaccount/models/user/user_model.dart';

import 'package:owneaccount/shared/components/Componant.dart';
import 'package:owneaccount/shared/helper.dart';
import 'package:owneaccount/shared/network/local/helper.dart';
import 'package:owneaccount/shared/network/local/shared_helper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'HomeState.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeStateInitState());
  static HomeCubit get(context) => BlocProvider.of(context);



  RoundedLoadingButtonController callBtnController = RoundedLoadingButtonController();

  double finalAmount = 0;
  int projectCode = 0;
  int empCode = 0;

  String totalOrderNumber = '0';
  String totalOrderAmount = '0';

  String selectedUserId = '';
  String selectedProjectName = '';
  String selectedProjectImage = '';

  bool isShowAllAccount = false;
  bool isShowTodayAccountOnly = true;

  DateTime startDate =   DateTime(DateTime.now().year, DateTime.now().month,0);
  DateTime endDate =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);


  Items item1 = Items(
      id: 1,
      title: "المصروفات",
      subtitle: "",
      event: "3 Events",
      img: "assets/images/expenses.png"
  );
  Items item2 = Items(
    id: 2,
    title: "المبيعات",
    subtitle: "المبيعات",
    event: "4 Items",
    img: "assets/images/revenue.png",
  );
  Items item3 =   Items(
    id: 4,
    title: "الخصومات",
    subtitle: "Lucy Mao going to Office",
    event: "dfgsg",
    img: "assets/images/discount.png",
  );
  Items item4 =     Items(
    id: 3,
    title: "الورديات",
    subtitle: "Rose favirited your Post",
    event: "sdfasd",
    img: "assets/images/shifts.png",
  );
  Items item5 =   Items(
    id: 6,
    title: "الارباح والخسائر",
    subtitle: "Homework, Design",
    event: "4 Items",
    img: "assets/images/balance.png",
  );
  Items item6 =   Items(
    id: 5,
    title: "الفواتير الملغاه",
    subtitle: "سقبسيب",
    event: "2 Items",

    img: "assets/images/cancel.png",
  );
  List<Project> listProjects = [];
  List<LastUpdateModel> lisLastUpdateModel = [];
  List<EmployeeModel> listEmployeeModel = [];
  List<SaleMasterModel> listSaleMasterModel = [];
  List<ShiftModel> listShiftModel = [];
  List<ExpensesModel> listExpensesModel = [];
  List<UserModel> listUser = [];
  List<Items> listItems = [];
  List<Items> listItems2 = [];

  Future getAllExpenses() async {
    listExpensesModel = [];
    FirebaseFirestore.instance
        .collection('Expenses').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {

      listExpensesModel = event.docs.map((x) => ExpensesModel.fromJson(x.data())).toList();
buildItemsList();
      emit(SearchSubCategoryState());
    });
  }

  Future getAllShifts() async {
    listShiftModel = [];
    FirebaseFirestore.instance
        .collection('Shifts').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {

      listShiftModel = event.docs.map((x) => ShiftModel.fromJson(x.data())).toList();
      buildItemsList();
      emit(SearchSubCategoryState());
    });
  }

  Future getProjectUsers() async {
    listEmployeeModel = [];
    FirebaseFirestore.instance
        .collection('Employee').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {

      listEmployeeModel = event.docs.map((x) => EmployeeModel.fromJson(x.data())).toList();

      buildItemsList();
      emit(SearchSubCategoryState());
    });
  }
  var list = [];
  getTotalSale() {

      list = [];
    double qty = 0;
if(empCode == 0 || empCode  ==null){

  if(endDate == null){
    list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2 ).toList();
  }
  else if (endDate != null && startDate != null){
    list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2  ).toList();
  }
  for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
    qty  = qty +  list[ii].FinalTotal;
  }


}
    else{
  if(endDate == null){
    list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2  && element.Emp_Code == empCode).toList();
  }
  else if (endDate != null && startDate != null){
    list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2 && element.Emp_Code == empCode ).toList();
  }







  for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
    qty  = qty +  list[ii].FinalTotal;
  }

    }
    totalOrderAmount = qty.toString()??'0';
    totalOrderNumber = (list.length).toString();
    emit(SearchSubCategoryState());



  }

  getTotalCanceledInvoice() {

      list = [];
    double qty = 0;
    if(empCode == 0 || empCode  ==null){

      if(endDate == null){
        list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 3 ).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 3  ).toList();
      }
      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].FinalTotal;
      }


    }
    else{
      if(endDate == null){
        list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 3  && element.Emp_Code == empCode).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 3 && element.Emp_Code == empCode ).toList();
      }







      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].FinalTotal;
      }

    }
    totalOrderAmount = qty.toString()??'0';
    totalOrderNumber = (list.length).toString();
    emit(SearchSubCategoryState());



  }

  getTotalDiscount() {

      list = [];
    double qty = 0;
    if(empCode == 0 || empCode  ==null){

      if(endDate == null){
        list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2 && element.Discount > 0  ).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2  && element.Discount > 0 ).toList();
      }
      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].Discount;
      }


    }
    else{
      if(endDate == null){
        list =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2  && element.Emp_Code == empCode && element.Discount > 0 ).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2 && element.Emp_Code == empCode && element.Discount > 0 ).toList();
      }


      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].Discount;
      }

    }
    totalOrderAmount = qty.toString()??'0';
    totalOrderNumber = (list.length).toString();
    emit(SearchSubCategoryState());



  }

  getTotalExpenses() {
   list = [];
    double qty = 0;
    if(empCode == 0 || empCode  ==null){

      if(endDate == null){
        list =   listExpensesModel.where((element) => convertStringToDateTime(element.Date).day == startDate.day && convertStringToDateTime(element.Date).month == startDate.month &&convertStringToDateTime( element.Date).year == startDate.year ).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listExpensesModel.where((element) => convertStringToDateTime( element.Date).isAfter(startDate) &&  convertStringToDateTime(element.Date).isBefore(endDate)).toList();
      }
      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].ExpensesQT;
      }


    }
    else{
      if(endDate == null){
        list =   listExpensesModel.where((element) =>  convertStringToDateTime(element.Date).day == startDate.day &&convertStringToDateTime(element.Date).month == startDate.month &&convertStringToDateTime( element.Date).year == startDate.year && element.Emp_Code == empCode).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listExpensesModel.where((element) => convertStringToDateTime( element.Date).isAfter(startDate) &&convertStringToDateTime(element.Date).isBefore(endDate) && element.Emp_Code == empCode ).toList();
      }

      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty +  list[ii].ExpensesQT;
      }

    }
    totalOrderAmount = qty.toString()??'0';
    totalOrderNumber = (list.length).toString();
    emit(SearchSubCategoryState());



  }

  getTotalShifts() {
     list = [];
    double qty = 0;
    if(empCode == 0 || empCode  ==null){

      if(endDate == null){
        list =   listShiftModel.where((element) =>  convertStringToDateTime(element.shiftEndDate).day == startDate.day && convertStringToDateTime(element.shiftEndDate).month == startDate.month && convertStringToDateTime(element.shiftEndDate).year == startDate.year).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listShiftModel.where((element) =>  convertStringToDateTime(element.shiftEndDate).isAfter(startDate) &&  convertStringToDateTime(element.shiftEndDate).isBefore(endDate)).toList();
      }
      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty + ((list[ii].totalSale + list[ii].expenses) - (list[ii].shiftStartAmount));
      }


    }
    else{
      if(endDate == null){
        list =   listShiftModel.where((element) =>  convertStringToDateTime(element.shiftEndDate).day == startDate.day &&convertStringToDateTime(element.shiftEndDate).month == startDate.month && convertStringToDateTime(element.shiftEndDate).year == startDate.year && element.empCode == empCode).toList();
      }
      else if (endDate != null && startDate != null){
        list   = listShiftModel.where((element) =>  convertStringToDateTime(element.shiftEndDate).isAfter(startDate) &&convertStringToDateTime(element.shiftEndDate).isBefore(endDate) && element.empCode == empCode ).toList();
      }

      for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
        qty  = qty + ((list[ii].totalSale + list[ii].expenses) - (list[ii].shiftStartAmount));
      }

    }
    totalOrderAmount = qty.toString()??'0';
    totalOrderNumber = (list.length).toString();
    emit(SearchSubCategoryState());



  }


  ScrollController  scrollController = ScrollController();
  getAllProjects() async {
    FirebaseFirestore.instance
        .collection('Projects')
        .snapshots()
        .listen((event) {
      listProjects = event.docs.map((x) => Project.fromJson(x.data())).toList();
      emit(SearchSubCategoryState());
    });
  }

  getLastUpdateDate() async {
    FirebaseFirestore.instance
        .collection('LastUpdateDate').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {
      lisLastUpdateModel = event.docs.map((x) => LastUpdateModel.fromJson(x.data())).toList();
      emit(SearchSubCategoryState());
    });
  }

  Future<void> getAllSaleMaster() async {
   listSaleMasterModel = [];
    FirebaseFirestore.instance
        .collection('SaleMaster').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {
      listSaleMasterModel = event.docs.map((x) => SaleMasterModel.fromJson(x.data())).toList();

       listSaleMasterModel.sort((a, b) {
        var aDate =  convertStringToDateTime(a.EntryDate);
        var bDate = convertStringToDateTime(b.EntryDate);
        return bDate.compareTo(
            aDate);
      });
      ;
      buildItemsList();
    });
  }

  Future<void>  goToDetail({BuildContext context, String title, String img, String detailIcon, int typeId})async {

 if(typeId == 1){
   navigateTo(context, AcountExpensesDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }
 else if(typeId == 2){
   navigateTo(context, AcountSalesDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }
 else if(typeId == 3){
   navigateTo(context, AcountShiftsDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }
 else if(typeId == 4){
   navigateTo(context, AcountDiscountDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }
 else if(typeId == 5){
   navigateTo(context, AcountCancelInvoiceDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }
 else if(typeId == 6){
   navigateTo(context, AcountProfitDetailScreen(selectedIcon:img ,heroTag:detailIcon,titleName:title,typeId: typeId,));
 }




  }

  getUsers() async {
    FirebaseFirestore.instance.collection('UsersInfo').snapshots().listen((event) {
      listUser = event.docs.map((x) => UserModel.fromJson(x.data())).toList();

      emit(SelectCategoryState());
    }).onError((handleError) {
      if (kDebugMode) {
        print(handleError);
      }
    });
  }

  Future<void>  buildProjectData({data,context}) async {




     selectedProjectName = data.projectName??'';
    selectedProjectImage = data.image??'';
     projectCode = data.projectCode;

     await  getLastUpdateDate().then((value) async {
       await  getProjectUsers().then((value) async {
     await  getAllSaleMaster().then((value) async {
    await  getAllShifts().then((value) async {
      await  getAllExpenses().then((value) async {
        await   buildItemsList().then((value) {
          navigatTo(context, const LayOutScreen());
        });
      });
      });
      });
    });
    });
  }

  Future  buildItemsList()async{

 DateTime firstMonthDay =   DateTime(DateTime.now().year, DateTime.now().month,0);

 DateTime nextDay =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);


   listItems  = [item1, item2, item3, item4, item5, item6];

   for( var i = 0 ; i <= listItems.length - 1; i++ ) {

     // Expenses
      if(listItems[i].id == 1){

         var list   = listExpensesModel.where((element) => convertStringToDateTime(element.Date).isAfter(firstMonthDay) &&  convertStringToDateTime(element.Date).isBefore(nextDay) ).toList();
        double qty = 0;
        for (var element2 in list) {
          qty = qty +  element2.ExpensesQT;
        }
        listItems[i].event = qty.toString()??"0";
        emit(fr());
      }

      //sales
      else if(listItems[i].id == 2){
        double qty = 0;
        var list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(firstMonthDay) &&  convertStringToDateTime(element.EntryDate).isBefore(nextDay) && element.OperationTypeId == 2 ).toList();



        for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
          qty  = qty +  list[ii].FinalTotal;
        }




        listItems[i].event =  qty.toString();


      }


      // Shifts
      else if(listItems[i].id == 3){

        double qty = 0;
        var list   = listShiftModel.where((element) => convertStringToDateTime(element.shiftEndDate).isAfter(firstMonthDay) &&  convertStringToDateTime(element.shiftEndDate).isBefore(nextDay)).toList();

        for (var element in list) {
          double x1 = element.totalSale + element.expenses??0;
          double x2 = x1 - element.shiftStartAmount??0;


          qty  += x2;
        }





        listItems[i].event =  qty.toString();


      }

      //Discount
      else if(listItems[i].id == 4){
        double qty = 0;
        var list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(firstMonthDay) &&  convertStringToDateTime(element.EntryDate).isBefore(nextDay) && element.OperationTypeId == 2  && element.Discount > 0).toList();

        for (var element in list) {

          qty  = qty +  element.Discount??0;
        }




        listItems[i].event =  qty.toString();
      }

      // Cancel Invoice
      else if(listItems[i].id == 5){
        double qty = 0;
        var list   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(firstMonthDay) &&  convertStringToDateTime(element.EntryDate).isBefore(nextDay) && element.OperationTypeId == 3).toList();



        for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
          qty  = qty +  list[ii].FinalTotal;
        }




        listItems[i].event =  qty.toString();


      }

      else if(listItems[i].id == 6){

        double expenses = double.parse(listItems[0].event??"0")??0;

        double discoud = double.parse(listItems[2].event??"0")??0;

        double sales = double.parse(listItems[1].event??"0")??0;

        listItems[i].event =  (sales - (discoud + expenses)).toString()??"0";
       

      }


    }
   listItems2 = [];
   listItems2 = listItems;
   emit(fr());

  }

  double expenses = 0;
  double discount = 0;
  double sales = 0;

  Future<void> accountStatement ()async{
      expenses = 0;
      discount = 0;
      sales = 0;

      var listExp = [];
      var listSales = [];
      var listDiscount = [];


        // expenses
      if(empCode == 0 || empCode  ==null){


        if(endDate == null){
          listExp =   listExpensesModel.where((element) => convertStringToDateTime(element.Date).day == startDate.day && convertStringToDateTime(element.Date).month == startDate.month &&convertStringToDateTime( element.Date).year == startDate.year ).toList();
        }
        else if (endDate != null && startDate != null){
          listExp   = listExpensesModel.where((element) => convertStringToDateTime( element.Date).isAfter(startDate) &&  convertStringToDateTime(element.Date).isBefore(endDate)).toList();
        }
        for( var ii = 0 ; ii <= listExp.length - 1; ii++ ) {
          expenses  = expenses +  listExp[ii].ExpensesQT;
        }


      }
      else{
        if(endDate == null){
          listExp =   listExpensesModel.where((element) =>  convertStringToDateTime(element.Date).day == startDate.day &&convertStringToDateTime(element.Date).month == startDate.month &&convertStringToDateTime( element.Date).year == startDate.year && element.Emp_Code == empCode).toList();
        }
        else if (endDate != null && startDate != null){
          listExp   = listExpensesModel.where((element) => convertStringToDateTime( element.Date).isAfter(startDate) &&convertStringToDateTime(element.Date).isBefore(endDate) && element.Emp_Code == empCode ).toList();
        }

        for( var ii = 0 ; ii <= listExp.length - 1; ii++ ) {
          expenses  = expenses +  listExp[ii].ExpensesQT;
        }

      }


      // sales
        if(empCode == 0 || empCode  ==null){

          if(endDate == null){
            listSales =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2 ).toList();
          }
          else if (endDate != null && startDate != null){
            listSales   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2  ).toList();
          }
          for( var ii = 0 ; ii <= listSales.length - 1; ii++ ) {
            sales  = sales +  listSales[ii].FinalTotal;
          }


        }
        else{
          if(endDate == null){
            listSales =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2  && element.Emp_Code == empCode).toList();
          }
          else if (endDate != null && startDate != null){
            listSales   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2 && element.Emp_Code == empCode ).toList();
          }







          for( var ii = 0 ; ii <= list.length - 1; ii++ ) {
            sales  = sales +  list[ii].FinalTotal;
          }

        }

      // Discount
      if(empCode == 0 || empCode  ==null){

        if(endDate == null){
          listDiscount =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2 && element.Discount > 0  ).toList();
        }
        else if (endDate != null && startDate != null){
          listDiscount   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2  && element.Discount > 0 ).toList();
        }
        for( var ii = 0 ; ii <= listDiscount.length - 1; ii++ ) {
          discount  = discount +  listDiscount[ii].Discount;
        }


      }
      else{
        if(endDate == null){
          listDiscount =   listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).day == startDate.day && convertStringToDateTime(element.EntryDate).month == startDate.month && convertStringToDateTime(element.EntryDate).year == startDate.year  && element.OperationTypeId == 2  && element.Emp_Code == empCode && element.Discount > 0 ).toList();
        }
        else if (endDate != null && startDate != null){
          listDiscount   = listSaleMasterModel.where((element) => convertStringToDateTime(element.EntryDate).isAfter(startDate) &&  convertStringToDateTime(element.EntryDate).isBefore(endDate) && element.OperationTypeId == 2 && element.Emp_Code == empCode && element.Discount > 0 ).toList();
        }


        for( var ii = 0 ; ii <= listDiscount.length - 1; ii++ ) {
          discount  = discount +  list[ii].Discount;
        }

      }







  }


  Future<void> getDataByTypId({int id})async{

    if( id == 1){
      getTotalExpenses();
    }
    else if(id == 2){
      getTotalSale();
    }
    else if(id == 3){
      getTotalShifts();
    }
    else if(id == 4){

      getTotalDiscount();

    }
    else if(id == 5){
      getTotalCanceledInvoice();
    }
    else if(id == 6){

      accountStatement();
    }
    emit(fr());
  }


  Future<void> clearUserButton({int typeId}) async {
    empCode = 0;

    await getDataByTypId(id: typeId);
    emit(SelectCategoryState());
  }


  Future<void>  changeShowDetailState()async {
   isShowAllAccount = !isShowAllAccount;
   if(isShowAllAccount){
     scrollController.animateTo(180.0,
         duration: Duration(milliseconds: 500), curve: Curves.ease);
   }

   emit(SelectCategoryState());
  }


  Future<void>  changeOnlyDayOnlyState()async {
     isShowTodayAccountOnly = !isShowTodayAccountOnly;


       scrollController.animateTo(180.0,
           duration: Duration(milliseconds: 500), curve: Curves.ease);


    emit(SelectCategoryState());
  }

  logOut(context) async {
    await CachHelper.SetData(key: 'mobile', value: '');
    await CachHelper.SetData(key: 'isUserLogin', value: false);

    await CachHelper.SetData(key: 'imageUrl', value: '');
    await CachHelper.SetData(key: 'userName', value: '');
    NavigatToAndReplace(context,   LoginScreen());
  }
}
