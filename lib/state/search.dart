import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike/state/shoe.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  List<Map<String, dynamic>> data = [];
  bool check = true;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
             backgroundColor: Color(0xFF1f2729),
            title: Card(
              child: SizedBox(
                height: 40,
                width: 280,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Color(0xFF1f2729),), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      text = val;
                      check = false;
                    });
                    if (text == '') {
                      check = true;
                    };
                  },
                ),
              ),
            )),
        body: check
            ? textSearch()
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("product")
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data!.docs[index].data()
                  as Map<String, dynamic>;
                  if (data['Img']
                      .toString()
                      .toLowerCase()
                      .startsWith(text.toLowerCase())) {
                    return ListTile(
                      title: Text(
                        data['Img'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        "${data['Price']} ฿",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      leading: Image(
                        image:
                        AssetImage('images/${data["Img"]}.png'),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return shoe(
                                  data["Img"],
                                  data['Price']);
                            }));
                      },
                    );
                  }
                  return Container();
                });
          },
        ));
  }
}

class textSearch extends StatelessWidget {
  const textSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'No shoes were found..',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF1c0a45),
          ),
        ),
      ),
    );
  }
}
