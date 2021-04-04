import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:discordtype/messaging/chatroom.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


class Post extends StatelessWidget {
  String userID;
  String username;
  String date;
  bool mine;
  String solved;
  bool notComment;
  String question;
  List<String> attachments;
  String due;
  String level;
  String course;
  String queryID;
  Post({this.question, this.attachments, this.due,this.level,this.course, this.queryID, this.notComment, this.solved, this.mine, this.username, this.date, this.userID});

  @override
  Widget build(BuildContext context) {
    var myID = Provider.of<CustomUser>(context, listen: false).uid;

    return ConstrainedBox(

      constraints: BoxConstraints(
          minHeight: 200,
        maxWidth: 2000
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            )
        ),

        margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),

            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlatButton(
                          minWidth: 0,
                          padding: EdgeInsets.all(0),
                          height: 0,
                          onPressed: (){

                          },
                          child: mine==null?Text("posted by @" +  this.username, style: TextStyle(
                              color: Colors.black.withAlpha(100)
                          ),) : Text("posted by @" +  "me", style: TextStyle(
                              color: Colors.black.withAlpha(100)
                          ),),
                        ),
                        SizedBox(height: 5,),
                        Text("" +  this.date, style: TextStyle(
                            color: Colors.black.withAlpha(100)
                        ),),

                      ],
                    ),

                  ],
                ),

                SizedBox(height: 5,),


                SizedBox(height: 10,),
                mine!=null?Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    FlatButton(

                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.amber)
                        ),
                        child: Text('delete', style: TextStyle(
                            fontSize: 20
                        ),),
                      ),
                      onLongPress : () async{
                        await DatabaseService().query.doc(queryID).delete();
                        Fluttertoast.showToast(msg: 'query deleted successfully');
                      },
                    ),
                  ],
                ):SizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),

                      child: Text("  ", style: TextStyle(
                          fontSize: 20
                      ),),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(question, style: TextStyle(
                            fontSize: 15
                        ),),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20,),


                Container(
                  height: 150,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: [
                          Text("      ", style: TextStyle(fontSize: 20),),

                          ...attachments.map((e){
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: FlatButton(
                                minWidth: 0,
                                padding: EdgeInsets.all(0),
                                child: Image(
                                  image: NetworkImage(e),
                                ),

                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ImageOpen(
                                        imageURL: e,
                                      )));
                                },
                              ),
                            );
                          }).toList(),
                        ]

                    ),
                  ),
                ),


                Divider(
                  thickness: 1,
                ),

                Row(
                  children: [
                    Row(
                      children: [
                        FlatButton(

                          minWidth: 0,
                          padding: EdgeInsets.all(0),
                          onPressed: (){

                          },
                          child: Icon(Icons.thumb_up_alt_sharp,          color: Color.fromARGB(255,163,63,113),),
                        ),





                        FlatButton(

                          minWidth: 0,
                          padding: EdgeInsets.all(0),
                          onPressed: (){

                          },
                          child: Icon(Icons.thumb_down,          color: Color.fromARGB(255,163,63,113),),
                        ),

                      ],
                    ),


                    notComment==null?Expanded(

                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Color.fromARGB(255,163,63,113),)),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            minWidth: 0,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    solved: solved,
                                    queryID: queryID,
                                    course: course,
                                    due: due,
                                    level: level,
                                    question: question,
                                    attachments: attachments,
                                    username: this.username,
                                    date: this.date,
                                    userID: this.userID,
                                  )));
                            },
                            child: Text("Comment"),
                          ),
                        ),
                      ),
                    ):SizedBox(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ImageOpen extends StatelessWidget {
  String imageURL;
  ImageOpen({this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Center(
          child: Image(
            image: NetworkImage(imageURL),
          ),
        ),
      ),
    );
  }
}






