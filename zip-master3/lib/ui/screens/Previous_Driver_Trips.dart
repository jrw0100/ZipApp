import 'dart:async';
import 'dart:convert';
import 'package:zip/business/drivers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:zip/business/payment.dart';
import 'package:zip/business/user.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:zip/models/driver.dart';

class DriverHistoryScreen extends StatefulWidget {
  // final Payment payment;
  @override
  _DriverHistoryScreenState createState() => new _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  PaymentMethod _paymentMethod;
  String _error;
  PaymentIntentResult _paymentIntent;

  ScrollController _controller = ScrollController();
  var customerData = new Map();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final DriverService driverService = DriverService();
  final paymentService = Payment();
  final firebaseUser = auth.FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference rideReference;
  UserService userService = UserService();

  //var paymentMethodList;
  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_Cn8XIP0a25tKPaf80s04Lo1m00dQhI8R0u"));
    //   paymentMethodList = [];
    paymentService.getPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          'History',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tripQuery(),
        builder: (context, snapshot) {
          /* Timer(Duration(seconds: 2), () {
                  print("Yeah, this line is printed after 2 seconds");
                });*/
          try {
            if (snapshot.hasData) {
              debugPrint("build widget: ${snapshot.data}");
              List<QueryDocumentSnapshot> rideList = snapshot.data.docs;
              List<QueryDocumentSnapshot> successfulrideList = new List();
              print("TEST: test; $rideList");
              print("TEST: TSTET: ${rideList[1].id}");
              rideList.forEach((element) {
                if (element["status"] == "succeeded") {
                  print("TESTtestetste: ${element.data()}");
                  successfulrideList.add(element);
                  print("OK2: ${successfulrideList.length}");
                  print("OK3: ${rideList.length}");
                }
              });
              print("OK: ${successfulrideList.length}");
              return ListView.builder(
                  itemCount: successfulrideList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                        ],
                      ),
                    );
                  });
            } else {
              // We can show the loading view until the data comes back.
              debugPrint('TEST: TEROERERbuild loading widget');
              //print("No previous trips ");
                return Center(child: Text("No trips Driven"));

            }
          } catch (error) {
            //print("ERROR: afsdfas $error");
            //return ("No previous trips Found");
            return text(context);
          }
        },
      ),
    );
  }



   tripQuery() {
    Driver driver;
    //Get the collection of requests made for the driver
    rideReference = _firestore
        .collection('drivers')
        .doc(userService.userID) //uid keeps getting set to null
        .collection('requests')
        .doc(userService.userID);

    rideReference.get();

  }



  Widget text(BuildContext context) {
    //print ("No previous trips found");
    return Center(child: Text("No trips Driven"));

  }

  Widget text2(BuildContext context) {
    //print ("No previous trips found");
    return Center(child: Text("Yay Its being called"));

  }
  // _showRefundAlreadyInProgress() async {
  //   return showCupertinoDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CupertinoAlertDialog(
  //           title: Text(
  //               "Your Refund Request has already been received! An email will be sent to ${firebaseUser.email} once approved!"),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: Text("Ok"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  // Future<void> _showRefundAlertDialog(docID) async {
  //   return showCupertinoDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: Text("Request Refund?"),
  //         content: Text("Are you sure?"),
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             child: Text("Yes"),
  //             onPressed: () async {
  //               try {
  //                 Navigator.of(context).pop();
  //                 //buildShowDialog(context);
  //                 await paymentService.sendRefundRequest(docID);
  //                 //Navigator.of(context).pop();
  //                 showDialog(
  //                   context: context,
  //                   barrierDismissible: true,
  //                   builder: (BuildContext context) {
  //                     return CupertinoAlertDialog(
  //                       title: Text('Your refund request has been received'),
  //                       actions: <Widget>[
  //                         CupertinoDialogAction(
  //                           child: Text('Ok'),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             //Navigator.of(context).pop();
  //                           },
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 );
  //               } catch (error) {
  //                 showDialog(
  //                   context: context,
  //                   barrierDismissible: true,
  //                   builder: (BuildContext context) {
  //                     return CupertinoAlertDialog(
  //                       title: Text('Error Occured'),
  //                       actions: <Widget>[
  //                         CupertinoDialogAction(
  //                           child: Text('Ok'),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             Navigator.of(context).pop();
  //                           },
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //           // CupertinoDialogAction(
  //           //   child: Text("No",
  //           //       style: TextStyle(
  //           //         fontWeight: FontWeight.bold,
  //           //         color: Colors.black,
  //           //         //backgroundColor: Colors.black,
  //           //       )),
  //           //   onPressed: () {
  //           //     Navigator.of(context).pop();
  //           //   },
  //           // )
  //         ],
  //       );
  //     },
  //   );
  // }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}