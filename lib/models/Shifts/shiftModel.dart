

// @dart=2.9
import 'package:owneaccount/shared/network/local/helper.dart';

class ShiftModel {


  int shiftCode;
  String shiftStartDate;
  String shiftEndDate;

  double shiftStartAmount;
  double shiftEndAmount;
  double shiftIncreasedisability;
  String userName;
  int empCode;
  double expenses;
  double totalSale;
  String lastUpdateDate;


  ShiftModel({
    this.shiftCode,
    this.shiftStartDate,
    this.shiftEndDate,
    this.shiftStartAmount,
    this.shiftEndAmount,
    this.shiftIncreasedisability,
    this.userName,
    this.empCode,
    this.expenses,
    this.totalSale,
    this.lastUpdateDate,


  });

  ShiftModel.fromJson(Map<String, dynamic> json)
  {
    shiftCode = json['ShiftCode'];

    shiftStartDate =  DateFormate(dateTime:json['ShiftStartDate'])??'';

    shiftEndDate =  DateFormate(dateTime:json['ShiftEndDate'])??'';
    shiftStartAmount = json['ShiftStartAmount'];
    shiftEndAmount = json['ShiftEndAmount'];
    shiftIncreasedisability = json['ShiftIncreasedisability']??0;

    userName = json['UserName'] ?? '';
    empCode = json['EmpCode'];
    expenses = json['Expenses'];
    totalSale = json['TotalSale'];
    lastUpdateDate =  DateFormate(dateTime:json['LastUpdateDate'])??'';

  }



  Map<String, dynamic> toMap()
  {
    return {

      'ShiftCode':shiftCode,

      'ShiftStartDate':shiftStartDate,
      'ShiftEndDate':shiftEndDate,
      'ShiftStartAmount':shiftStartAmount,
      'ShiftEndAmount':shiftEndAmount,
      'ShiftIncreasedisability':shiftIncreasedisability,
      'UserName':userName??'',
      'EmpCode':empCode,
      'Expenses':expenses,
      'TotalSale':totalSale,
      'LastUpdateDate':lastUpdateDate,

    };
  }


}