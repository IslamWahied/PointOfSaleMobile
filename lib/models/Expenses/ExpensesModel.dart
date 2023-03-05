
// @dart=2.9

import 'package:owneaccount/shared/network/local/helper.dart';

class ExpensesModel {




  String ExpensesName;
  String UserName;
  String Date;

  String ExpensesNotes;
  double ExpensesQT;
  int ExpensesCode;
  int Shift_Code;
  String Employee_Name;

  int Emp_Code;
  String LastUpdateDate;




  ExpensesModel({
    this.ExpensesName,
    this.UserName,
    this.Date,
    this.ExpensesNotes,
    this.ExpensesCode,
    this.Shift_Code,
    this.Emp_Code,
    this.Employee_Name,
    this.ExpensesQT,

    this.LastUpdateDate,

  });

  ExpensesModel.fromJson(Map<String, dynamic> json)
  {
    ExpensesName = json['ExpensesName'];
    UserName = json['UserName'];
    Date =  DateFormate(dateTime:json['Date'])??'';

    ExpensesNotes = json['ExpensesNotes']??'';

    ExpensesCode = json['ExpensesCode'] ;
    Shift_Code = json['Shift_Code'];
    Emp_Code = json['Emp_Code'];
    Employee_Name = json['Employee_Name'];
    ExpensesQT = (json['ExpensesQT'] as num).toDouble();
    LastUpdateDate = DateFormate(dateTime:json['LastUpdateDate'])??'';



  }





  Map<String, dynamic> toMap()
  {
    return {

      'ExpensesName':ExpensesName,
      'UserName':UserName,
      'Date':Date.toString(),
      'ExpensesNotes':ExpensesNotes??'',
      'ExpensesCode':ExpensesCode,
      'Shift_Code':Shift_Code ,
      'Emp_Code':Emp_Code,
      'Employee_Name':Employee_Name,
      'ExpensesQT':(ExpensesQT).toDouble(),
      'LastUpdateDate':LastUpdateDate,

    };
  }


}