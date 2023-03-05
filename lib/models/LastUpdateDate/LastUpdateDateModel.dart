

// @dart=2.9
import 'package:owneaccount/shared/network/local/helper.dart';

class LastUpdateModel {

  String lastUpdateDate;


  LastUpdateModel({

    this.lastUpdateDate,


  });

  LastUpdateModel.fromJson(Map<String, dynamic> json)
  {

    lastUpdateDate =  DateFormate(dateTime:json['LastUpdateDate'])??'';
  }



  Map<String, dynamic> toMap()
  {
    return {

      'LastUpdateDate':lastUpdateDate,

    };
  }


}