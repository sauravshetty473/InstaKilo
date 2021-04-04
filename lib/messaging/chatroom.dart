

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/messaging/search.dart';
import 'package:discordtype/messaging/tile.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';





class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[700],
      child: Center(
        child: SpinKitRing(
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}



class ChatRoomCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final user =  Provider.of<CustomUser>(context,listen: false);

    return StreamBuilder(
      stream: DatabaseService().user.doc(user.uid).snapshots(),


      builder: (context, snapshot){
        if(snapshot.data == null)
          return Loading();

        if(!user.isperson)
          return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("You cannot chat a question anonymously", style: TextStyle(color: Colors.white),),
                  FlatButton(
                    child: Text("Login"),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                    },
                  )
                ],
              )
          );

        if(!(snapshot.data as DocumentSnapshot).exists)
          return Center(
            child: Text("Complete your profile first to start a chat", style: TextStyle(color: Colors.white),),
          );



        return StreamBuilder(
          stream: DatabaseService().chat.snapshots(),

          builder: (context, snapshot){
            if(snapshot.data == null)
              return Loading();



            var mid = (snapshot.data as QuerySnapshot);
            print(mid.size);

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color.fromARGB(255,78,100,123),
                child: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SearchUser()));
                },
              ),
              appBar: AppBar(title: Text("All Chats"),
                backgroundColor: Color.fromARGB(255,78,100,123),
                elevation: 0,

              ),
              body: ListView(
                children: mid.docs.where((element) => element.id.contains(user.uid)&&element.id.indexOf(user.uid)==0).map((e) => ListTile(

                  trailing: FlatButton(
                    minWidth: 0,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.delete_outlined),
                    onLongPress : () async{
                      await DatabaseService().chat.doc(user.uid + e.id.replaceAll(user.uid, '')).delete();
                    }
                  ),
                  leading: CircleAvatar(
                    backgroundImage: e.get("imageURL")!="null"?NetworkImage(e.get("imageURL")):AssetImage("assets/images/blank.png"), // no matter how big it is, it won't overflow
                  ),
                  title: Text(e.get("username")),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(

                        builder: (context) => ChatRoom(
                          e: e,
                          myID: user.uid,
                          otherID: e.id.replaceAll(user.uid, ''),
                        )));
                  },
                )).toList(),
              ),
            );
          },
        );
      },
    );

  }
}






class ChatRoom extends StatefulWidget {
  String otherID;
  String myID;
  DocumentSnapshot e;

