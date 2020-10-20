import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStream {
  Widget ImageStream(String email, double height) {
    print(email + "nnnnnnnnnnnnnnnnnn");
    Query query = FirebaseFirestore.instance
        .collection(email)
        .where("type", isEqualTo: "userInfo");
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        QuerySnapshot querySnapshot = stream.data;

        return CircleAvatar(
          radius: height,
          backgroundImage:
              NetworkImage(querySnapshot.docs[0].data()['ImgLisk']),
        );
      },
    );
  }

  Widget myNameStream(email, TextStyle style) {
    Query query = FirebaseFirestore.instance
        .collection(email)
        .where("type", isEqualTo: "userInfo");
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        QuerySnapshot querySnapshot = stream.data;

        return Text(
          querySnapshot.docs[0].data()['firstName'].toString() +
              " " +
              querySnapshot.docs[0].data()['LastName'].toString(),
          style: style,
        );
      },
    );
  }



}
