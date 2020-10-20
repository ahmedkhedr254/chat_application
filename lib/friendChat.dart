import 'package:chat_application/streams.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class friendChat extends StatefulWidget {
  String friendEmail ;
  String myEmail ;
  friendChat(String friendEmail,String myEmail){
    this.myEmail=myEmail;
    this.friendEmail=friendEmail;
  }

  @override
  State<StatefulWidget> createState() {
    return friendChatState(this.friendEmail,this.myEmail);
  }
}

class friendChatState extends State<friendChat> {
  final myController = TextEditingController();
  String friendEmail ;
  String myEmail ;
  friendChatState(String friendEmail,String myEmail){
    this.myEmail=myEmail;
    this.friendEmail=friendEmail;
  }



  Widget Message( String message, double width, double height,String messageEmail) {
    bool me;
    if (messageEmail==this.myEmail){
      me =true;
    }
    else{
      me=false;
    }
    var myColor;
    var myTextColor;

    if (me) {
      myColor = Colors.blueAccent;
      myTextColor = Colors.white;

    } else {

      myColor = Color(0xffe4e5eb);
      myTextColor = Colors.black;
    }

    return Container(
      margin: EdgeInsets.all(width * 2 / 100),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * 3 / 100),
            child: MyStream().ImageStream(messageEmail, height*4/100)
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(width * 3 / 100),
              child: Text(
                message,
                style: TextStyle(color: myTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var x= FirebaseFirestore.instance.collection("happy");
    print(x.get());


    Query query = FirebaseFirestore.instance
        .collection(this.myEmail).where("type",isEqualTo: "message");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Container(
              //margin: EdgeInsets.only(right: width * 0 / 100),
              child:MyStream().ImageStream(this.friendEmail, height*3/100)

            ),
            SizedBox(width: width*2/100,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyStream().myNameStream(this.friendEmail,
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                Text(
                  "active now",
                  style: TextStyle(fontSize: 15),
                )
              ],
            )
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, conistrain) {
          double bodywidth = conistrain.maxWidth;
          double bodyheight = conistrain.maxHeight;
          return Column(
            children: [
              Container(
                width: bodywidth,
                height: bodyheight * 90 / 100,
                color: Color(0xfffafffd),

                  child: StreamBuilder<QuerySnapshot>(
                    stream: query.snapshots(),
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (stream.hasError) {
                        return Center(child: Text(stream.error.toString()));
                      }

                      QuerySnapshot querySnapshot = stream.data;
                      var v=querySnapshot.docs..sort((a, b) => a.data()['date'].compareTo(b.data()['date']));
                     if (querySnapshot.docs.length==0){
                       return Text("");
                     }

                      return ListView(

                        children: v.map((DocumentSnapshot docc) {

                          return Message(
                              
                              docc.data()['message'],
                              width,
                              height,
                              docc.data()['from']
                            );
                        }).toList(),
                      );
                    },
                  ),
                ),

              Container(
                height: bodyheight * 10 / 100,
                width: width,
                color: Color(0xfffafffd),
                child: Row(
                  children: [
                    Container(width: width * 75 / 100, child: TextField(controller: myController,)),
                    FlatButton.icon(
                      onPressed: () async {


                        await FirebaseFirestore.instance
                            .collection(this.myEmail)
                            .add({"type":"message",
                          "signeture":this.friendEmail,
                          "from":this.myEmail,
                          "to":this.friendEmail,
                          "message": myController.value.text,
                          "date":DateTime.now()

                        });
                        await FirebaseFirestore.instance
                            .collection(this.friendEmail)
                            .add({"type":"message",
                          "signeture":this.myEmail,
                          "from":this.myEmail,
                          "to":this.friendEmail,
                          "message": myController.value.text,
                          "date":DateTime.now()
                        });








                        await FirebaseFirestore.instance
                            .collection(this.myEmail).doc(this.friendEmail)
                            .update({
                          "type": "friendsList",
                          "lastMessage": myController.value.text,
                          "hasMessage": "true"
                        });


                        await FirebaseFirestore.instance
                            .collection(this.friendEmail).doc(this.myEmail)
                            .update({
                          "type": "friendsList",

                          "lastMessage": myController.value.text,
                          "hasMessage": "true"
                        });








                      },
                      icon: Icon(Icons.send,color: Color(0xff3c91e6),),
                      label: Text(""),
                    ),

                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
