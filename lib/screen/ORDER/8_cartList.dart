import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderapp/components/common_popup.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/db_helper.dart';
import 'package:orderapp/screen/ORDER/5_dashboard.dart';
import 'package:orderapp/screen/ORDER/6_orderForm.dart';
import 'package:orderapp/screen/ORDER/7_itemSelection.dart';
import 'package:orderapp/service/tableList.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartList extends StatefulWidget {
  String custmerId;
  String os;
  String areaId;
  String areaname;
  String type;

  CartList({
    required this.areaId,
    required this.custmerId,
    required this.os,
    required this.areaname,
    required this.type,
  });
  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<String> s = [];
  String? gen_condition;
  CommonPopup orderpopup = CommonPopup();
  TextEditingController rateController = TextEditingController();
  DateTime now = DateTime.now();
  String? date;
  String? sid;
  int counter = 0;
  bool isAdded = false;
  String? sname;
  @override
  void initState() {
    date = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    s = date!.split(" ");
    Provider.of<Controller>(context, listen: false).getOrderno();
    super.initState();
    Provider.of<Controller>(context, listen: false)
        .generateTextEditingController("sale order");
    Provider.of<Controller>(context, listen: false)
        .calculateorderTotal(widget.os, widget.custmerId);
    Provider.of<Controller>(context, listen: false).setSname();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Opacity(
      opacity: 1.0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: P_Settings.wavecolor,
          actions: [
            IconButton(
                onPressed: () async {
                  await OrderAppDB.instance
                      .deleteFromTableCommonQuery("orderBagTable", "");
                },
                icon: Icon(Icons.delete)),
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
        body: GestureDetector(onTap: (() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }), child: Center(
          child: Consumer<Controller>(builder: (context, value, child) {
            if (value.isLoading) {
              return CircularProgressIndicator();
            } else {
              print("value.rateEdit----${value.rateEdit}");
              return Provider.of<Controller>(context, listen: false)
                          .bagList
                          .length ==
                      0
                  ? Container(
                      height: size.height * 0.9,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "asset/empty.png",
                              height: 80,
                              color: P_Settings.wavecolor,
                              width: 100,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              "Your cart is empty !!!",
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: P_Settings.wavecolor,
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("View products"))
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.bagList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listItemFunction(
                                  value.bagList[index]["cartrowno"],
                                  value.bagList[index]["itemName"],
                                  value.rateEdit[index]
                                      ? value.editedRate
                                      : value.bagList[index]["rate"],
                                  value.bagList[index]["totalamount"],
                                  value.bagList[index]["qty"],
                                  size,
                                  value.controller[index],
                                  index,
                                  value.bagList[index]["code"]);
                            },
                          ),
                        ),
                        Container(
                          height: size.height * 0.07,
                          color: Colors.yellow,
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.5,
                                height: size.height * 0.07,
                                color: Colors.yellow,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(" Order Total  : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Flexible(
                                      child: Text(
                                          "\u{20B9}${value.orderTotal1}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (() async {
                                  // value.areDetails.clear();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        orderpopup.buildPopupDialog(
                                            "sale order",
                                            context,
                                            "Confirm your order?",
                                            widget.areaId,
                                            widget.areaname,
                                            widget.custmerId,
                                            s[0],
                                            s[1],
                                            "",
                                            ""),
                                  );

                                  Provider.of<Controller>(context,
                                          listen: false)
                                      .count = "0";
                                  print("area name ${widget.areaname}");
                                  // Provider.of<Controller>(context,listen: false).saveOrderDetails(id, value.cid!, series, orderid,  widget.custmerId, orderdate, staffid, widget.areaId, pcode, qty, rate, context)
                                }),
                                child: Container(
                                  width: size.width * 0.5,
                                  height: size.height * 0.07,
                                  color: P_Settings.roundedButtonColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Place Order",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Icon(Icons.shopping_basket)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
            }
          }),
        )),
      ),
    );
  }

  Widget listItemFunction(
      int cartrowno,
      String itemName,
      String rate,
      String totalamount,
      int qty,
      Size size,
      TextEditingController _controller,
      int index,
      String code) {
    // print("qty-------$qty");
    _controller.text = qty.toString();

    return Container(
      height: size.height * 0.17,
      child: Padding(
        padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
        child: Ink(
          // color: Colors.grey[100],
          decoration: BoxDecoration(
            color: Colors.grey[100],
            // borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            onTap: () {
              Provider.of<Controller>(context, listen: false).setQty(qty);
              Provider.of<Controller>(context, listen: false)
                  .setAmt(totalamount);
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Consumer<Controller>(
                    builder: (context, value, child) {
                      return Container(
                        height: size.height * 0.4,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton.small(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.remove),
                                        onPressed: () {
                                          if (value.qtyinc! > 1) {
                                            value.qtyDecrement();
                                            value.totalCalculation(rate);
                                          }
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15),
                                      child: Text(
                                        value.qtyinc.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    FloatingActionButton.small(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.add),
                                        onPressed: () {
                                          value.qtyIncrement();
                                          value.totalCalculation(rate);
                                        }),
                                  ],
                                ),
                                Provider.of<Controller>(context, listen: false)
                                            .settingsList[0]["set_value"] ==
                                        "YES"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rate :",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            Container(
                                              width: size.width * 0.2,
                                              child: TextField(
                                                controller: rateController,
                                              ),
                                            )
                                            // Flexible(
                                            //   child: Text(
                                            //     "\u{20B9}${double.parse(totalamount).toStringAsFixed(2)}",
                                            //     style: TextStyle(
                                            //         fontSize:
                                            //             17),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Price :",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "\u{20B9}${double.parse(totalamount).toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height * 0.05,
                                        width: size.width * 0.6,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .editRate(rateController.text,
                                                      index);
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .updateQty(
                                                      value.qtyinc.toString(),
                                                      cartrowno,
                                                      widget.custmerId,
                                                      rateController.text);

                                              // Provider.of<Controller>(context, listen: false).updateQty(
                                              //     value.qtyinc.toString(),
                                              //     cartrowno,
                                              //     widget.custmerId,
                                              //     rate);
                                              Provider.of<Controller>(context,
                                                      listen: false)
                                                  .calculateorderTotal(
                                                      widget.os,
                                                      widget.custmerId);
                                              Navigator.pop(context);
                                            },
                                            child: Text("continue..")),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            title: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Container(
                          height: size.height * 0.3,
                          width: size.width * 0.2,
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                            fit: BoxFit.cover,
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                        height: size.height * 0.001,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    "${itemName} ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: P_Settings.wavecolor),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    " (${code})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Rate :",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      "\u{20B9}${double.parse(rate).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.3,
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              content: Text("delete?"),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: P_Settings
                                                                  .wavecolor),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Text("cancel"),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.01,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: P_Settings
                                                                  .wavecolor),
                                                      onPressed: () async {
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .deleteFromOrderBagTable(
                                                                cartrowno,
                                                                widget
                                                                    .custmerId,
                                                                index);
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .getProductList(
                                                                widget
                                                                    .custmerId);
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .calculateorderTotal(
                                                                widget.os,
                                                                widget
                                                                    .custmerId);
                                                        Provider.of<Controller>(
                                                                context,
                                                                listen: false)
                                                            .countFromTable(
                                                          "orderBagTable",
                                                          widget.os,
                                                          widget.custmerId,
                                                        );
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Text("ok"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          size: 17,
                                        ),
                                        color: P_Settings.extracolor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Qty :",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Container(child: Text(qty.toString())),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 182, 179, 179),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total price : ",
                        style: TextStyle(fontSize: 13),
                      ),
                      Flexible(
                        child: Text(
                          "\u{20B9}${double.parse(totalamount).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: P_Settings.extracolor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  popup(String item, String rate, Size size, int index, int qty) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            // title: const Text('Popup example'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    Text("Old rate    :"),
                    Text("   \u{20B9}${rate}"),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    Text("New rate  :"),
                    Container(
                        width: size.width * 0.2,
                        child: TextField(
                          controller: rateController,
                        ))
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<Controller>(context, listen: false)
                          .editRate(rateController.text, index);
                      Provider.of<Controller>(context, listen: false).updateQty(
                          qty.toString(),
                          index + 1,
                          widget.custmerId,
                          rateController.text);
                      Provider.of<Controller>(context, listen: false)
                          .calculateorderTotal(widget.os, widget.custmerId);
                      rateController.clear();
                      Navigator.of(context).pop();
                    },
                    // textColor: Theme.of(context).primaryColor,
                    child: Text('Save'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
