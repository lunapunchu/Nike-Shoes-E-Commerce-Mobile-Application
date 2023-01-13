import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike/state/search.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class cart_page extends StatefulWidget {
  const cart_page({Key? key}) : super(key: key);

  @override
  State<cart_page> createState() => _cart_pageState();
}

class _cart_pageState extends State<cart_page> {
  deleteData(var key) async {
    await FirebaseFirestore.instance.collection("list").doc(key).delete();
  }

  int totalCartValue = 0;

  getCartTotal() async {
    await FirebaseFirestore.instance
        .collection('list')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          totalCartValue += int.parse(doc['Price']);
        });
      });
    });
    return totalCartValue.toString();
  }

  deleteAll() async {
    var collection = FirebaseFirestore.instance.collection('list');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  @override
  initState() {
    super.initState();
    getCartTotal();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("list").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        int listLength = snapshot.data!.docs.length;
        if (listLength == 0) {
          return Container(
            child: Center(
              child: Text(
                'Add product to your cart',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1c0a45),
                ),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot object = snapshot.data!.docs[index];

                      return Card(
                        child: ListTile(
                          leading: Image(
                            image: AssetImage('images/${object["Img"]}.png'),
                          ),
                          title: Text(
                            object["Img"],
                            style: TextStyle(
                              color: Color(0xFF1c0a45),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${object["Price"]} ฿',
                            style: TextStyle(
                              color: Color(0xFF726c7f),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              totalCartValue =
                                  totalCartValue - int.parse(object["Price"]);
                              deleteData(snapshot.data!.docs[index].id);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return search();
                                  }));
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.07),
                        offset: Offset(0, -3),
                        blurRadius: 12),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "${totalCartValue} ฿",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              width: 80.0,
                              height: 36.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Confirm Payment",
                                    desc: "Insist on payment ${totalCartValue} ฿",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: (){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          deleteAll();
                                          Alert(
                                            context: context,
                                            type: AlertType.success,
                                            title: "Your payment was successful",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: (){
                                                  Navigator.of(context, rootNavigator: true).pop();
                                                },
                                                width: 120,
                                              )
                                            ],
                                          ).show();
                                        },
                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                      ),
                                      DialogButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(116, 116, 191, 1.0),
                                          Color.fromRGBO(52, 138, 199, 1.0)
                                        ]),
                                      )
                                    ],
                                  ).show();
                                },
                                child: Text(
                                  "Buy",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(25),
                                    ),
                                    primary: Color(0xFF1f2729)),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        SizedBox(width: 5.0),
                      ],
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
