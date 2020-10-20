import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SignIn.dart';
import 'chatPage.dart';
import 'friendChat.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth _auth = await FirebaseAuth.instance;
  final User user = await _auth.currentUser;


  runApp(homePage(user));
}
class homePage extends StatefulWidget{
  User uid;
  homePage(User uid){
    this.uid=uid;
  }
  @override
  State<StatefulWidget> createState() {
    return homePageState(this.uid);
  }

}
class homePageState extends State<homePage>{
  User uid;
  homePageState(User uid){
    this.uid=uid;
  }
  @override
  Widget build(BuildContext context) {
   if (this.uid!=null){
     print(this.uid.email.toString());
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);

     return MaterialApp(

         home:chatPage(this.uid.email.toString())
     );
   }
   else{
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);
     return MaterialApp(
         home:SignIn()
     );
   }

  }
  
}