  ChatRoom({this.otherID, this.myID, this.e});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20 , 20, 20),
        leading: Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: widget.e.get("imageURL")!="null"?NetworkImage(widget.e.get("imageURL")) : AssetImage("assets/images/blank.png"), // no matter how big it is, it won't overflow
          ),
        ),
        title: Text(widget.e.get("username")),
        elevation: 0,
      ),

      body: Column(

        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 20 , 20, 20),
                        Color.fromARGB(255, 100 , 100, 100),
                      ],
                    )

                ),
                child: StreamBuilder(

                  builder: (context,  snapshot){
                    if(snapshot.data == null){
                      return Loading();
                    }

                    QuerySnapshot snapshots = snapshot.data;

                    return ListView(
                        children: [
                          ...sortOutput(snapshots),
                        ]
                    );
                  },

                  stream: DatabaseService().chat.doc(widget.myID + widget.otherID).collection("Messages").orderBy('id').snapshots(),
                ),
              )
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width*0.8,
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(child: FlatButton.icon(
                    onPressed: () async{
                      if(_controller.text.trim()!="") {
                        await sendMessage(widget.myID, widget.otherID,  _controller.text);
                        _controller.text = "";

                        final nowBig = new DateTime.now();
                        String formattedDate = DateFormat('yMd').format(nowBig);               // 28/03/2020
                        String formattedTime = DateFormat('Hms').format(nowBig);

                        var myUsername = await DatabaseService().user.doc(widget.myID).get().then((value) => value.get("username"));
                        var mid = await DatabaseService().user.doc(widget.otherID).collection("Notification").add({
                          'notification' : '@' + myUsername + ' just messaged you',
                          'now' : formattedTime,
                          'date' : formattedDate,
                        });


                        print("done");
                      }
                    },
                    icon: Icon(Icons.send), label: Text("")),

                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



List<Widget> sortOutput(QuerySnapshot e){
  e.docs.forEach((element) {
    if( element.get("mine")!="true"){
      element.reference.update({
        "status" : "3"
      });
    }
  });

  List<Widget> output = new List();
  String initialDate = "00/00/0000";

  List<DocumentSnapshot> mid = e.docs;




  for(int i = 0 ; i<mid.length;i++){
    if(isGreater(mid[i].get("date"), initialDate)){                             //if new message is more recent
      initialDate = mid[i].get("date");
      final nowBig = new DateTime.now();
      if(initialDate == DateFormat('yMd').format(new DateTime.now()))
      {
        output.add(DateTile(date: "Today"));
      }
      else{
        output.add(DateTile(date: initialDate));
      }

    }
    output.add(ChatTile(status: mid[i].get("status"), date: mid[i].get("date"), time: mid[i].get("time"), content: mid[i].get("content"), mine: mid[i].get("mine") == "true"));
  }
  return output;
}



bool isGreater(String b, String a){              //is String b greater than String a
  int yb,ya,mb,ma,db,da;

  List midB = b.split("/");
  List midA = a.split("/");



  if(int.parse(midB[2])>int.parse(midA[2]))
    return true;


  if(int.parse(midB[2])<int.parse(midA[2]))
    return false;


  if(int.parse(midB[0])>int.parse(midA[0]))
    return true;


  if(int.parse(midB[0])<int.parse(midA[0]))
    return false;

  if(int.parse(midB[1])>int.parse(midA[1]))
    return true;


  if(int.parse(midB[1])<int.parse(midB[1]))
    return false;

  return false;
}


void sendMessage(String myID, String otherID, String content) async{


  final nowBig = new DateTime.now();
  String formattedDate = DateFormat('yMd').format(nowBig);               // 28/03/2020
  String formattedTime = DateFormat('Hms').format(nowBig);               // 16:05:08

  var otherName= await DatabaseService().user.doc(otherID).get().then((value) => [value.get("username"), value.get("imageURL")]);
  var myName= await DatabaseService().user.doc(myID).get().then((value) => [value.get("username"), value.get("imageURL")]);


  var length  = await DatabaseService().chat.doc(myID + otherID).collection("Messages").get().then((value) => value.docs.length);
  var otherLength  = await DatabaseService().chat.doc(otherID + myID).collection("Messages").get().then((value) => value.docs.length);
  var maxLength = max(length, otherLength);

  await DatabaseService().chat.doc(myID + otherID).set(
    {
      "username" : otherName[0],
      "imageURL" : otherName[1]
    }
  );
  await DatabaseService().chat.doc(otherID + myID).set(
      {
        "username" : myName[0],
        "imageURL" : myName[1]
      }
  );
  await DatabaseService().chat.doc(myID + otherID).collection("Messages").add({
    "content" : content.replaceAll('\\n', '\n'),
    "mine"    : "true",
    "date"    : formattedDate,
    "time"    : formattedTime,
    "status"  : "1",
    "actualTime" : DateTime.now().millisecondsSinceEpoch,
    'id' : maxLength
  });

  await DatabaseService().chat.doc(otherID + myID).collection("Messages").add({
    "content" : content.replaceAll('\\n', '\n'),
    "mine"    : "false",
    "date"    : formattedDate,
    "time"    : formattedTime,
    "status"  : "1",
    "actualTime" : DateTime.now().millisecondsSinceEpoch,
    'id' : maxLength
  });
}