import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/profile.dart';
import '../state/register.dart';

class user_page extends StatelessWidget {
  const user_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return user();
        } else {
          return login();
        }
      },
    );
  }
}

class user extends StatelessWidget {
  final Auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 135),
        Center(
          child: Text(
            "Profile",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF1c0a45),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        userImage(),
        SizedBox(height: 20),
        Text(
          Auth.currentUser!.email.toString(),
        ),
        SizedBox(height: 20),
        profileMenu(
          Icons.person,
          "My Account",
          () {},
        ),
        profileMenu(
          Icons.notifications,
          "Notifications",
          () {},
        ),
        profileMenu(
          Icons.settings,
          "Settings",
          () {},
        ),
        profileMenu(
          Icons.logout,
          "Log Out",
          () {
            Auth.signOut().then((value) {});
          },
        ),
      ],
    );
  }
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          formLogin(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an Account?"),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return register();
                  }));
                },
                child: Text(
                  "Register Now",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class formLogin extends StatefulWidget {
  const formLogin({Key? key}) : super(key: key);

  @override
  State<formLogin> createState() => _formLoginState();
}

class _formLoginState extends State<formLogin> {
  final formKey = GlobalKey<FormState>();
  profile myProfile = profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 110),
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Text("Email", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFe0f1eb),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Enter Email",
                        ),
                        validator: MultiValidator([
                          EmailValidator(errorText: 'Invalid email format'),
                          RequiredValidator(
                              errorText: 'Please enter your email'),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? email) {
                          myProfile.email = email!;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Password", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFe0f1eb),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Enter Password",
                          suffixIcon: Icon(
                            Icons.visibility_off_outlined,
                          ),
                        ),
                        validator: RequiredValidator(
                            errorText: 'Please enter your password'),
                        obscureText: true,
                        onSaved: (String? password) {
                          myProfile.password = password!;
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("Forgot Password",
                            style: TextStyle(fontSize: 14, color: Colors.blue)),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                                value: isCheck,
                                onChanged: (value) {
                                  setState(() => isCheck = value!);
                                }),
                          ),
                          Text("Remember me", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          width: 320,
                          height: 47,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25),
                              ),
                              primary: Color(0xFF1f2729),
                            ),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: myProfile.email,
                                          password: myProfile.password)
                                      .then((value) {
                                    formKey.currentState!.reset();
                                  });
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.message.toString(),
                                    gravity: ToastGravity.TOP,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class userImage extends StatelessWidget {
  const userImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage('images/user.png'),
          ),
          Positioned(
            right: -1,
            bottom: 0,
            child: SizedBox(
              height: 37,
              width: 37,
              child: FlatButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: SizedBox.fromSize(
                  size: Size.fromRadius(8),
                  child: FittedBox(
                    child: Icon(Icons.photo_camera),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class profileMenu extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback press;

  profileMenu(this.icon, this.text, this.press);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
            )),
            Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    );
  }
}
