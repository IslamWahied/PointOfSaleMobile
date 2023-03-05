// @dart=2.9
class EmployeeModel
{

  int BranchID ;
  int EmployeeCode;
  String EmployeeMobile1;
  String EmployeeMobile2;

  String EmployeeName;
  String LastUpdateDate;

  int SexTypeCode;



  EmployeeModel({

    this.BranchID ,
    this.EmployeeCode,
    this.EmployeeMobile1,
    this.EmployeeMobile2,

    this.EmployeeName,
    this.LastUpdateDate,

    this.SexTypeCode,


  });

  EmployeeModel.fromJson(Map<String, dynamic> json)
  {

    BranchID = json['BranchID'];
    EmployeeCode= json['EmployeeCode'];
    EmployeeMobile1= json['EmployeeMobile1'];
    EmployeeMobile2= json['EmployeeMobile2'];

  EmployeeName= json['EmployeeName'];
  LastUpdateDate= json['LastUpdateDate'];

    SexTypeCode= json['SexTypeCode'];


  }

  Map<String, dynamic> toMap()
  {
    return {


      'BranchID':BranchID,
      'EmployeeCode':EmployeeCode,
      'EmployeeMobile1':EmployeeMobile1,
      'EmployeeMobile2':EmployeeMobile2,
      'EmployeeName':EmployeeName??0,
      'LastUpdateDate':LastUpdateDate??0,
      'SexTypeCode':SexTypeCode??0,

    };
  }
}