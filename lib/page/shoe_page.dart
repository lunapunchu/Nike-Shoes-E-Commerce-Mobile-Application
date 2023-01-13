import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../state/shoe.dart';

class shoe_page extends StatefulWidget {
  const shoe_page({Key? key}) : super(key: key);

  @override
  State<shoe_page> createState() => _shoe_pageState();
}

class _shoe_pageState extends State<shoe_page> {
  List<String> category = ["New","Discount", "Male", "Female", "Runner","Football"];
  List<String> category2 = ["New","discount", "male", "female", "runner","football"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 115),
        Padding(
          padding: const EdgeInsets.only(left: 19),
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 25),
        SizedBox(
          height: 25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            itemBuilder: (context, index) => buildCategory(index),
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29.5),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("${category2[selectedIndex]}")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        padding: EdgeInsets.only(top: 20.0),
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFb5d5ca),
                                    Color(0xFF569685),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return shoe(document["Img"],document["Price"]);
                                  }));
                                },
                                child: Image(
                                  image: AssetImage('images/${document["Img"]}.png'),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                              child: Text(
                                document["Img"],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${document["Price"]} ฿",
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      }
                    );
                  })),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? Colors.black : Colors.black45,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
