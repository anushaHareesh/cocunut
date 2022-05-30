///////////////////////////////////////////
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/components/showMoadal.dart';
import '../controller/controller.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, dynamic>> newJson = [];
  final rows = <DataRow>[];
  String? behv;
  bool isSelected = false;

  List<String>? colName;
  List<Map<String, dynamic>> products = [];
  List<String> behvr = [];
  Map<String, dynamic> mainHeader = {};
  int col = 0;

//////////////////////////////////////////////////////////////////////////////
  onSelectedRow(bool selected, Map<String, dynamic> history) async {
    setState(() {
      if (selected) {
        // print("history----$history");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = Provider.of<Controller>(context, listen: false).productName;
    // Provider.of<Controller>(context, listen: false)
    //     .getProductList(widget.customerId);
    // list.removeAt(0);
    // for (var item in list) {
    //   tableColumn.add(item);
    // }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<Controller>(context, listen: false).getHistory();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // if (col <= 5) {
    //   width / col;
    // }
    return Scaffold(
      // appBar: AppBar(title: Text("Dynamic datatable")),
      body: InteractiveViewer(
        minScale: .4,
        maxScale: 5,
        child: SingleChildScrollView(
          // width: double.infinity,
          scrollDirection: Axis.horizontal,
          child: Consumer<Controller>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(
                  child: SpinKitCircle(
                    color: P_Settings.wavecolor,
                  ),
                );
              } else {
                return DataTable(
                  horizontalMargin: 0,
                  headingRowHeight: 30,
                  dataRowHeight: 35,
                  // dataRowColor:
                  //     MaterialStateColor.resolveWith((states) => Colors.yellow),
                  columnSpacing: 0,
                  showCheckboxColumn: false,

                  border: TableBorder.all(width: 1, color: Colors.black),
                  columns: getColumns(value.tableColumn),
                  rows: getRowss(value.historyList),
                );
              }
            },
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////
  List<DataColumn> getColumns(List<String> columns) {
    // print("columns---${columns}");
    String behv;
    String colsName;
    return columns.map((String column) {
      // double strwidth = double.parse(behv[3]);
      // strwidth = strwidth * 10; //
      return DataColumn(
        label: Container(
          width: 100,
          child: Text(
            column,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            // textAlign: behv[1] == "L" ? TextAlign.left : TextAlign.right,
          ),
          // ),
        ),
      );
    }).toList();
  }

  ////////////////////////////////////////////
  List<DataRow> getRowss(List<Map<String, dynamic>> rows) {
    List<String> newBehavr = [];
    // print("rows---$rows");
    return rows.map((row) {
      return DataRow(
        selected: isSelected,
        onSelectChanged: (value) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              Size size = MediaQuery.of(context).size;
              return Consumer<Controller>(builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Container(
                      height: 500,
                      // color: P_Settings.wavecolor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("All Data"),
                          SizedBox(height: size.height * 0.02),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.historyList.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: ListTile(
                                    trailing: Text(
                                        "${value.historyList[index]["Date"]}"),
                                    leading: Text(
                                        "${value.historyList[index]["Order_Num"]}"),
                                    title: Text(
                                        "${value.historyList[index]["Date"]}"),
                                    onTap: () {},
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          );
          onSelectedRow(value!, row);
        },
        // color: MaterialStateProperty.all(Colors.green),
        cells: getCelle(row),
      );
    }).toList();
  }
/////////////////////////////////////////////

  List<DataCell> getCelle(Map<String, dynamic> data) {
    print("data--$data");
    //  double  sum=0;
    List<DataCell> datacell = [];
    mainHeader.remove('rank');
    // print("main header---$mainHeader");

    data.forEach((key, value) {
      datacell.add(
        DataCell(
          Container(
            //  width:100,
            // width: mainHeader[k][3] == "1" ? 70 : 30,
            alignment: Alignment.center,
            //     ? Alignment.centerLeft
            //     : Alignment.centerRight,
            child: Text(
              value.toString(),
              // textAlign:
              //     mainHeader[k][1] == "L" ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      );
    });

    // print(datacell.length);
    return datacell;
  }
}
