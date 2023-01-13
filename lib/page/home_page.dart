import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nike/state/carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';
import '../state/shoe.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  String phoneNumber = '';
  String Url = 'https://www.facebook.com/';
  String Url2 = 'https://www.youtube.com/';
  String Url3 = 'https://www.twitch.com/';
  String Url4 = 'https://www.linkedin.com/';

  Future<void> _launchIn(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 108),
        Padding(
          padding: const EdgeInsets.only(right: 280),
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 130,
                width: 352,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF1f2729),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 145,
                  child: Image(
                    image: AssetImage('images/Nike Venture Runner 1.png'),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      'Nike Venture Runner',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Best Sellers !",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 27,
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return shoe("Nike Venture Runner", "2300");
                                }));
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Text(
                "Recommended",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: new Text(
                    "See also",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        Container(
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1.65,
              enableInfiniteScroll: true,
              autoPlay: true,
              viewportFraction: 0.55,
            ),
            items: [
              carousel(
                  "Nike Waffle One Leather", "2800", 0xFFcc7991, 0xFF301f6d),
              carousel(
                  "Nike Terminator High OG", "5300", 0xFF8a7fa0, 0xFF433e4c),
              carousel("Nike Free Metcon 4", "4600", 0xFF57ca85, 0xFF184e68),
              carousel("Nike Lebron 9 Low", "7000", 0xFF6ce8fd, 0xFF0d0158),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(right: 230),
          child: Text(
            'Social Media',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 30),
            IconButton(
              onPressed: () {
                _launchIn(Url);
              },
              icon: Icon(
                Icons.facebook,
                color: Colors.blueAccent,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                _launchIn(Url2);
              },
              icon: Icon(
                Icons.play_circle_filled,
                color: Colors.red,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                _launchIn(Url3);
              },
              icon: Icon(
                FontAwesomeIcons.twitter,
                color: Colors.blue,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                _launchIn(Url4);
              },
              icon: Icon(
                FontAwesomeIcons.linkedin,
                color: Color(0xff0a66c2),
                size: 25,
              ),
            ),
            SizedBox(width: 30),
          ],
        ),
      ],
    );
  }
}
