import 'package:chat_application/SignUp.dart';
import 'package:chat_application/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class SignIn extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignIn> {
  String user;
  String pass;

  final _formKey = GlobalKey<FormState>();

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
                height: height * 30 / 100,
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
                          size: width / 3,
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
                  height: height * 60 / 100,
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
                            "Log In",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xff0059b3),
                              fontWeight: FontWeight.bold,
                              fontSize: width / 10,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: width*10/100,right: width*10/100,top: height*2/100,bottom: height*5/100),
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
                                obscureText:true,
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

                              margin: EdgeInsets.only(top: height*10/100),
                              child: FlatButton(
                                color:Color(0xff0059b3) ,
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                child: Container(padding:EdgeInsets.all(5),child:Text("sign in",style: TextStyle(fontSize: width*8/100,color:Colors.white ),)),
                                onPressed: ()async{
                                  if(_formKey.currentState.validate()){
                                    print("signed in");
                                    _formKey.currentState.save();
                                    try{
                                      UserCredential auth=await FirebaseAuth.instance.signInWithEmailAndPassword(email: this.user, password: this.pass);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => chatPage(this.user)));
                                      print(user);
                                    }catch(error){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                child: Text("email or password is wrong"),
                                              ),
                                            );
                                          });

                                    }



                                  }
                                },


                          ),
                            )
                          ,
                          Container(

                            child: FlatButton(
                             // color:Color(0xff0059b3) ,
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              child: Container(padding:EdgeInsets.all(5),child:Text("create account",style: TextStyle(fontSize: width*4/100,color:Colors.blue ),)),
                              onPressed: ()async{

                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignUp()));

                              },


                            ),
                          )
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
