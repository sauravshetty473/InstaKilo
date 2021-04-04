import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/home/post.dart';
import 'package:discordtype/home/profile.dart';
import 'package:discordtype/home/queryCreation.dart';
import 'package:discordtype/messaging/chatroom.dart';
import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';


import '../main.dart' as main;
import 'appdrawer.dart';
import 'post.dart' as post;


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex;
  PageController _controller;

  void tap(int index){
    setState(() {
      _controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.linear);
      _currentIndex = index;
    });

  }


  @override
  void initState() {
    _controller = new PageController(initialPage: 0);
    _currentIndex = 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(0),
      drawerScrimColor:Colors.white.withAlpha(0),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children : [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              Home(),
              PostCreation(),
              Profile(),
            ],
          ),


          Container(
            color: Colors.black.withAlpha(100),
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 100,
                    minHeight: 80
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BottomButtons(icon: Icons.home, index: 0, currentIndex:  _currentIndex, change: tap,),
                        BottomButtons(icon: Icons.add_box_outlined, index: 1, currentIndex:  _currentIndex, change: tap,),
                        BottomButtons(icon: Icons.person, index: 2, currentIndex:  _currentIndex, change: tap,),
                      ],
                    ),
                  ),
                ),
              ],
            )
          )
        ]
      ),
    );
  }
}


// ignore: must_be_immutable
class BottomButtons extends StatelessWidget {
  IconData icon;
  Function change;
  int index;
  int currentIndex;
  double radiusOne = 30;
  double radiusTwo = 40;
  double margin = 10;

  BottomButtons({this.icon, this.change, this.index, this.currentIndex});
  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      padding: EdgeInsets.all(1),
      duration: Duration(milliseconds: 200),
      height: index==currentIndex?radiusTwo/2:radiusOne/2,
      width: index==currentIndex?radiusTwo:radiusOne,
      margin: EdgeInsets.all(index==currentIndex?margin:margin + (radiusTwo -radiusOne)/2,),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )
      ),


      child: GestureDetector(

        onTap: (){
          change(index);
        },
        child: Container(
          padding: EdgeInsets.all(2),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),

          child: FittedBox(
            child: Icon(
              icon,
              color: Color.fromARGB(255,163,63,113),
              
            ),
          )
        ),
      ),
    );

  }
}




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  String chooseLevel = 'ALL';
  String chooseCourse = 'ALL';
  String chooseSort = 'date posted';

  List levelItems = ["ALL","HighSchool[H]", "College[C]"];             //filter
  List courseItems = ["ALL","Math[M]", "Computer[CS]","medical[MED]","[BUS]"];
  List sort  = ["random", "due date" , "date posted", "alphabetically"];



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return StreamBuilder(

      stream: DatabaseService().query.snapshots(),

      builder: (context, snapshot){
        if(snapshot.data == null)
        {
          return Loading();
        }


        var query = snapshot.data as QuerySnapshot;



        return Scaffold(
          drawer: appDrawer(),
          appBar: AppBar(

            backgroundColor: Color.fromARGB(255, 20 , 20, 20),
            title: Text("Instafam"),
            centerTitle: true,
            elevation: 0,


            actions: [
              FlatButton(
                minWidth: 0,
                height: 0,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChatRoomCover()));
                },
                child: Icon(Icons.chat_outlined, color: Colors.pink,),
              )
            ],
          ),
          body: Container(
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
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                //search bar
                children: [
                  Column(
                    children: [
                      ...sortAll(query.docs.where((element) => (element.get("course")==chooseCourse||chooseCourse==courseItems[0])&&(element.get("level")==chooseLevel||chooseLevel==levelItems[0])).toList(), chooseSort).map((e) => post.Post(question: e.get("Question"), attachments: List.from(e.get("imageURLS")), level: e.get("level"), course: e.get("course"), due: e.get("due"), queryID: e.id, solved: e.get("solved"), date: e.get("now"), username: e.get("username"), userID: e.get("userID"),)).toList(),
                      Container(height: 100,),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
