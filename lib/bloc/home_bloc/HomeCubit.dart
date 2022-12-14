// @dart=2.9

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as sd;
import 'package:pointofsale/Screens/login/login.dart';
import 'package:pointofsale/bloc/register_Bloc/registerState.dart';
import 'package:pointofsale/models/Expenses/ExpensesModel.dart';
import 'package:pointofsale/models/Item/itemModel.dart';
import 'package:pointofsale/models/SaleMaster/SaleMasterModel.dart';
import 'package:pointofsale/models/project/projectModel.dart';
import 'package:pointofsale/models/user/user_model.dart';
import 'package:pointofsale/shared/Global.dart';
import 'package:pointofsale/shared/network/local/helper.dart';
import 'package:pointofsale/shared/network/local/shared_helper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'HomeState.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeStateInitState());

  TextEditingController sendMessageTextControl = TextEditingController();
  TextEditingController titleTextControl = TextEditingController();
  TextEditingController txtUpdateCustomerBalance = TextEditingController();

  TextEditingController txtCustomerPayAmount = TextEditingController();
  TextEditingController txtnote = TextEditingController();
  double finalAmount = 0;

  String selectedProjectName = '';
  String selectedProjectImage = '';
  int projectCode = 0;

  FocusNode sendMessageNode = FocusNode();

  TabController tabController;

  bool isShowBackLayer = true;
  bool isValidSendNotiBottom = false;
  int currentIndex = 0;
  List adminScreens = [
    //  const RestrantListScreen(),
    // // const PreparedOrderScreen(),
    // // const DoneOrderScreen(),
    // // const CancelOrderScreen(),
    // const UserInformationScreen(),
    // const UserInformationScreen(),
    // const UserInformationScreen(),
    // const UserInformationScreen(),
    // const SendNotifacationScreen()
  ];

  GlobalKey<NavigatorState> mAnavigatorkey = GlobalKey<NavigatorState>();

  List userScreens = [
    // const RestrantListScreen(),
    // const FavouriteScreen(),
    // const SearchScreen(),
    // const ShopScreen(),
    // const UserInformationScreen(),
  ];
  double orderPrice = 0;
  int selectedOrderId = 0;
  bool selectedOrder = false;
 // String selectedTab = !Global.isAdmin ? '????????????????' : '?????????? ??????????';

  getFinalCustomerPayAmount(String value, double orderPrice) {
    if (value.trim().toString() != '') {
      double x = double.parse(value ?? 0) ?? 0;

      finalAmount = x - orderPrice;
    } else {
      finalAmount = orderPrice * -1;
    }

    emit(SearchSubCategoryState());
  }

  saveTransaActionOrderAndState() {}
  GlobalKey<State<StatefulBuilder>> stateKey =
      GlobalKey<State<StatefulBuilder>>();



  File profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);

      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }



  List<ExpensesModel> listExpensesModel = [];
  Future getAllExpenses() async {
    listExpensesModel = [];
    FirebaseFirestore.instance
        .collection('Expenses').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {

      listExpensesModel = event.docs.map((x) => ExpensesModel.fromJson(x.data())).toList();

      emit(SearchSubCategoryState());
    });
  }


  getAllProjects() async {
    FirebaseFirestore.instance
        .collection('Projects')
        .snapshots()
        .listen((event) {
      listProjects = event.docs.map((x) => Project.fromJson(x.data())).toList();
      emit(SearchSubCategoryState());
    });
  }


