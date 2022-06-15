import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/db_helper.dart';
import 'package:orderapp/screen/6_reportPage.dart';
import 'package:orderapp/screen/ORDER/2_companyDetailsscreen.dart';
import 'package:orderapp/screen/ORDER/3_staffLoginScreen.dart';
import 'package:orderapp/screen/ORDER/5_mainDashboard.dart';
import 'package:orderapp/screen/ORDER/6_customer_creation.dart';
import 'package:orderapp/screen/ORDER/6_downloadedPage.dart';
import 'package:orderapp/screen/ORDER/6_historypage.dart';
import 'package:orderapp/screen/ORDER/6_uploaddata.dart';
import 'package:orderapp/screen/ORDER/6_settings.dart';
import 'package:orderapp/screen/ORDER/todayCollection.dart';
import 'package:orderapp/screen/ORDER/todaySale.dart';
import 'package:orderapp/screen/ORDER/todaysOrder.dart';
import 'package:orderapp/service/tableList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '6_orderForm.dart';

class Dashboard extends StatefulWidget {
  String? type;

  String? areaName;
  Dashboard({this.type, this.areaName});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController? _tabController;
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Home ',
    ),
    Tab(text: 'Todays Order'),
    Tab(text: 'Todays Collection'),
    Tab(text: 'Todays Sale'),
    Tab(text: 'CList'),
  ];
  List<Widget> drawerOpts = [];

  ValueNotifier<bool> upselected = ValueNotifier(false);
  ValueNotifier<bool> dwnselected = ValueNotifier(false);
  String title = "";
  String? cid;
  String? sid;
  String? os;

  String menu_index = "S1";
  List defaultitems = ["upload data", "download page", "logout"];
  DateTime date = DateTime.now();
  String? formattedDate;
  String? selected;
  List<String> s = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int _selectedIndex = 0;

  _onSelectItem(int index, String? menu) {
    if (!mounted) return;
    if (this.mounted) {
      setState(() {
        _selectedIndex = index;
        menu_index = menu!;
      });
    }
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    // Provider.of<Controller>(context, listen: false).postRegistration("RONPBQ9AD5D",context);
    // TODO: implement initState
    super.initState();
    print("haiiiiii");
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    s = formattedDate!.split(" ");

    Provider.of<Controller>(context, listen: false).fetchMenusFromMenuTable();
    Provider.of<Controller>(context, listen: false).setCname();
    Provider.of<Controller>(context, listen: false).setSname();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
      // initialIndex: 0,
    );

    _tabController!.addListener(() {
      if (!mounted) return;
      if (mounted) {
        setState(() {
          _selectedIndex = _tabController!.index;
          menu_index = _tabController!.index.toString();
        });
      }
      print("Selected Index: " + _tabController!.index.toString());
    });
    getCompaniId();
    // if (Provider.of<Controller>(context, listen: false).firstMenu != null) {
    //   menu_index = Provider.of<Controller>(context, listen: false).firstMenu!;
    // }
  }

  insertSettings() async {
    await OrderAppDB.instance.deleteFromTableCommonQuery("settings", "");
    await OrderAppDB.instance.insertsettingsTable("rate Edit", 0);
  }

  getCompaniId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("cid");
    os = prefs.getString("os");
    sid = prefs.getString("sid");

    print("formattedDate...$formattedDate");
    Provider.of<Controller>(context, listen: false).getArea(sid!);
    print("cid--sid--$cid--$sid");
  }

  _getDrawerItemWidget(String pos) {
    print("pos---${pos}");
    switch (pos) {
      case "S1":
        {
          _tabController!.animateTo((0));
          // _tabController!.index = 0;
          print("djs");
          return new MainDashboard();
        }

      case "S2":
        if (widget.type == "return from cartList") {
          return OrderForm(widget.areaName!, "sales");
        } else {
          return OrderForm("", "sales");
        }
      case "S3":
        return OrderForm("", "return");

      case "SAC1":
        return null;

      case "S4":
        return null;

      case "S5":
        return null;

      case "SA1":
        return CustomerCreation(
          sid: sid!,
          os: os,
        );

      case "SA2":
        return null;
      case "SA3":
        // print("yy-- ${Provider.of<Controller>(context, listen: false).areaSelecton!}");
        return OrderForm("", "collection");

      case "UL":
        // title = "Upload data";
        return Uploaddata(
          title: "Upload data",
          cid: cid!,
          type: "drawer call",
        );
      case "DP":
        // title = "Download data";
        return DownloadedPage(
          title: "Download Page",
          type: "drawer call",
        );
      case "CD":
        // title = "Download data";
        return CompanyDetails(
          type: "drawer call",
        );
      case "HR":
        // title = "Download data";
        return History(
            // type: "drawer call",
            );
      case "0":
        return new MainDashboard();
      case "1":
        return new TodaysOrder();
      case "2":
        return new TodayCollection();
      case "3":
        return new TodaySale();
      case "4":
        Provider.of<Controller>(context, listen: false).setFilter(false);
        Provider.of<Controller>(context, listen: false)
            .selectReportFromOrder(context);
        // Navigator.pop(context);
        return ReportPage();
      // case "RP":
      //   Provider.of<Controller>(context, listen: false).setFilter(false);
      //   Provider.of<Controller>(context, listen: false)
      //       .selectReportFromOrder(context);
      //   return ReportPage();

      case "ST":
        // title = "Download data";
        return Settings();
      // case "TO":
      //   // title = "Upload data";
      //   return TodaysOrder();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // Provider.of<Controller>(context, listen: false).fetchMenusFromMenuTable();

    if (widget.type == "return from cartList") {
      menu_index = "S2";
    }
    print("dididdd");

    // print("_seletdde---$_selectedIndex");
  }

  // @override
  // void dispose() {
  //   _tabController!.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // print("${Provider.of<Controller>(context, listen: false).menuList.length}");
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
          key: _key, //
          backgroundColor: P_Settings.wavecolor,
          appBar: menu_index == "UL" || menu_index == "DP"
              ? AppBar(
                  elevation: 0,
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(6.0),
                    child: Consumer<Controller>(
                      builder: (context, value, child) {
                        if (value.isLoading) {
                          return LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            color: P_Settings.wavecolor,

                            // valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                            // value: 0.25,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  // title: Text("Company Details",style: TextStyle(fontSize: 20),),
                )
              : AppBar(
                  backgroundColor: Colors.white,

                  bottom: menu_index == "S1" ||
                          menu_index == "1" ||
                          menu_index == "2" ||
                          menu_index == "3" ||
                          menu_index == "4" ||
                          menu_index == "0"
                      ? TabBar(
                          isScrollable: true,
                          // indicator: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(50),
                          //     color: Colors.grey),
                          indicatorColor: P_Settings.wavecolor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.0,
                          // indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Color.fromARGB(255, 58, 54, 54),
                          tabs: myTabs,
                          controller: _tabController,
                        )
                      : null,
                  leading: Builder(
                    builder: (context) => IconButton(
                        icon: new Icon(
                          Icons.menu,
                          color: Color.fromARGB(255, 58, 54, 54),
                        ),
                        onPressed: () {
                          Provider.of<Controller>(context, listen: false)
                              .getCompanyData();
                          drawerOpts.clear();
                          print("clicked");
                          // companyAttributes.clear();
                          for (var i = 0;
                              i <
                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .menuList
                                      .length;
                              i++) {
                            // var d =Provider.of<Controller>(context, listen: false).drawerItems[i];
                            setState(() {
                              drawerOpts.add(Consumer<Controller>(
                                builder: (context, value, child) {
                                  return ListTile(
                                    title: Text(
                                      value.menuList[i]["menu_name"]
                                          .toLowerCase(),
                                      style: TextStyle(
                                          fontFamily: P_Font.kronaOne,
                                          fontSize: 17),
                                    ),
                                    // selected: i == _selectedIndex,
                                    onTap: () {
                                      _onSelectItem(
                                        i,
                                        value.menuList[i]["menu_index"],
                                      );
                                    },
                                  );
                                },
                              ));
                            });
                          }
                          // Provider.of<Controller>(context, listen: false).fetchMenusFromMenuTable();
                          Scaffold.of(context).openDrawer();
                        }),
                  ),
                  elevation: 0,
                  // backgroundColor: P_Settings.wavecolor,
                  actions: [
                    IconButton(
                      onPressed: () async {
                        List<Map<String, dynamic>> list =
                            await OrderAppDB.instance.getListOfTables();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TableList(list: list)),
                        );
                      },
                      icon: Icon(Icons.table_bar),
                    ),
                  ],
                ),

          drawer: Drawer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.045,
                      ),
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 1,
                        color: P_Settings.wavecolor,
                        child: Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.07,
                              width: size.width * 0.03,
                            ),
                            Icon(
                              Icons.list_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.04),
                            Text(
                              "Menus",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Column(children: drawerOpts),
                      Divider(
                        color: Colors.black,
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        onTap: () async {
                          _onSelectItem(0, "CD");
                        },
                        title: Text(
                          "Company Details",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      // ListTile(
                      //   trailing: Icon(Icons.logout),
                      //   onTap: () async {
                      //     _onSelectItem(0, "TO");
                      //   },
                      //   title: Text(
                      //     "Todays Order",
                      //     style: TextStyle(fontSize: 17),
                      //   ),
                      // ),
                      ListTile(
                        trailing: Icon(Icons.arrow_downward),
                        onTap: () async {
                          _onSelectItem(0, "DP");
                        },
                        title: Text(
                          "Download page",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      ListTile(
                        trailing: Icon(Icons.arrow_upward),
                        onTap: () async {
                          _onSelectItem(0, "UL");
                        },
                        title: Text(
                          "Upload data",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      ListTile(
                        trailing: Icon(Icons.settings),
                        onTap: () async {
                          _onSelectItem(0, "ST");
                        },
                        title: Text(
                          "Settings",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      ListTile(
                        trailing: Icon(Icons.logout),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('st_username');
                          await prefs.remove('st_pwd');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StaffLogin()));
                        },
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // body: _getDrawerItemWidget(
          //   menu_index,
          // ),

          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: myTabs.map((Tab tab) {
              final String label = tab.text!.toLowerCase();
              return Center(
                child: Container(
                  child: _getDrawerItemWidget(
                    menu_index,
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to exit from this app'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}