// @dart=2.9
class SaleMasterModel {



  int SaleMasterCode;
  double TotalBeforDiscount;
  double Discount;

  double QtyTotal;
  String EntryDate;
  double FinalTotal;
  String UserName;
  int Emp_Code;
  int OperationTypeId;
  int Shift_Code;
  String PaymentType;
  String LastUpdateDate;




  SaleMasterModel({
    this.SaleMasterCode,
    this.TotalBeforDiscount,
    this.Discount,
    this.QtyTotal,
    this.OperationTypeId,
    this.EntryDate,
    this.UserName,
    this.Emp_Code,
    this.Shift_Code,
    this.PaymentType,
    this.LastUpdateDate,

  });

  SaleMasterModel.fromJson(Map<String, dynamic> json)
  {
    SaleMasterCode = json['SaleMasterCode'];
    TotalBeforDiscount = json['TotalBeforDiscount'];
    Discount = json['Discount'];
    QtyTotal = json['QtyTotal'];
    OperationTypeId = json['OperationTypeId'];

    EntryDate = json['EntryDate']??'';
    UserName = json['UserName'];
    Emp_Code = json['Emp_Code'];
    Shift_Code = json['Shift_Code'];
    PaymentType = json['PaymentType'];
    LastUpdateDate = json['LastUpdateDate'];


  }





  Map<String, dynamic> toMap()
  {
    return {

      'SaleMasterCode':SaleMasterCode,
      'TotalBeforDiscount':TotalBeforDiscount,
      'Discount':Discount,
      'OperationTypeId':OperationTypeId,
      'QtyTotal':QtyTotal,
      'EntryDate':EntryDate,
      'UserName':UserName??'',
      'Emp_Code':Emp_Code,
      'Shift_Code':Shift_Code,
      'PaymentType':PaymentType,
      'LastUpdateDate':LastUpdateDate,

    };
  }


}