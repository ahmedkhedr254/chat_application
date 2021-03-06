import 'package:chat_application/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class SignUp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  String user;
  String pass;
  String FirstName;
  String LastName;

  final _formKey = GlobalKey<FormState>();
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;




    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffeef2f5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 20 / 100,
                width: width,
                child: Card(
                    margin: EdgeInsets.all(0),
                    color: Color(0xff0059b3),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 15,
                        ),
                        Icon(
                          Icons.account_circle,
                          size: width / 5,
                          color: Colors.white,
                        ),
                      ],
                    )),
              ),
              Container(
                margin:
                EdgeInsets.only(left: width * 4 / 100, top: height * 3 / 100),
                child: SizedBox(
                  width: width * 92 / 100,
                  height: height * 70 / 100,
                  child: Card(
                    margin: EdgeInsets.all(0),

                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 2 / 100,
                          ),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xff0059b3),
                              fontWeight: FontWeight.bold,
                              fontSize: width / 10,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: width*10/100,right: width*10/100,top: height*2/100,),
                            child: TextFormField(
                              onSaved: (val){this.user=val;},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              style: TextStyle(color: Color(0xff0059b3)),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff0059b3)),
                                  ),
                                  hintText: ("username"),
                                  hintStyle: TextStyle(color: Color(0xff0059b3))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width*10/100,right: width*10/100),
                            child: TextFormField(

                                obscureText: true,
                              onSaved: (val){this.pass=val;},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: ("password"),
                                hintStyle: TextStyle(color: Color(0xff0059b3)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff0059b3)),

                                ),
                              ),
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(left: width*10/100,right: width*10/100),
                            child: TextFormField(
                              onSaved: (val){this.FirstName=val;},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: ("First Name"),
                                hintStyle: TextStyle(color: Color(0xff0059b3)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff0059b3)),

                                ),
                              ),
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(left: width*10/100,right: width*10/100),
                            child: TextFormField(
                              onSaved: (val){this.LastName=val;},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: ("Last Name"),
                                hintStyle: TextStyle(color: Color(0xff0059b3)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff0059b3)),

                                ),
                              ),
                            ),
                          ),




                          Container(

                            margin: EdgeInsets.only(top: height*10/100),
                            child: FlatButton(
                              color:Color(0xff0059b3) ,
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              child: Container(padding:EdgeInsets.all(5),child:Text("sign Up",style: TextStyle(fontSize: width*8/100,color:Colors.white ),)),
                              onPressed: ()async{
                                if(_formKey.currentState.validate()){
                                  print("signed in");
                                  _formKey.currentState.save();
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: this.user, password: this.pass);
                                  UserCredential auth=await FirebaseAuth.instance.signInWithEmailAndPassword(email: this.user, password: this.pass);
                                  await FirebaseFirestore.instance
                                      .collection(this.user).doc(this.user)
                                      .set({"type":"userInfo",
                                        "firstName":this.FirstName,"LastName":this.LastName,"email":this.user,"password":this.pass,
                                    "ImgLisk":"https://firebasestorage.googleapis.com/v0/b/chat-e595f.appspot.com/o/chats%2FInitImage?alt=media&token=4775c2ab-cb05-48c7-8cf8-ec84c5521177"
                                  });
                                  print(user);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => chatPage(this.user)));
                                }
                              },


                            ),
                          )
                          ,
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
