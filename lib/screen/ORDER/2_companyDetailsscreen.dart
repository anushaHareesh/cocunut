import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/components/customSnackbar.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/screen/ADMIN_/adminController.dart';

import 'package:orderapp/screen/ORDER/3_staffLoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDetails extends StatefulWidget {
  String? type;
  CompanyDetails({this.type});
  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  String? cid;
  String? firstMenu;

  CustomSnackbar _snackbar = CustomSnackbar();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCid();
    // Provider.of<Controller>(context, listen: false).getCompanyData(cid!);
  }

  getCid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("cid");

    Provider.of<AdminController>(context, listen: false)
        .getCategoryReport(cid!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: P_Settings.detailscolor,
      appBar: widget.type == ""
          ? AppBar(
              backgroundColor: P_Settings.wavecolor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(6.0),
                child: Center(
                    child: Text(
                  " ",
                  style: TextStyle(color: Colors.white, fontSize: 19),
                )),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Company Details",
                  style: TextStyle(
                      fontSize: 20,
                      color: P_Settings.headingColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<Controller>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Container(
                        height: size.height * 0.9,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (value.companyList.length > 0) {
                        return FittedBox(
                          child: Container(
                            height: size.height * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.04,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                        "company name : ${(value.companyList[0]["cnme"] == null) && (value.companyList[0]["cnme"].isEmpty) ? "" : value.companyList[0]["cnme"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.book),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "Address1           : ${value.companyList[0]['ad1']}",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.book),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "Address2            : ${value.companyList[0]['ad2']}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.pin),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "PinCode              : ",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "CompanyPrefix  : ${value.companyList[0]["cpre"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.landscape),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "Land                    : ${value.companyList[0]["land"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "Mobile                 : ${value.companyList[0]["mob"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.design_services),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "GST                      : ${value.companyList[0]["gst"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.copy_rounded),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "Country Code     : ${value.companyList[0]["ccode"]}",
                                      // value.reportList![index]['filter_names'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.04,
                                ),
                                widget.type == "drawer call"
                                    ? Container()
                                    : Text(
                                        "Company Registration Successfull",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                widget.type == "drawer call"
                                    ? Container()
                                    : ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? userType =
                                              prefs.getString("userType");
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .fetchMenusFromMenuTable();
                                          firstMenu =
                                              prefs.getString("firstMenu");
                                          if (firstMenu != null) {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .menu_index = firstMenu;

                                            print(Provider.of<Controller>(
                                                    context,
                                                    listen: false)
                                                .menu_index);
                                          }
                                          String cid = Provider.of<Controller>(
                                                  context,
                                                  listen: false)
                                              .cid!;

                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getAreaDetails(cid);
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .cid = cid;
                                          print("cid-----${cid}");

                                          // prefs.setString("cid", cid);
                                          prefs.setString(
                                              "cname", value.cname!);
                                          // Provider.of<Controller>(context,
                                          //         listen: false)
                                          //     .setCname();

                                          if (userType == "staff") {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getStaffDetails(cid);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffLogin()),
                                            );
                                          } else if (userType == "admin") {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getUserType();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffLogin()),
                                            );
                                          }

                                          // _snackbar.showSnackbar(context,"Staff Details Saved");
                                        },
                                        child: Text("Continue"),
                                      ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: Text(""),
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}