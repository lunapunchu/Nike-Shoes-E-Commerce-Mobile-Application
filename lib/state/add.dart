import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../main.dart';
import '../model/product.dart';

class add extends StatelessWidget {
  const add({Key? key}) : super(key: key);

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
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 100,
                child: Image(
                  image: AssetImage('images/logo3.png'),
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Text(
                "Add New Products",
                style: TextStyle(
                  fontSize: 27,
                  color: Color(0xFF1c0a45),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            formAdd(),
          ],
        ),
      ),
    );
  }
}

class formAdd extends StatefulWidget {
  const formAdd({Key? key}) : super(key: key);

  @override
  State<formAdd> createState() => _formAddState();
}

class _formAddState extends State<formAdd> {
  final formKey = GlobalKey<FormState>();
  product myProduct = product(image: '', price: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _productCollection = FirebaseFirestore.instance.collection("New");

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
                    Text("Products", style: TextStyle(fontSize: 18)),
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
                        hintText: "Enter your Products",
                        prefixIcon: Icon(Icons.roller_skating),
                      ),
                      validator: RequiredValidator(
                          errorText: "Please enter products."),
                      onSaved: (String? image) {
                        myProduct.image = image!;
                      },
                    ),
                    SizedBox(height: 20),
                    Text("Price", style: TextStyle(fontSize: 18)),
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
                        hintText: "Enter Price your Products",
                        prefixIcon: Icon(Icons.local_offer),
                      ),
                      validator:
                      RequiredValidator(errorText: "Please enter price."),
                      onSaved: (String? price) {
                        myProduct.price = price!;
                      },
                      keyboardType: TextInputType.number,
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
                            "Add",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              await _productCollection.add({
                                "Img": myProduct.image,
                                "Price": myProduct.price,
                              });
                              formKey.currentState?.reset();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
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
      },
    );
  }
}

