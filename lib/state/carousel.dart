import 'package:flutter/material.dart';
import 'package:nike/state/shoe.dart';

class carousel extends StatelessWidget {
  String img;
  String price;
  int color1;
  int color2;

  carousel(this.img, this.price, this.color1, this.color2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(color1),
            Color(color2),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
              height: 100,
              child: Image(
                image: AssetImage('images/${img}.png'),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                img,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "${price} ฿",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: SizedBox(
                height: 25,
                width: 75,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15),
                      ),
                      primary: Colors.white,
                    ),
                    child: Text(
                      "See Now",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1f2729),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return shoe(img,price);
                      }));
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
