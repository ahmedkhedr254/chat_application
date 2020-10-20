import 'dart:io';

import 'package:chat_application/SignIn.dart';
import 'package:chat_application/friendChat.dart';
import 'package:chat_application/streams.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

File _image;
String _uploadedFileURL;

class chatPage extends StatefulWidget {
  String myEmail;

  chatPage(String myEmail) {
    this.myEmail = myEmail;
  }

  @override
  State<StatefulWidget> createState() {
    return chatPageState(this.myEmail);
  }
}

class chatPageState extends State<chatPage> {
  String searchFriendState;
  String myEmail;

  chatPageState(String myEmail) {
    this.myEmail = myEmail;
  }

  final searchFriendController = TextEditingController();

  PageController controller = PageController(initialPage: 0);
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  List<String> onlineUsers = [
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed"
  ];
  List<String> chatHistoryList = [
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed",
    "ahmed"
  ];
  String searchFriendEmail;
  Widget openChatButton(String state,email){
    if (state=="friend"){
      return FlatButton(
          color: Color(0xfffa824c),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        friendChat(email,
                            this.myEmail)));
          },
          child: Text("open chat ",
              style: TextStyle(color: Colors.white)));
    }
    else{
      return FlatButton();
    }
  }
  Widget StatusButton(double width, double height,String status,newFirend) {
    if (status=="freind request sent"){
      return FlatButton(child: Text("request sent"),);
    }
    if (status=="friend"){
      return FlatButton(child: Text("friend"),);
    }
    else if (status=="request"){
      return FlatButton(child: Text("accept request"),onPressed: ()async{
        await FirebaseFirestore.instance
            .collection(this.myEmail)
            .doc(newFirend)
            .update({

          "state": "friend",

        });

        await FirebaseFirestore.instance
            .collection(newFirend)
            .doc(this.myEmail)
            .update({

          "state": "friend",
        });
        setState(() {
          this.searchFriendState="friend";
        });

      },);


    }
    else {
      return FlatButton.icon (
        icon: Icon(Icons.add,color: Colors.white),
        label: Text("add",style: TextStyle(color: Colors.white),),
        color: Colors.blue,
        onPressed: ()async {
        String newFirend = searchFriendEmail;
        await FirebaseFirestore.instance
            .collection(this.myEmail)
            .doc(newFirend)
            .set({
          "type": "friendsList",
          "friendEmail": newFirend,
          "lastMessage": "",
          "state": "freind request sent",
          "hasMessage": "false"
        });

        await FirebaseFirestore.instance
            .collection(newFirend)
            .doc(this.myEmail)
            .set({
          "type": "friendsList",
          "friendEmail": this.myEmail,
          "lastMessage": "",
          "state": "request",
          "hasMessage": "false"
        });
        setState(() {
          this.searchFriendState="freind request sent";
        });
      },);
    }

  }
  Widget profile(double width, double height) {
    return Column(
      children: [
        SizedBox(
          height: height * 8 / 100,
        ),
        Container(
          height: height * 40 / 100,
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: height * 5 / 100,
              ),
              MyStream().ImageStream(this.myEmail, height * 10 / 100),
              SizedBox(
                height: height * 2 / 100,
              ),
              SizedBox(
                width: width * 20 / 100,
                height: height * 6 / 100,
                child: FlatButton(
                  color: Color(0xffffc107),
                  child: Text("upload"),
                  onPressed: () async {
                    await chooseFile();
                    String link = await uploadFile(this.myEmail);
                    await FirebaseFirestore.instance
                        .collection(this.myEmail)
                        .doc(this.myEmail)
                        .update({"ImgLisk": link.toString()});
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: height * 50 / 100,
          width: width * 60 / 100,
          child: Card(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: height * 5 / 100,
                ),
                SizedBox(
                    width: width * 40 / 100,
                    height: height * 8 / 100,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "   Name:   ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          MyStream().myNameStream(this.myEmail, TextStyle())
                        ],
                      ),
                    )),
                SizedBox(
                  height: height * 2 / 100,
                ),
                SizedBox(
                    width: width * 40 / 100,
                    height: height * 8 / 100,
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "   Name:   ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(this.myEmail)
                        ],
                      ),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget MyFriendsList(Query FreindListquery, double width, double height) {
    return StreamBuilder<QuerySnapshot>(
        stream: FreindListquery.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;
          return Column(
            children: querySnapshot.docs.map((DocumentSnapshot docc) {
              return Container(
                decoration: BoxDecoration(
                    color: Color(0xfffafffd),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                margin: EdgeInsets.only(
                    left: width * 2 / 100,
                    right: width * 2 / 100,
                    top: height * 2 / 100),
                padding: EdgeInsets.only(
                    top: height * 2 / 100, bottom: height * 2 / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyStream().ImageStream(
                            docc.data()['friendEmail'], height * 3 / 100),
                        SizedBox(
                          width: width * 2 / 100,
                        ),
                        MyStream().myNameStream(
                          docc.data()['friendEmail'],
                          TextStyle(fontSize: width * 3 / 100),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 10 / 100),
                      child: Text(
                        docc.data()['friendEmail'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 2 / 100,
                        ),
                        StatusButton(width,height,docc.data()['state'],docc.data()['friendEmail']),
                        SizedBox(
                          width: width * 2 / 100,
                        ),
                          openChatButton(docc.data()['state'], docc.data()['friendEmail'])
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          );
        });
  }

  Widget chatItems(double width, double height, Query FreindListquery) {
    return StreamBuilder<QuerySnapshot>(
        stream: FreindListquery.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: querySnapshot.docs.map((DocumentSnapshot docc) {
                return Container(
                  margin: EdgeInsets.only(top: height * 2 / 100),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => friendChat(
                                  docc.data()['friendEmail'], this.myEmail)));
                    },
                    child: Card(
                      elevation: 20,
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 2 / 100,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 2 / 100, right: width * 1 / 100),
                            child: MyStream().ImageStream(
                                docc.data()['friendEmail'], height * 4 / 100),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyStream().myNameStream(
                                docc.data()['friendEmail'],
                                TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text("this message is from ahmed")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

  Widget chat(double width, double height, List<String> onlineUser,
      Query FreindListquery) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: height * 5 / 100,
          ),
          Container(
            width: width,
            height: height * 10 / 100,
            //  color: Colors.orange,
            child: Container(
                margin: EdgeInsets.only(
                    left: width * 2 / 100, top: height * 3 / 100),
                child: Text(
                  "Chats",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: height * 5 / 100),
                )),
          ),
          Container(
            width: width,
            height: height * 10 / 100,
            // color: Colors.pink,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: onlineUser.map((e) {
                  return Container(
                      margin: EdgeInsets.only(right: width * 3 / 100),
                      child: CircleAvatar(
                          radius: height * 4 / 100,
                          backgroundImage: AssetImage('images/$e.png')));
                }).toList())),
          ),
          Container(
            height: height * 74 / 100,
            color: Colors.white38,
            child: chatItems(width, height, FreindListquery),
          ),
        ],
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile(String username) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('chats/$username');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String res = await storageReference.getDownloadURL();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Query FreindListHistoryquery = FirebaseFirestore.instance
        .collection(this.myEmail)
        .where("type", isEqualTo: "friendsList")
        .where("hasMessage", isEqualTo: "true");
    Query friendSearch;
    if (this.searchFriendController.value.text.length > 0) {
      print("yyyyyyyyyyyyyyyyyyyyyyyyy");
      friendSearch = FirebaseFirestore.instance
          .collection(searchFriendController.value.text)
          .where("type", isEqualTo: "userInfo");
    } else {
      friendSearch = FirebaseFirestore.instance
          .collection(" ")
          .where("type", isEqualTo: "userInfo");
    }

    Query FreindListquery = FirebaseFirestore.instance
        .collection(this.myEmail)
        .where("type", isEqualTo: "friendsList");

    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.people, size: 30),
            Icon(Icons.chat, size: 30),
            Icon(Icons.perm_identity, size: 30),
            Icon(Icons.settings, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.black54,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) async {
            setState(() {
              _page = index;
              controller.jumpToPage(
                index,
              );
            });
          },
        ),
        body: LayoutBuilder(
          builder: (context, Constrain) {
            double height = Constrain.maxHeight;
            double width = Constrain.maxHeight;
            return SingleChildScrollView(
              child: Container(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: PageView(
                    physics: new NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _page = index;
                      });
                    },
                    controller: controller,
                    children: [
                      Container(
                        width: width,
                        height: height,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 20 / 100,
                            ),
                            SizedBox(
                                width: width / 2,
                                child: TextField(
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.teal)),
                                      hintText: 'Tell us about yourself',
                                      labelText: 'search user',
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.green,
                                      ),
                                      prefixText: ' ',
                                      suffixStyle:
                                          const TextStyle(color: Colors.green)),
                                  controller: searchFriendController,
                                )),
                            FlatButton(
                              child: Text(
                                "search",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.pink,
                              onPressed: () async {
                                if (this.searchFriendController.value.text!=this.myEmail){
                                  var x=await FirebaseFirestore.instance
                                      .collection(this.myEmail)
                                      .where("type", isEqualTo: "friendsList").where("friendEmail", isEqualTo: this.searchFriendController.value.text).get();
                                  if (x.docs.length<=0){
                                    this.searchFriendState="noState";
                                    this.searchFriendEmail=this.searchFriendController.value.text;
                                  }
                                  else{
                                    this.searchFriendState=x.docs[0].data()['state'];
                                    this.searchFriendEmail=this.searchFriendController.value.text;
                                  }

                                  setState(() {});
                                }

                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: friendSearch.snapshots(),
                              builder: (context, stream) {
                                if (stream.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (stream.hasError) {
                                  return Center(
                                      child: Text(stream.error.toString()));
                                }

                                QuerySnapshot querySnapshot = stream.data;
                                if (querySnapshot.docs.length > 0) {
                                  return SizedBox(
                                    //width: width*70/100,
                                    child: SizedBox(
                                      width: width*80/100,
                                      height: height*20/100,


                                      child: Card(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            SizedBox(width: width*5/100,),
                                            MyStream().ImageStream(this.searchFriendController.value.text, height*4/100),
                                            SizedBox(width: width*5/100,),
                                            Text(querySnapshot.docs[0]
                                                .data()['firstName']),
                                            SizedBox(width: width*10/100,),
                                            StatusButton(width,height,this.searchFriendState,searchFriendEmail)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  print("kkkkkkkkkkkkkkkk");
                                  return Text('');
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: height * 7 / 100),
                          color: Color(0xfff0f2f5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "  MyFriends",
                                style: TextStyle(
                                    fontSize: width * 5 / 100,
                                    color: Color(0xff6a4c93)),
                              ),
                              MyFriendsList(FreindListquery, width, height),
                            ],
                          )),
                      chat(width, height, onlineUsers, FreindListHistoryquery),
                      //***** profile**************************************
                      Container(
                        color: Colors.white,
                        child: profile(width, height),
                      ),
                      //***************************************************
                      Center(
                        child: FlatButton(
                          color: Colors.pink,
                          child: Text(
                            "log out",
                            style: TextStyle(color: Color(0xff6a4c93)),
                          ),
                          onPressed: () async {
                            await Firebase.initializeApp();
                            final FirebaseAuth _auth =
                                await FirebaseAuth.instance;
                            _auth.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignIn()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