List<SaleMasterModel> listsaleMasterModel = [];
 Future getAllSaleMaster() async {
    listsaleMasterModel = [];
    FirebaseFirestore.instance
        .collection('SaleMaster').doc("ProjectCode").collection(projectCode.toString())
        .snapshots()
        .listen((event) {
      listsaleMasterModel = event.docs.map((x) => SaleMasterModel.fromJson(x.data())).toList();

      emit(SearchSubCategoryState());
    });
  }







  addNote({BuildContext context,String noteText,int projectId}){




  }



  convertDateFormat(String date) {
    if (date != null) {
      try {
        String dateAfterFormat = sd.DateFormat("dd-MM-yyyy").format(DateTime.parse(date));

        String today = sd.DateFormat("dd-MM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
        String yesterday = sd.DateFormat("dd-MM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

        if (dateAfterFormat == yesterday) {
          return 'Yesterday'+' '+ sd.DateFormat("hh:mm a").format(DateTime.parse(date));
        } else if (dateAfterFormat == today) {
          return 'Today' + ' '+sd.DateFormat("hh:mm a").format(DateTime.parse(date));
        } else {
          return dateAfterFormat+ ' '+sd.DateFormat("hh:mm a").format(DateTime.parse(date));
        }
      } catch (e) {
        return '';
      }
    } else {
      return '';
    }
  }



  RoundedLoadingButtonController loginUpdateCustomerBalance =
      RoundedLoadingButtonController();


  // addNote(){}


  void modalBottomSheetMenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 400.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.end,
                          controller: txtUpdateCustomerBalance,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            emit(SearchSubCategoryState());
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
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
                            labelText: '????????????',
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 100,
                          child: RoundedLoadingButton(
                              height: 60,
                              controller: loginUpdateCustomerBalance,
                              successColor: Colors.green,
                              color: txtUpdateCustomerBalance.text != null &&
                                      txtUpdateCustomerBalance.text.trim() != ''
                                  ? Colors.blue
                                  : Colors.grey[500],
                              disabledColor: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '??????????',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              animateOnTap: false,
                              onPressed: () {
                                if (txtUpdateCustomerBalance.text != null &&
                                    txtUpdateCustomerBalance.text.trim() !=
                                        '') {
                                  // updateCustomerBalance(context: context);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
  //
  // void updateCustomerBalance({BuildContext context}) {
  //   Navigator.pop(context);
  //
  //   double newBalance = double.parse(txtUpdateCustomerBalance.text);
  //
  //   UserAccount model = UserAccount(
  //       createdByMobile: Global.mobile,
  //       createdDate: DateTime.now().toString(),
  //       customerMobile: selectedUserId,
  //       isDeleted: false,
  //       projectId: Global.projectId,
  //       credit: newBalance.toInt(),
  //       debit: 0,
  //       orderId: 0);
  //
  //   var userAccountId = listUserAccount
  //       .where((element) => element.projectId == Global.projectId)
  //       .length;
  //
  //   if (userAccountId == 0) {
  //     userAccountId = 1;
  //   } else {
  //     userAccountId = userAccountId + 1;
  //   }
  //
  //   FirebaseFirestore.instance
  //       .collection('UserAccount')
  //       .doc(userAccountId.toString())
  //       .set(model.toMap())
  //       .then((value) {
  //     sendNotificationToUserByToken(
  //         userToken: listUser
  //             .firstWhere((element) => element.mobile == selectedUserId)
  //             .fireBaseToken,
  //         messageBody:
  //             '   ???? ?????????? ${double.parse(txtUpdateCustomerBalance.text)} ???????? ?????? ?????????? ???????? ?????????? ????????  ${getUserBalance().toString()} ?????? ${listProject.firstWhere((element) => element.id == Global.projectId).name}',
  //         messageTitle:
  //             ' ?????????? ${txtUpdateCustomerBalance.text + ' ' + ' ???????? '}???? ?????????????? ');
  //
  //     txtUpdateCustomerBalance.clear();
  //   }).catchError((e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   });
  // }

  // Change Theme Mode

  bool isDarkTheme = false;

  String selectedUserId = '';

  static HomeCubit get(context) => BlocProvider.of(context);
  int selectedCategoryId = 0;
  int selectedSubCategoryId = 0;
  int selectedItemId = 0;

  List<String> departMentList = ['??????????', 'IT'];

  List foodCategoryList = [
    {
      'imagePath': 'assets/pizza.svg',
      'name': 'Pizza',
    },
    {
      'imagePath': 'assets/sea-food.svg',
      'name': 'Seafood',
    },
    {
      'imagePath': 'assets/coke.svg',
      'name': 'Soft Drinks',
    },
    {
      'imagePath': 'assets/pizza.svg',
      'name': 'Pizza',
    },
  ];





  TextEditingController txtSubCategoryControl = TextEditingController();
  TextEditingController txtItemControl = TextEditingController();
  TextEditingController txtSearchControl = TextEditingController();
  //List<OrderModel> listAllOrders = [];

  ScrollController scrollController;
  var top = 0.0;

  // String getTotalCustomerOrdersPrice() {
  //   double debit = 0;
  //
  //   listUserAccountBase
  //       .where((element) => element.customerMobile == selectedUserId)
  //       .forEach((element) {
  //     if (element.debit != 0) {
  //       debit += element.debit;
  //     }
  //   });
  //
  //   return (debit).toString();
  // }
  //
  // String getTotalPrigectOrdersPrice() {
  //   double debit = 0;
  //
  //   listUserAccountBase
  //       .where((element) => element.projectId.toString() == selectedUserId)
  //       .forEach((element) {
  //     if (element.debit != 0) {
  //       debit += element.debit;
  //     }
  //   });
  //
  //   return (debit).toString();
  // }

  String getTotalUserPrigectOrdersPrice() {
    double debit = 0;

    // listUserAccountBase
    //     .where((element) =>
    //         element.projectId.toString() ==
    //         listProject
    //             .firstWhere((element) =>
    //                 element.name.toLowerCase() == selectedUserId.toLowerCase())
    //             .id
    //             .toString())
    //     .forEach((element) {
    //   if (element.debit != 0) {
    //     debit += element.debit;
    //   }
    // });

    return '0';
  }

  String getTotalAdminOrdersPrice() {
    double credit = 0;

    // listUserAccountBase
    //     .where((element) => element.projectId == Global.projectId)
    //     .forEach((element) {
    //   if (element.credit != 0) {
    //     credit += element.credit;
    //   }
    // });

    return (credit).toString();
  }

  bool isShowAllAccount = false;

  // getOrders() async {
  //   FirebaseFirestore.instance.collection('Orders').snapshots().listen((event) {
  //     var x1 = listAllOrders
  //             .where((element) =>
  //                 element.orderState.toLowerCase() == 'New'.toLowerCase())
  //             .length ??
  //         0;
  //
  //     listAllOrders =
  //         event.docs.map((x) => OrderModel.fromJson(x.data())).toList();
  //     listAllOrders.forEach((element) {});
  //     var x2 = listAllOrders
  //             .where((element) =>
  //                 element.orderState.toLowerCase() == 'New'.toLowerCase())
  //             .length ??
  //         0;
  //
  //     if ((x1 < x2) && Global.isAdmin) {
  //       AssetsAudioPlayer.playAndForget(
  //         Audio("assets/audios/messages.mp3"),
  //         volume: 0.8,
  //       );
  //     }
  //
  //     emit(SelectCategoryState());
  //   });
  // }
  //
  // String getTotalPriceForItem({int index}) {
  //   double price = 0;
  //   try {
  //     for (var element in listOrder[index].additionsList) {
  //       price = price + element.price;
  //     }
  //     price = price + listOrder[index].price;
  //     price = price * listOrder[index].orderCount;
  //   } catch (e) {
  //     price = 0;
  //   }
  //
  //   emit(SelectCategoryState());
  //   return price.toString();
  // }
  //
  // String getTotalAddaitonlPriceForItem({int index}) {
  //   try {
  //     double price = 0;
  //     for (var element in listOrder[index].additionsList) {
  //       price = price + element.price;
  //     }
  //     price = price * listOrder[index].orderCount;
  //     emit(SelectCategoryState());
  //     return price.toString();
  //   } catch (e) {
  //     print(e);
  //     return '0';
  //   }
  // }
  //
  // sendOrder(context) {
  //   try {
  //     if (listOrder.isNotEmpty) {
  //       double totalAdditionalPrice = 0;
  //
  //       double totalDiscountPrice = 0;
  //
  //       double orderPrice = 0;
  //
  //       for (var element1 in listOrder) {
  //         for (var element2 in element1.additionsList) {
  //           totalAdditionalPrice =
  //               totalAdditionalPrice + (element2.price * element1.orderCount);
  //         }
  //
  //         if (element1.isDiscount) {
  //           double xx = element1.oldPrice - element1.price;
  //           totalDiscountPrice =
  //               totalDiscountPrice + (xx >= 0 ? xx : 0 * element1.orderCount);
  //         }
  //
  //         orderPrice = orderPrice + (element1.price * element1.orderCount);
  //       }
  //       orderPrice = (orderPrice + totalAdditionalPrice) - totalDiscountPrice;
  //
  //       var orderId = 1;
  //
  //       if (listAllOrders.isNotEmpty) {
  //         orderId = listAllOrders.length + 1;
  //       }
  //
  //       var model = OrderModel(
  //           orderId: orderId,
  //           projectId: Global.projectId,
  //           userMobile: Global.mobile,
  //           adminMobile: '0',
  //           createdDate: DateTime.now().toString(),
  //           listItemModel: listOrder,
  //           totalAdditionalPrice: totalAdditionalPrice,
  //           totalDiscountPrice: totalDiscountPrice,
  //           userName: Global.userName,
  //           departMent: 'Programmer',
  //           orderPrice: orderPrice,
  //           orderState: 'New',
  //           isDeleted: 0,
  //           orderCount: listOrder.length ?? 0);
  //
  //       FirebaseFirestore.instance
  //           .collection('Orders')
  //           .doc(orderId.toString())
  //           .set(model.toJson())
  //           .then((value) {
  //         FirebaseFirestore.instance
  //             .collection('Orders')
  //             .doc(orderId.toString())
  //             .set(model.toJson())
  //             .then((value) {
  //           for (var element in listUser) {
  //             if (element.isAdmin &&
  //                 listProject.any((element2) =>
  //                     element2.adminMobile == element.mobile &&
  //                     element2.id == Global.projectId)) {
  //               sendNotificationToUserByToken(
  //                   messageBody: '${Global.userName} ???? ?????????? ?????? ???????? ????  ',
  //                   messageTitle: '?????? ????????',
  //                   userToken: element.fireBaseToken);
  //             }
  //           }
  //
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               backgroundColor: Colors.green,
  //               content: Text(
  //                 '???? ?????????? ?????????? ??????????',
  //                 textAlign: TextAlign.center,
  //               ),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(30))),
  //               behavior: SnackBarBehavior.floating,
  //               padding: EdgeInsets.all(20.0),
  //               duration: Duration(milliseconds: 4000)));
  //           listOrder = [];
  //         }).catchError((onError) {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               backgroundColor: Colors.red,
  //               content: Text(
  //                 '?????? ?????? ???????????? ?????????? ?????????? ???????????????? ?????? ????????',
  //                 textAlign: TextAlign.center,
  //               ),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(30))),
  //               behavior: SnackBarBehavior.floating,
  //               padding: EdgeInsets.all(20.0),
  //               duration: Duration(milliseconds: 4000)));
  //         });
  //       }).catchError((onError) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text(
  //               '?????? ?????? ???????????? ?????????? ?????????? ???????????????? ?????? ????????',
  //               textAlign: TextAlign.center,
  //             ),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(30))),
  //             behavior: SnackBarBehavior.floating,
  //             padding: EdgeInsets.all(20.0),
  //             duration: Duration(milliseconds: 4000)));
  //       });
  //       // Send Notification For Admin
  //
  //       emit(SelectCategoryState());
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text(
  //           '?????? ?????? ???????????? ?????????? ?????????? ???????????????? ?????? ????????',
  //           textAlign: TextAlign.center,
  //         ),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(30))),
  //         behavior: SnackBarBehavior.floating,
  //         padding: EdgeInsets.all(20.0),
  //         duration: Duration(milliseconds: 4000)));
  //   }
  // }

  // sendOrder(context) {
  //   try {
  //     if (listOrder.isNotEmpty) {
  //       double totalAdditionalPrice = 0;
  //
  //       double totalDiscountPrice = 0;
  //
  //       double orderPrice = 0;
  //
  //       for (var element1 in listOrder) {
  //         for (var element2 in element1.additionsList) {
  //           totalAdditionalPrice =
  //               totalAdditionalPrice + (element2.price * element1.orderCount);
  //         }
  //
  //         if (element1.isDiscount) {
  //           double xx = element1.oldPrice - element1.price;
  //           totalDiscountPrice =
  //               totalDiscountPrice + (xx >= 0 ? xx : 0 * element1.orderCount);
  //         }
  //
  //         orderPrice = orderPrice + (element1.price * element1.orderCount);
  //       }
  //       orderPrice = (orderPrice + totalAdditionalPrice) - totalDiscountPrice;
  //       print('totalAdditionalPrice');
  //       print(totalAdditionalPrice);
  //       print('totalAdditionalPrice');
  //
  //       print('totalDiscountPrice');
  //       print(totalDiscountPrice);
  //       print('totalDiscountPrice');
  //
  //       print('orderPrice');
  //       print(orderPrice);
  //       print('orderPrice');
  //
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.green,
  //           content: Text(
  //             '???? ?????????? ?????????? ??????????',
  //             textAlign: TextAlign.center,
  //           ),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           behavior: SnackBarBehavior.floating,
  //           padding: EdgeInsets.all(20.0),
  //           duration: Duration(milliseconds: 4000)));
  //
  //       emit(SelectCategoryState());
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  String orderStateArabic(String state) {
    String arState = '';
    if (state.toLowerCase() == 'new'.toLowerCase()) {
      arState = '????????';
    } else if (state.toLowerCase() == 'Prepared'.toLowerCase()) {
      arState = '?????? ??????????????';
    } else if (state.toLowerCase() == 'Done'.toLowerCase()) {
      arState = '???? ??????????????';
    } else if (state.toLowerCase() == 'Canceled'.toLowerCase()) {
      arState = '???? ??????????????';
    }
    return arState;
  }

  Color orderStateColor(String state) {
    Color arStateColor = Colors.red;
    if (state.toLowerCase() == 'new'.toLowerCase()) {
      arStateColor = Colors.red;
    } else if (state.toLowerCase() == 'Prepared'.toLowerCase()) {
      arStateColor = Colors.orange;
    } else if (state.toLowerCase() == 'Done'.toLowerCase()) {
      arStateColor = Colors.green;
    } else if (state.toLowerCase() == 'Canceled'.toLowerCase()) {
      arStateColor = Colors.red;
    }
    return arStateColor;
  }

  // updateOrderState({OrderModel orderModel}) {
  //   FirebaseFirestore.instance
  //       .collection('Orders')
  //       .doc(orderModel.orderId.toString())
  //       .update(orderModel.toJson())
  //       .then((value) {
  //     if (orderModel.orderState.toLowerCase() == 'Done'.toLowerCase()) {
  //       UserAccount model = UserAccount(
  //           createdByMobile: Global.mobile,
  //           createdDate: DateTime.now().toString(),
  //           customerMobile: orderModel.userMobile,
  //           isDeleted: false,
  //           projectId: orderModel.projectId,
  //           credit: 0,
  //           debit: orderModel.orderPrice.toInt(),
  //           orderId: orderModel.orderId);
  //       FirebaseFirestore.instance
  //           .collection('UserAccount')
  //           .doc()
  //           .set(model.toMap());
  //
  //       UserAccount model2 = UserAccount(
  //           createdByMobile: Global.mobile,
  //           createdDate: DateTime.now().toString(),
  //           customerMobile: orderModel.userMobile,
  //           isDeleted: false,
  //           projectId: orderModel.projectId,
  //           credit: double.parse(txtCustomerPayAmount.text).toInt(),
  //           debit: 0,
  //           orderId: orderModel.orderId);
  //       FirebaseFirestore.instance
  //           .collection('UserAccount')
  //           .doc()
  //           .set(model2.toMap());
  //     }
  //   }).catchError((onError) {});
  // }
  //
  // getTotalPrice() {
  //   double orderPrice = 0;
  //   // for (var element in listOrder) {
  //   //   orderPrice += element.price;
  //   //   for (var element in element.additionsList) {
  //   //     orderPrice += element.price;
  //   //   }
  //   //   return orderPrice.toString();
  //   // }
  //
  //   for (var element in listOrder) {
  //     for (int i = 0; i < element.orderCount; i++) {
  //       orderPrice += element.price;
  //       for (var element2 in element.additionsList) {
  //         orderPrice += element2.price;
  //       }
  //     }
  //   }
  //
  //   return orderPrice.toString();
  // }

  // String getUserBalance() {
  //   double debit = 0;
  //   double credit = 0;
  //   listUserAccountBase
  //       .where((element) => element.customerMobile == selectedUserId)
  //       .forEach((element) {
  //     if (element.debit != 0) {
  //       debit += element.debit;
  //     } else {
  //       credit += element.credit;
  //     }
  //   });
  //
  //   return (credit - debit).toString();
  // }

  // String getUserProjectBalance() {
  //   double debit = 0;
  //   double credit = 0;
  //   listUserAccountBase
  //       .where((element) =>
  //           element.projectId ==
  //               listProject
  //                   .firstWhere((element) =>
  //                       element.name.toLowerCase() ==
  //                       selectedUserId.toLowerCase())
  //                   .id &&
  //           element.customerMobile == Global.mobile)
  //       .forEach((element) {
  //     if (element.debit != 0) {
  //       debit += element.debit;
  //     } else {
  //       credit += element.credit;
  //     }
  //   });
  //
  //   return (credit - debit).toString();
  // }

  // String getAdminBalance() {
  //   double debit = 0;
  //   double credit = 0;
  //   listUserAccountBase
  //       .where((element) => element.projectId == Global.projectId)
  //       .forEach((element) {
  //     if (element.debit != 0) {
  //       debit += element.debit;
  //     } else {
  //       credit += element.credit;
  //     }
  //   });
  //
  //   return (credit - debit).toString();
  // }

  // addNewItemToCartFromItemScreen({itemId, orderCount}) {
  //   var newList = listItemsSearch.firstWhere((element) =>
  //       element.itemId == itemId && element.projectId == Global.projectId);
  //   var model = ItemModel(
  //     orderCount: orderCount,
  //     oldPrice: newList.oldPrice,
  //     itemTitle: newList.itemTitle,
  //     itemId: newList.itemId,
  //     isPopular: newList.isPopular,
  //     isDiscount: newList.isDiscount,
  //     isDeleted: newList.isDeleted,
  //     isAvailable: newList.isAvailable,
  //     image: newList.image,
  //     description: newList.description,
  //     createdDate: newList.createdDate,
  //     categoryTitle: newList.categoryTitle,
  //     categoryId: newList.categoryId,
  //     additionsList: listOfSelectedAdditions.toList(),
  //     price: newList.price,
  //     supCategoryId: newList.supCategoryId,
  //     supCategoryTitle: newList.supCategoryTitle,
  //     isFavourite: listFavourite.any((element) =>
  //             element.ItemId == itemId &&
  //             element.UesrMobile == Global.mobile &&
  //             element.projectId == Global.projectId)
  //         ? true
  //         : false ?? false,
  //     userMobile: Global.mobile,
  //     userName: Global.userName,
  //     projectId: Global.projectId,
  //   );
  //   listOrder.add(model);
  //   listOfSelectedAdditions = [];
  //   emit(SearchSubCategoryState());
  // }

  // addItemToCart(
  //     {int orderCount,
  //     ItemModel itemModel,
  //     bool isFavourit,
  //     BuildContext context}) {
  //   var model = ItemModel(
  //     orderCount: orderCount,
  //     orderState: 'New',
  //     oldPrice: itemModel.oldPrice,
  //     itemTitle: itemModel.itemTitle,
  //     itemId: itemModel.itemId,
  //     isPopular: itemModel.isPopular,
  //     isDiscount: itemModel.isDiscount,
  //     isDeleted: itemModel.isDeleted,
  //     isAvailable: itemModel.isAvailable,
  //     image: itemModel.image,
  //     description: itemModel.description,
  //     createdDate: itemModel.createdDate,
  //     categoryTitle: itemModel.categoryTitle,
  //     categoryId: itemModel.categoryId,
  //     additionsList: listOfSelectedAdditions.toList(),
  //     price: itemModel.price,
  //     supCategoryId: itemModel.supCategoryId,
  //     supCategoryTitle: itemModel.supCategoryTitle,
  //     isFavourite: listFavourite.any((element) =>
  //             element.ItemId == itemModel.itemId &&
  //             element.UesrMobile == Global.mobile &&
  //             element.projectId == Global.projectId)
  //         ? true
  //         : false ?? false,
  //     userMobile: Global.mobile,
  //     userName: Global.userName,
  //     projectId: Global.projectId,
  //   );
  //   listOrder.add(model);
  //   listOfSelectedAdditions = [];
  //   emit(SearchSubCategoryState());
  // }
  //
  // addNewItemToCartFromFeedsScreen({itemId, orderCount}) {
  //   var newList = popularList.firstWhere((element) =>
  //       element.itemId == itemId && element.projectId == Global.projectId);
  //
  //   var model = ItemModel(
  //     orderCount: orderCount,
  //     orderState: 'New',
  //     oldPrice: newList.oldPrice,
  //     itemTitle: newList.itemTitle,
  //     itemId: newList.itemId,
  //     isPopular: newList.isPopular,
  //     isDiscount: newList.isDiscount,
  //     isDeleted: newList.isDeleted,
  //     isAvailable: newList.isAvailable,
  //     image: newList.image,
  //     description: newList.description,
  //     createdDate: newList.createdDate,
  //     categoryTitle: newList.categoryTitle,
  //     categoryId: newList.categoryId,
  //     additionsList: listOfSelectedAdditions.toList(),
  //     price: newList.price,
  //     supCategoryId: newList.supCategoryId,
  //     supCategoryTitle: newList.supCategoryTitle,
  //     isFavourite: listFavourite.any((element) =>
  //             element.ItemId == itemId &&
  //             element.UesrMobile == Global.mobile &&
  //             element.projectId == Global.projectId)
  //         ? true
  //         : false ?? false,
  //     userMobile: Global.mobile,
  //     userName: Global.userName,
  //     projectId: Global.projectId,
  //   );
  //
  //   listOrder.add(model);
  //
  //   listOfSelectedAdditions = [];
  //
  //   emit(SearchSubCategoryState());
  // }
  //
  // addNewItemToCartFromSearchScreen({itemId, orderCount, context}) {
  //   var newList =
  //       listItemsSearch.firstWhere((element) => element.itemId == itemId);
  //
  //   var model = ItemModel(
  //     orderCount: orderCount,
  //     orderState: 'New',
  //     oldPrice: newList.oldPrice,
  //     itemTitle: newList.itemTitle,
  //     itemId: newList.itemId,
  //     isPopular: newList.isPopular,
  //     isDiscount: newList.isDiscount,
  //     isDeleted: newList.isDeleted,
  //     isAvailable: newList.isAvailable,
  //     image: newList.image,
  //     description: newList.description,
  //     createdDate: newList.createdDate,
  //     categoryTitle: newList.categoryTitle,
  //     categoryId: newList.categoryId,
  //     additionsList: listOfSelectedAdditions.toList(),
  //     price: newList.price,
  //     supCategoryId: newList.supCategoryId,
  //     supCategoryTitle: newList.supCategoryTitle,
  //     isFavourite: listFavourite.any((element) =>
  //             element.ItemId == itemId &&
  //             element.UesrMobile == Global.mobile &&
  //             element.projectId == Global.projectId)
  //         ? true
  //         : false ?? false,
  //     userMobile: Global.mobile,
  //     userName: Global.userName,
  //     projectId: Global.projectId,
  //   );
  //
  //   listOrder.add(model);
  //
  //   listOfSelectedAdditions = [];
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.green,
  //       content: Text(
  //         '???? ?????????????? ?????? ??????????????????',
  //         textAlign: TextAlign.center,
  //       ),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(30))),
  //       behavior: SnackBarBehavior.floating,
  //       padding: EdgeInsets.all(20.0),
  //       duration: Duration(milliseconds: 4000)));
  //   emit(SearchSubCategoryState());
  // }
  //
  // getCategory() async {
  //   FirebaseFirestore.instance
  //       .collection('Category')
  //       .snapshots()
  //       .listen((event) {
  //     listCategory =
  //         event.docs.map((x) => CategoryModel.fromJson(x.data())).toList();
  //     emit(SelectCategoryState());
  //   });
  // }
  //
  // getSubCategory() async {
  //   FirebaseFirestore.instance
  //       .collection('SubCategory')
  //       .snapshots()
  //       .listen((event) {
  //     listSubCategory =
  //         event.docs.map((x) => SubCategory.fromJson(x.data())).toList();
  //     emit(SelectCategoryState());
  //   });
  // }
  //
  // getFavourite() async {
  //   FirebaseFirestore.instance
  //       .collection('Favourite')
  //       .doc(Global.mobile)
  //       .collection('ItemModel')
  //       .snapshots()
  //       .listen((event) {
  //     listFavourite =
  //         event.docs.map((x) => FavouritModel.fromJson(x.data())).toList();
  //
  //     emit(SelectCategoryState());
  //   });
  // }
  //
  // getItems() async {
  //   FirebaseFirestore.instance.collection('Items').snapshots().listen((event) {
  //     listItems = event.docs.map((x) => ItemModel.fromJson(x.data())).toList();
  //
  //     listItemsSearch = listItems;
  //     listItemsBySubCategSearch = listItems;
  //     popularList = listItems.where((element) => element.isPopular).toList();
  //
  //     emit(SelectCategoryState());
  //   });
  // }

  // List<UserAccount> listUserAccountBase = [];
  // List<UserAccount> listUserAccount = [];
    List<Project> listProjects = [];

  // getUsersAccount() async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('UserAccount')
  //         .orderBy('createdDate')
  //         .snapshots()
  //         .listen((event) {
  //       listUserAccount =
  //           event.docs.map((x) => UserAccount.fromJson(x.data())).toList();
  //
  //       listUserAccountBase = listUserAccount;
  //
  //       emit(SelectCategoryState());
  //     }).onError((handleError) {
  //       print(handleError);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  // getProjectBalance({String projectID,String adminId}) async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('Balance').doc(adminId).collection(projectID)
  //         .orderBy('LastDateUpdate')
  //         .snapshots()
  //         .listen((event) {
  //       listProjectBalance =
  //           event.docs.map((x) => ProjectBalance.fromJson(x.data())).toList();
  //
  //       listProjectBalance.forEach((element) {
  //
  //         print(element.toMap());
  //       });
  //
  //       emit(SelectCategoryState());
  //     }).onError((handleError) {
  //       print(handleError);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }



  // List<AdditionsModel> listOfSelectedAdditions = [];
  //
  // getAdditions() async {
  //   FirebaseFirestore.instance
  //       .collection('Additions')
  //       .snapshots()
  //       .listen((event) {
  //     listAdditions =
  //         event.docs.map((x) => AdditionsModel.fromJson(x.data())).toList();
  //
  //     listAdditions.forEach((element) {
  //       print(element.toMap());
  //     });
  //
  //     emit(SelectCategoryState());
  //   });
  // }
  //
  // List<FavouritModel> listFavourite = [];

  // changeItemFavouriteState({bool isFavourite = false, ItemModel itemModel}) {
  //   FavouritModel model = FavouritModel(
  //       isFavourit: !isFavourite,
  //       ItemId: itemModel.itemId,
  //       UesrMobile: Global.mobile,
  //       projectId: Global.projectId);
  //
  //   FirebaseFirestore.instance
  //       .collection('Favourite')
  //       .doc(Global.mobile)
  //       .collection('ItemModel')
  //       .doc(itemModel.itemId.toString())
  //       .update(model.toMap())
  //       .then((value) {})
  //       .catchError((onError) {
  //     FirebaseFirestore.instance
  //         .collection('Favourite')
  //         .doc(Global.mobile)
  //         .collection('ItemModel')
  //         .doc(itemModel.itemId.toString())
  //         .set(model.toMap())
  //         .then((value) {})
  //         .catchError(onError);
  //   });
  // }
  //
  // selectCategory(categoryId, context) async {
  //   selectedSubCategoryId = 0;
  //   selectedItemId = 0;
  //   selectedCategoryId = categoryId;
  //
  //   listSubCategorySearch = listSubCategory
  //       .where((element) =>
  //           element.categoryId == categoryId &&
  //           element.projectId == Global.projectId)
  //       .toList();
  //
  //   if (listSubCategorySearch.isNotEmpty) {
  //     navigateTo(
  //         context,
  //         SubCategoryScreen(
  //           categoryTitle: listCategory
  //               .firstWhere((element) =>
  //                   element.categoryId == selectedCategoryId &&
  //                   element.projectId == Global.projectId)
  //               .categoryTitle,
  //         ));
  //   } else {
  //     EasyLoading.showError('???? ???????? ????????????');
  //   }
  //
  //   emit(SelectCategoryState());
  // }
  //
  // selectSubCategory({supCategoryId, context}) async {
  //   selectedItemId = 0;
  //   selectedSubCategoryId = supCategoryId;
  //
  //
  //   listItemsSearch = listItems
  //       .where((element) =>
  //           element.supCategoryId == supCategoryId &&
  //           element.projectId == Global.projectId)
  //       .toList();
  //   emit(SelectCategoryState());
  //
  //   if (listItemsSearch.isNotEmpty) {
  //     txtSubCategoryControl.clear();
  //     listSubCategorySearch = listSubCategory
  //         .where((element) =>
  //             element.categoryId == selectedCategoryId &&
  //             element.projectId == Global.projectId)
  //         .toList();
  //     navigateTo(
  //         context,
  //         ItemsScreen(
  //             subcategoryTitle: listItems
  //                     .firstWhere((element) =>
  //                         element.supCategoryId == supCategoryId &&
  //                         element.projectId == Global.projectId)
  //                     .supCategoryTitle ??
  //                 ''));
  //   } else {
  //     EasyLoading.showError('???? ???????? ????????????');
  //   }
  //
  //   emit(SelectCategoryState());
  // }
  //
  // searchInSupCategory(String value) {
  //   if (value.trim() != '') {
  //     listSubCategorySearch = listSubCategory
  //         .where((element) =>
  //             element.categoryId == selectedCategoryId &&
  //             element.subCategoryTitle
  //                 .toLowerCase()
  //                 .contains(value.toLowerCase()) &&
  //             element.projectId == Global.projectId)
  //         .toList();
  //   } else {
  //     listSubCategorySearch = listSubCategory
  //         .where((element) =>
  //             element.categoryId == selectedCategoryId &&
  //             element.projectId == Global.projectId)
  //         .toList();
  //   }
  //
  //   emit(SearchSubCategoryState());
  // }
  //
  // searchInItems(String value) {
  //   if (value.trim() != '') {
  //     listItemsSearch = listItems
  //         .where((element) =>
  //             element.itemTitle.contains(value) ||
  //             element.categoryTitle.contains(value) ||
  //             element.supCategoryTitle.contains(value))
  //         .toList();
  //   } else {
  //     listItemsSearch = listItems;
  //   }
  //
  //   emit(SearchSubCategoryState());
  // }
  //
  // searchInItemsBySupCategory(String value) {
  //   if (value.trim() != '') {
  //     listItemsBySubCategSearch = listItems
  //         .where((element) =>
  //             element.categoryId == selectedCategoryId &&
  //             element.supCategoryId == selectedSubCategoryId &&
  //             element.projectId == Global.projectId &&
  //             element.itemTitle.contains(value))
  //         .toList();
  //   } else {
  //     listItemsBySubCategSearch = listItems;
  //   }
  //
  //   emit(SearchSubCategoryState());
  // }
  //
  // searchInFavourite(String value) {
  //   if (value.trim() != '') {
  //     listFavouriteSearch = listItems
  //         .where((element) =>
  //             element.itemTitle.toLowerCase().contains(value.toLowerCase()) &&
  //             element.projectId == Global.projectId)
  //         .toList();
  //   } else {
  //     listFavouriteSearch = listItems
  //         .where((element) => element.projectId == Global.projectId)
  //         .toList();
  //   }
  //   emit(SearchSubCategoryState());
  // }
  //
  // sendNotifacation() {
  //   Dio dio;
  //   dio = Dio(
  //       BaseOptions(baseUrl: '', receiveDataWhenStatusError: true, headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'key=AAAARcAtNzU:APA91bGKDZmMAXkV3mRi_5_BvnLmaxm2rZHF7JBskZcIIkbVx34kfjzoNB-iocOI4sI4uR8Bcg0WV1B84BJ_VHWzi7gPAlC943DuTIaQOswi3upbld6tqEdO4R732LzWqaIpluYNkM_w',
  //   }));
  //   var data = {
  //     "notification": {"body": "this is a body", "title": "this is a title"},
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "1",
  //       "status": "done"
  //     },
  //     "to": Global.fireBaseToken
  //   };
  //   dio
  //       .post('https://fcm.googleapis.com/fcm/send', data: data)
  //       .then((value) {});
  // }

  // sendNotificationToUserByToken(
  //     {String messageTitle, String messageBody, String userToken}) {
  //   // print(messageTitle);
  //   // print(messageBody);
  //   // print(userToken);
  //
  //   Dio dio;
  //   dio = Dio(
  //       BaseOptions(baseUrl: '', receiveDataWhenStatusError: true, headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'key=AAAARcAtNzU:APA91bGKDZmMAXkV3mRi_5_BvnLmaxm2rZHF7JBskZcIIkbVx34kfjzoNB-iocOI4sI4uR8Bcg0WV1B84BJ_VHWzi7gPAlC943DuTIaQOswi3upbld6tqEdO4R732LzWqaIpluYNkM_w',
  //   }));
  //   var data = {
  //     "notification": {"body": messageBody, "title": messageTitle},
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "1",
  //       "status": "done"
  //     },
  //     "to": userToken
  //   };
  //   dio
  //       .post('https://fcm.googleapis.com/fcm/send', data: data)
  //       .then((value) {})
  //       .catchError((onError) {
  //     print(onError);
  //   });
  // }

  // sendNotificationForAllUser(context) async {
  //   for (var element in listUser) {
  //     await sendNotificationToUserByToken(
  //         messageTitle: titleTextControl.text,
  //         messageBody: sendMessageTextControl.text,
  //         userToken: element.fireBaseToken);
  //   }
  //
  //   sendMessageTextControl.clear();
  //   titleTextControl.clear();
  //   emit(SelectCategoryState());
  // }

  RoundedLoadingButtonController sendNotifactionBtnController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController callBtnController =
      RoundedLoadingButtonController();

  List ingredients = [
    {
      'imagePath': 'assets/tomato.png',
    },
    {
      'imagePath': 'assets/onion.png',
    },
    {
      'imagePath': 'assets/tomato.png',
    },
    {
      'imagePath': 'assets/onion.png',
    },
    {
      'imagePath': 'assets/tomato.png',
    },
    {
      'imagePath': 'assets/onion.png',
    },
  ];

    List<UserModel> listUser = [];

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
  Items item1 = Items(
      id: 1,
      title: "??????????????????",
      subtitle: "",
      event: "3 Events",
      img: "assets/images/expenses.png"
  );
  Items item2 = Items(
    id: 2,
    title: "????????????????",
    subtitle: "????????????????",
    event: "4 Items",
    img: "assets/images/revenue.png",
  );
  Items item3 =   Items(
    id: 4,
    title: "????????????????",
    subtitle: "Lucy Mao going to Office",
    event: "dfgsg",
    img: "assets/images/discount.png",
  );
  Items item4 =     Items(
    id: 3,
    title: "????????????????",
    subtitle: "Rose favirited your Post",
    event: "sdfasd",
    img: "assets/images/shifts.png",
  );
  Items item5 =   Items(
    id: 6,
    title: "?????????????? ????????????????",
    subtitle: "Homework, Design",
    event: "4 Items",
    img: "assets/images/balance.png",
  );
  Items item6 =   Items(
    id: 5,
    title: "???????????????? ??????????????",
    subtitle: "????????????",
    event: "2 Items",

    img: "assets/images/cancel.png",
  );



  List<Items> listItems = [];

 Future  buildItemsList()async{

   listItems  = [item1, item2, item3, item4, item5, item6];

    for (var element in listItems) {

      if(element.id == 1){

        double qty = 0;
        for (var element2 in listExpensesModel) {
          qty = qty +  element2.ExpensesQT;
        }
        element.event = qty.toString()??"0";
        emit(fr());
      }
      else if(element.id == 2){
        double qty = 0;
        listsaleMasterModel.where((element2) => element2.OperationTypeId == 2).forEach((element) {
          qty  = qty +  element.FinalTotal;
        });

        element.event = qty.toString();
        emit(fr());

      }
      else if(element.id == 3){

      }
      else if(element.id == 4){

      }
      else if(element.id == 5){

      }
      else if(element.id == 6){

      }



    }



  }


  logOut(context) async {
    await CachHelper.SetData(key: 'mobile', value: '');
    await CachHelper.SetData(key: 'isUserLogin', value: false);
    await CachHelper.SetData(key: 'isAdmin', value: false);
    await CachHelper.SetData(key: 'imageUrl', value: '');
    await CachHelper.SetData(key: 'userName', value: '');
    await CachHelper.SetData(key: 'departmentId', value: 0);
    Global.isAdmin = false;
    currentIndex = 0;
    NavigatToAndReplace(context,   LoginScreen());
  }
}