class CommentPage extends StatefulWidget {
  String userID;
  String username;
  String date;
  String solved;
  String queryID;
  String question;
  List<String> attachments;
  String due;
  String level;
  String course;
  CommentPage({this.question, this.attachments, this.due,this.level,this.course,this.queryID,this.solved, this.username, this.date, this.userID});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20 , 20, 20),
        elevation: 0,
        centerTitle: true,
        title: Text("Comments"),
      ),

      body: Stack(
        alignment: Alignment.bottomCenter,

        children : [
          Container(
            height: double.infinity,
            width: double.infinity,
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
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Column(
                    children: [

                      Post(question: widget.question, attachments: widget.attachments, level: widget.level, course: widget.course, due: widget.due, notComment: false, solved: widget.solved, username: widget.username, date: widget.date, userID: widget.userID,),

                      SizedBox(height: 5,),
                      StreamBuilder(
                        stream: DatabaseService().query.doc(widget.queryID).collection("Comment").snapshots(),


                        builder: (context, snapshot){

                          if(snapshot.data == null)
                            return Loading();

                          var mid = snapshot.data as QuerySnapshot;
                          var second = sortComments(mid);
                          return Column(
                              children: [
                                ...second.toList(),
                                SizedBox(height: 100,)
                              ]
                          );
                        },

                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                      var userID = Provider.of<CustomUser>(context, listen: false).uid;
                      if(_controller.text.trim()!="") {
                        final nowBig = new DateTime.now();
                        String formattedDate = DateFormat('yMd').format(nowBig);               // 28/03/2020
                        String formattedTime = DateFormat('Hms').format(nowBig);
                        await sendComment(comment: _controller.text, queryID: widget.queryID, userID: userID);
                        var myUsername = await DatabaseService().user.doc(userID).get().then((value) => value.get("username"));
                        var mid = userID!=widget.userID?await DatabaseService().user.doc(userID).collection("Notification").add({
                          'notification' : '@' + myUsername + ' just commented on your post',
                          'now' : formattedTime,
                          'date' : formattedDate,
                        }):'hello';
                        _controller.text = "";
                        print(mid);
                      }
                    },
                    icon: Icon(Icons.send), label: Text("")),

                )
              ],
            ),
          )
        ]
      ),
    );
  }
}






List<Widget> sortComments(QuerySnapshot e){

  List<Widget> output = new List();
  String initialDate = "00/00/0000";

  List<DocumentSnapshot> mid = e.docs;

  for(int i = 0 ; i<mid.length; i++){           //sorting by time
    for(int j=0; j<mid.length-1; j++){
      if(mid[j].get("actualTime")>mid[j+1].get("actualTime")){
        var temp = mid[j];
        mid[j] = mid[j+1];
        mid[j+1] = temp;
      }
    }
  }

  for(int i = 0 ; i<mid.length;i++){

    output.add(

        Comment(
          comment: mid[i].get("comment"),
          date: mid[i].get("date"),
          username: mid[i].get("username"),
        )

    );
  }
  return output;
}


class Comment extends StatelessWidget {
  String comment;
  String date;
  String username;
  Comment({this.comment, this.date, this.username});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,0,5,0),

      child: Card(
        child: Container(
          margin: EdgeInsets.all(1),

          padding: EdgeInsets.fromLTRB(10, 10, 10 , 20),

          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              )
          ),


          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                Text(username,style: TextStyle(
                    color: Colors.white.withAlpha(100)
                ),),
                Divider(),

                Text(comment, style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                ),),

              ]
          ),
        ),
      ),
    );
  }
}


Future sendComment({String queryID, String userID, String comment}) async{
  var username = await DatabaseService().user.doc(userID).get().then((value) => value.get("username"));
  final nowBig = new DateTime.now();
  String formattedDate = DateFormat('yMd').format(nowBig);               // 28/03/2020
  String formattedTime = DateFormat('Hms').format(nowBig);               // 16:05:08




  await DatabaseService().query.doc(queryID).collection("Comment").add({
    "comment" : comment.replaceAll('\\n', '\n'),
    "date"    : formattedDate,
    "time"    : formattedTime,
    "username" : username,
    "userID" : userID,
    "actualTime" : DateTime.now().millisecondsSinceEpoch,
  });



}




List<QueryDocumentSnapshot> sortAll(List<QueryDocumentSnapshot> input, String how){


  List mid =  input;

  if(how == "date posted"){
    for(int i = 0 ; i<mid.length; i++){           //sorting by time
      for(int j=0; j<mid.length-1; j++){
        if(isGreater(mid[j].get("now"), mid[j+1].get("now"))){
          var temp = mid[j];
          mid[j] = mid[j+1];
          mid[j+1] = temp;
        }
      }
    }

    return mid;
  }


  if(how == "due date"){
    for(int i = 0 ; i<mid.length; i++){           //sorting by time
      for(int j=0; j<mid.length-1; j++){
        if(isGreater(mid[j].get("due"), mid[j+1].get("due"))){
          var temp = mid[j];
          mid[j] = mid[j+1];
          mid[j+1] = temp;
        }
      }
    }

    return mid;
  }



  if(how == "due date"){
    for(int i = 0 ; i<mid.length; i++){           //sorting by time
      for(int j=0; j<mid.length-1; j++){
        if((mid[j].get("question")[0] as String).compareTo(mid[j+1].get("question")[0])>0){
          var temp = mid[j];
          mid[j] = mid[j+1];
          mid[j+1] = temp;
        }
      }
    }

    return mid;
  }

  return mid;
}