import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:discordtype/home/appdrawer.dart';
import 'package:discordtype/login/authenticate.dart';
import 'package:discordtype/messaging/chatroom.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:discordtype/shared/loading.dart' as tp;
import 'package:discordtype/shared/textformfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home/home.dart';
import 'home/profile.dart';
import 'home/queryCreation.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();                                               //necessary step before using any Firebase product //best place to do this(debatable) //make main async and await
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          accentColor: Colors.black,
        ),
        home: Wrapper(),
      ),
    );
  }
}


class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);                              //Provider in the child can get values from its parent
    return user == null?Authenticate():MyHomePage();
  }
}












