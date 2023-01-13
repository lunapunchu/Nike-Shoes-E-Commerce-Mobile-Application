import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/profile.dart';

class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Color(0xFF1e1e1e),
                  onPressed: () => {
                    Navigator.pop(context),
                  }),
            ),
            formRegister(),
          ],
        ),
      ),
    );
  }
}

class formRegister extends StatefulWidget {
  const formRegister({Key? key}) : super(key: key);

  @override
  State<formRegister> createState() => _formRegisterState();
}

class _formRegisterState extends State<formRegister> {
  final formKey = GlobalKey<FormState>();
  profile myProfile = profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  TextEditingController Password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

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
              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 70,
                          child: Image(
                            image: AssetImage('images/logo3.png'),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 27,
                            color: Color(0xFF1c0a45),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
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
                          RequiredValidator(errorText: 'Please enter your email'),
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
                        controller: Password,
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
                        validator: (String? value){
                          if(value!.isEmpty){
                            return 'Please confirm your password';
                          }
                          if(value.length < 8){
                            return "Must be more than 8 charater";
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (String? password) {
                          myProfile.password = password!;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Confirm Password", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: confirmpassword,
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
                        obscureText: true,
                        validator: (String? value){
                          if(value!.isEmpty){
                            return 'Please confirm your password';
                          }
                          if(Password.text!=confirmpassword.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 45),
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
                              "Register",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: myProfile.email,
                                    password: myProfile.password,
                                  );
                                  auth.signOut().then((value) {
                                    formKey.currentState?.reset();
                                    Fluttertoast.showToast(
                                      msg: "The user account has been created.",
                                      gravity: ToastGravity.TOP,
                                    );
                                    Navigator.pop(context);
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
