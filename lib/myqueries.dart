


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/main.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discordtype/main.dart' as main;

import 'home/post.dart' as post;
import 'messaging/chatroom.dart';






class MyQueries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mid = Provider.of<CustomUser>(context);

    
    return StreamBuilder(
      stream: DatabaseService().query.snapshots(),
      
      builder: (context, snapshot){
        if(snapshot.data == null)
          return Loading();
        
        var mines = snapshot.data as QuerySnapshot;
        
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text("My Queries"),
          ),


          body: SingleChildScrollView(
            child: Column(
              children: mines.docs.where((element) => element.get("userID") == mid.uid).map((e) {
                return post.Post(question: e.get("Question"), attachments: List.from(e.get("imageURLS")), level: e.get("level"), course: e.get("course"), due: e.get("due"), queryID: e.id, solved: e.get("solved"), mine: true, );
              }).toList(),
            ),
          ),
        );
        
      },
      
    );
  }
}

