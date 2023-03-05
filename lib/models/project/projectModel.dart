// @dart = 2.9
import 'package:owneaccount/models/user/user_model.dart';

class Project{

  String projectName;
  String image;
  int projectCode;
  bool isActive;

  List<UserModel> listUserModel;

  Project({
    this.projectName,
    this.projectCode,
    this.isActive,
    this.image,
    this.listUserModel
  });

  Project.fromJson(Map<String, dynamic> json)
  {
    projectName = json['ProjectName'];
    projectCode = json['ProjectCode'];
    isActive = json['IsActive'];
    image = json['image'];
    if (json['listUsers'] != null) {
      listUserModel = <UserModel>[];
      json['listUsers'].forEach((v) {
        listUserModel.add(UserModel.fromJson(v));
      });
    }

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};


    data['ProjectName'] = projectName??0;
    data['ProjectCode'] = projectCode??'';
    data['image'] = image??'';
    data['IsActive'] = isActive??'';
    if (listUserModel != null) {
      data['listUsers'] = listUserModel.map((v) => v.toMap()).toList();
    }
    return data;
  }



}


