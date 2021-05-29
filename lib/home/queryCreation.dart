import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:discordtype/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';




class PostCreation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);                              //Provider in the child can get values from its parent
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
                Text("You cannot post a question anonymously", style: TextStyle(color: Colors.white),),
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
            child: Text("Complete your profile first to post a query", style: TextStyle(color: Colors.white),),
          );


        return QueryPost();
      },
    );
  }
}




































class QueryPost extends StatefulWidget {
  @override
  _QueryPostState createState() => _QueryPostState();
}

class _QueryPostState extends State<QueryPost> {


  bool pressed = false;

  TextEditingController question;
  TextEditingController date;
  final _storage = FirebaseStorage.instance;

  List<File> images = [];



  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(images == null){
        images = [];
      }


      if(tempImage!=null){
        images.add(tempImage) ;
      }
    });
  }


  Future upload(String userID) async{

    String id = generateRandomString(50);
    List<String> imageURLS = [];
    final nowBig = new DateTime.now();
    String formattedDate = DateFormat('yMd').format(nowBig);               // 28/03/2020

    for(var element in images.asMap().entries.toList()) {
      String mid = element.key.toString();
      var snapshot = await _storage.ref()
          .child('Query/$id/$mid')
          .putFile(element.value)
          .then((storageTask) async{
        String link = await storageTask.ref.getDownloadURL();
        imageURLS.add(link);
      });
    }
    var username = await DatabaseService().user.doc(userID).get().then((value) => value.get("username"));
    await DatabaseService().query.doc(id).set(
        {
          "userID" : userID,
          "Question" : question.text.replaceAll("\\n", "\n"),
          "imageURLS" : imageURLS,
          "level" : valueChooseLevel,
          "course" : valueChooseCourse,
          "due"  : date.text.split('-')[1]+'/'+date.text.split('-')[2]+'/'+date.text.split('-')[0],
          "now" : formattedDate,
          "solved" : "no",
          "username" : username,
          "Likes" : <String>[]
        }
    );

    return "yay";

  }




  List levelItems = ["HighSchool[H]", "College[C]"];
  List courseItems = ["Math[M]", "Computer[CS]","medical[MED]","[BUS]"];
  String valueChooseLevel;
  String valueChooseCourse;

  @override
  void initState() {
    this.question = new TextEditingController();
    valueChooseLevel = levelItems[0];
    valueChooseCourse = courseItems[0];
    date = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor:   Color.fromARGB(255, 20 , 20, 20),
          title: Text("Create a Post"),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ConstrainedBox(

                    constraints: BoxConstraints(
                      minHeight: 200
                    ),
                    child: TextField(
                    controller: question,


                      decoration: InputDecoration(

                        focusColor: Colors.white,
                        hintText: "Write something",

                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,


                      ),
                      maxLines: null,
                    ),
                  ),
                ),



                images.length!=0?Container(
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: images.map((e){
                        if(e!=null){
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Image.file(e),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ):SizedBox(),




                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: FlatButton(
                    minWidth: 0,
                    height: 0,
                    padding: EdgeInsets.all(0),
                    onPressed: getImage,
                    child:Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withAlpha(200)),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),

                      child: Text("add images",

                      style: TextStyle(

                        color: Colors.white.withAlpha(200),
                        fontSize: 20
                      ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),


                SizedBox(height: 10,),


                Container(
                  margin: EdgeInsets.all(5),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    minWidth: 0,
                    height: 0,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.blue,
                                Colors.red,
                              ],
                            )
                        ),

                        child: Text("Confirm and post", style:
                          TextStyle(
                            fontSize: 20,
                            color: Colors.white
                          )
                          ,)),
                    onPressed: pressed?null: () async{

                      date.text = "03-29-2021";

                      if(question.text.trim().length == 0){
                        Fluttertoast.showToast(msg: "The Question is empty");




                      }

                      else if(date.text.trim().length == 0){
                        Fluttertoast.showToast(msg: "Please enter a date");
                      }

                      else{
                        pressed = !pressed;
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Loading()));


                        var temp = await upload(user.uid);

                        if(temp == "yay"){
                          Navigator.pop(context);

                          Fluttertoast.showToast(msg: "Done");
                          setState(() {
                            question.text = "";
                            date.text = "";
                            images= [];
                          });

                        }
                        else{
                          Fluttertoast.showToast(msg: "An error occurred");
                        }

                        pressed = !pressed;

                      }
                    }
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}




String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
}
