import 'package:flutter/material.dart';
import 'package:orderapp/components/commoncolor.dart';
import 'package:orderapp/controller/controller.dart';
import 'package:orderapp/db_helper.dart';
import 'package:orderapp/service/tableList.dart';
import 'package:provider/provider.dart';

class CartList extends StatefulWidget {
  String custmerId;
  CartList({required this.custmerId});
  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  // List<TextEditingController> _controller = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Controller>(context, listen: false)
        .generateTextEditingController();
    // _controller = List.generate(length, (i) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: P_Settings.wavecolor,
        actions: [
          IconButton(
            onPressed: () async {
              List<Map<String, dynamic>> list =
                  await OrderAppDB.instance.getListOfTables();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableList(list: list)),
              );
            },
            icon: Icon(Icons.table_bar),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }),
        child: Column(
          children: [
            Expanded(
              child: Consumer<Controller>(builder: (context, value, child) {
                print("value.baglist.length-----${value.bagList.length}");
                return SafeArea(
                    child: value.isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            itemCount: value.bagList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listItemFunction(
                                  value.bagList[index]["cartrowno"],
                                  value.bagList[index]["itemName"],
                                  value.bagList[index]["rate"],
                                  value.bagList[index]["totalamount"],
                                  value.bagList[index]["qty"],
                                  size,
                                  value.controller[index],
                                  index);
                            },
                          ));
              }),
            ),
            Container(
              height: size.height * 0.07,
              color: Colors.yellow,
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: size.width*0.5,
                      height: size.height * 0.07,
                      color: Colors.yellow,
                      child: Center(child: Text(" Order Total")),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: size.width*0.5,
                      height: size.height * 0.07,
                      color: P_Settings.roundedButtonColor,
                      child: Center(child: Text("Place Order",style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
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
      int index) {
    print("qty-------$qty");
    _controller.text = qty.toString();

    return Container(
      height: size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          // color: Colors.grey[100],
          decoration: BoxDecoration(
            color: Colors.grey[100],
            // borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            // leading: CircleAvatar(backgroundColor: Colors.green),
            title: Column(
              children: [
                // Flexible(
                //   child: Text(
                //     "${itemName}",
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 18,
                //         color: P_Settings.wavecolor),
                //   ),
                // ),
                // SizedBox(
                //   height: size.height * 0.001,
                // ),
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
                      // Text("${id}"),
                      // SizedBox(
                      //   width: size.width * 0.02,
                      // ),
                      // CircleAvatar(
                      //   backgroundColor: Colors.green,
                      //   radius: 40,
                      // ),
                      SizedBox(
                        width: size.width * 0.05,
                        height: size.height * 0.001,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${itemName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: P_Settings.wavecolor),
                            ),
                            SizedBox(
                              height: size.height * 0.006,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rate",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Qty",
                                  style: TextStyle(fontSize: 13),
                                ),
                                // Spacer(),
                                Text(
                                  "Amt",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(
                                //   height: size.height * 0.02,
                                // ),
                                Text(
                                  "\u{20B9}${rate}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                    width: size.width * 0.08,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          // border: InputBorder.none,
                                          ),
                                      onFieldSubmitted: (value) async {
                                        print("helooo");
                                        _controller.text = value;
                                        print("helloo-----${_controller.text}");
                                        // await OrderAppDB.instance.updateQtyOrderBagTable(value, cartrowno,widget.custmerId);
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .updateQty(value, cartrowno,
                                                widget.custmerId, rate);
                                      },
                                      //  onChanged: (value){
                                      //       print(value);
                                      //  },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      keyboardType: TextInputType.number,
                                      controller: _controller,
                                    )),
                                Text(
                                  "\u{20B9}${totalamount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              // title: Text("Alert Dialog Box"),
                              content: Text("delete?"),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: P_Settings.wavecolor),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("cancel"),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: P_Settings.wavecolor),
                                      onPressed: () async {
                                        Provider.of<Controller>(context,
                                                listen: false)
                                            .deleteFromOrderBagTable(cartrowno,
                                                widget.custmerId, index);
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
                          color: P_Settings.extracolor,
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
}
