import 'package:cloud_firestore/cloud_firestore.dart';

Future<String >getConversationName(String myEmail,String freindEmail)async{
  var x=await FirebaseFirestore.instance.collection(freindEmail+myEmail).get();
  if (x!=null){
    return freindEmail+myEmail;
  }
  else{
    return myEmail+freindEmail;
  }
}