import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../model/product.dart';

class shoe extends StatefulWidget {
  String name;
  String price;

  shoe(this.name, this.price);

  @override
  State<shoe> createState() => _shoeState();
}

class _shoeState extends State<shoe> {
  final formKey = GlobalKey<FormState>();
  product myProduct = product(image: '', price: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _productCollection =
      FirebaseFirestore.instance.collection("list");
  List<int> color = [0xFF958472, 0xFFb27fc2, 0xFF1c4f4a, 0xFF271c24];
  List<String> size = ["7", "7.5", "8", "9"];
  int selectedIndex = 0;
  int selectedIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xFFb5d5ca),
            Color(0xFF569685),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    color: Colors.white,
                    onPressed: () => {
                          Navigator.pop(context),
                        }),
              ),
              SizedBox(
                height: 250,
                child: Image(
                  image: AssetImage('images/${widget.name}.png'),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.price} ฿",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 30,
                ),
                child: Text(
                  "Pay tribute to the iconic shoes of the '80s that started the running shoe revolution,"
                  " featuring a highly flexible bare-stitched top and a small branded heel backband that adds fresh DNA to the classic treadmill look. "
                  "At the same time, the airy mesh and the new comfortable insole elevate the touch.",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  right: 160,
                ),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 28,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 73,
                ),
                child: Row(
                  children: [
                    Text(
                      "Colors",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 25,
                width: 218,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: color.length,
                  itemBuilder: (context, index) => buildColor(index),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 73,
                ),
                child: Row(
                  children: [
                    Text(
                      "Size",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 25,
                width: 218,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: size.length,
                  itemBuilder: (context, index) => buildSize(index),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: SizedBox(
                    width: 320,
                    height: 45,
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ElevatedButton(
                            onPressed: () async {
                              await _productCollection.add({
                                "Img": myProduct.image = widget.name,
                                "Price": myProduct.price =
                                    widget.price.toString(),
                              });
                            },
                            child: Text(
                              "+ Add to Cart",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25),
                              ),
                              primary: Color(0xFF1f2729),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              Alert(
                                context: context,
                                type: AlertType.info,
                                title: "Please Login first",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context,
                                          rootNavigator: true)
                                          .pop();
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show();
                            },
                            child: Text(
                              "+ Add to Cart",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25),
                              ),
                              primary: Color(0xFF1f2729),
                            ),
                          );
                        }
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColor(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor:
                  selectedIndex == index ? Colors.white : Colors.transparent,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Color(color[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSize(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex2 = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    selectedIndex2 == index ? Color(0xFFb5d5ca) : Colors.white,
                    selectedIndex2 == index ? Color(0xFF569685) : Colors.white,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  size[index],
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        selectedIndex2 == index ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
