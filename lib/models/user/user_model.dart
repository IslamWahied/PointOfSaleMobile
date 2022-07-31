// @dart=2.9
class UserModel
{

int mangerCode ;
  String mangerName;
  int projectSequence;

  int projectId;
  bool isActive;

  String mangerMobile;



  UserModel({

    this.isActive,
    this.mangerCode,
    this.mangerMobile,
    this.mangerName,
    this.projectId,
    this.projectSequence,

  });

  UserModel.fromJson(Map<String, dynamic> json)
  {


    isActive = json['IsActive'];
    mangerCode = json['MangerCode'];
  mangerMobile = json['MangerMobile'];
  mangerName = json['MangerName'];
    projectId = json['ProjectId']??0;
    projectSequence = json['ProjectSequence']??0;

  }

  Map<String, dynamic> toMap()
  {
    return {

      'IsActive':isActive,
      'MangerCode':mangerCode,
      'MangerMobile':mangerMobile,
      'MangerName':mangerName,
      'ProjectId':projectId??0,
      'ProjectSequence':projectSequence??0,

    };
  }
}