import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/home/post.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:discordtype/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



var style = TextStyle(
  fontSize: 20,
  color: Colors.amber,
);



class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {





  @override
  Widget build(BuildContext context) {

    final user = Provider.of<CustomUser>(context);

    return Scaffold(
      appBar: AppBar(title: Text("You Profile",
      ),

      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 20 , 20, 20),

      elevation: 0,
      ),



      body: StreamBuilder(
        stream: DatabaseService().user.doc(user.uid).snapshots(),


        builder: (context, snapshot){
          var mid = (snapshot.data as DocumentSnapshot);

          if(snapshot.data == null)
            return Loading();

          if(!user.isperson)
            return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("You cannot create a profile anonymously"),
                    FlatButton(
                      child: Text("Login"),
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                      },
                    )
                  ],
                )
            );



          if(!mid.exists)
            return UserProfile();


          return UserProfile(user: UserValues(username: mid.get("username"), description: mid.get("description"), imageURL: mid.get("imageURL")),);
        },

      ),
    );
  }
}


// ignore: must_be_immutable
class UserProfile extends StatefulWidget {



  final UserValues user;
  UserProfile({this.user});



  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  bool pressed = false;

  final _storage = FirebaseStorage.instance;

  File image;

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = tempImage;
  }


  TextEditingController username;
  TextEditingController description;




  Future submit(BuildContext context) async{

    if(username.text.length == 0)
      {
        Fluttertoast.showToast(msg: "User field is empty");
        return;
      }

    else if(description.text.length<6)
      {
        Fluttertoast.showToast(msg: "description too small");
        return;
      }
    else{
      if(await DatabaseService().user.get().then((value) => value.docs.where((element) => element.get("username")==username.text).length!=0)&&widget.user==null){
        Fluttertoast.showToast(msg: "username already taken");
        String mid = Provider.of<CustomUser>(context, listen: false).uid;
        username.text = await DatabaseService().user.doc(mid).get().then((value) => value.get("username"));
        return "no";
      }
      String link;
      String mid = Provider.of<CustomUser>(context, listen: false).uid;
      if(image!=null){

        var snapshot = await _storage.ref()
            .child('Profile/$mid')
            .putFile(image)
            .then((storageTask) async{
          link = await storageTask.ref.getDownloadURL();
        });
      }
      else{
        if(widget.user!=null){
          if(widget.user.imageURL == null){
            link = "null";
          }
          else{
            link = widget.user.imageURL;
          }
        }
        else{
          link = "null";
        }

      }
      await DatabaseService().user.doc(mid).set({
        "username" : username.text,
        "description" : description.text.replaceAll("\\n", "\n"),
        "imageURL" : link,
      });

    }
    Fluttertoast.showToast(msg: "Profile updated successfully");
    return "yay";
  }


  @override
  void initState() {
    username = TextEditingController();
    description = TextEditingController();
    if(widget.user!=null){
      username.text = widget.user.username;
      description.text = widget.user.description;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mid = Provider.of<CustomUser>(context).uid;


    if(widget.user != null){
      username.text = widget.user.username;
    }

    ImageProvider middle;
    if(widget.user!=null){
      middle = widget.user.imageURL == "null"?AssetImage("assets/images/blank.png"):NetworkImage(widget.user.imageURL);
    }
    else{
      middle = AssetImage("assets/images/blank.png");
    }


    Widget midText;
    if(widget.user!=null){
      midText = image!=null?Text("CHANGE",style: style,):Text(widget.user.imageURL=="null"?"ADD":"CHANGE", style: style,);
    }
    else{
      midText = image!=null?Text("CHANGE", style: style,):Text("ADD", style: style,);
    }

    return Container(
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: (
            Column(


              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                ),

                CircleAvatar(
                  child: CircleAvatar(
                    backgroundImage: image!=null?FileImage(this.image): middle,
                    backgroundColor: Colors.black,
                    radius: 70,
                  ),
                  radius: 72,

                  backgroundColor: Colors.amber,
                ),


                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(50),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          border: Border.all(color: Colors.amber)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                          child: midText,
                      ),
                      onPressed: pressed?null:() async{
                        setState(() {
                          pressed = true;
                        });
                        await getImage();
                        setState(() {
                          pressed = false;
                        });
                      },
                    ),

                    SizedBox(width: 20,),
                    FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(50),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Colors.amber)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text("DELETE",
                          style: style,
                        ),
                      ),
                      onPressed: (){

                        setState(() {
                          if(widget.user!=null){
                            widget.user.imageURL ="null";
                          }

                          image = null;
                        });
                      },
                    ),

                    SizedBox(width: 20,),

                    FlatButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber.withAlpha(50),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(color: Colors.amber)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text("LOG OUT",
                          style: style,
                        ),
                      ),
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),


                Container(

                  decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(50),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.amber)),

                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text("User name",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),

                      widget.user==null? TextField(
                        controller : username,
                        decoration: InputDecoration(

                            focusColor: Colors.white,
                            hintText: "Enter username",


                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black.withAlpha(100), width: 0),
                            )

                        ),
                        maxLines: 1,
                        keyboardType:  TextInputType.emailAddress,
                      ): Text(widget.user.username),


                      SizedBox(
                        height: 40,
                      ),


                      Text("Description",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        controller : description,
                        decoration: InputDecoration(

                          focusColor: Colors.white,
                          hintText: "Enter description",

                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black.withAlpha(100), width: 0),
                            )

                        ),
                        maxLines: 1,

                      ),


                      SizedBox(height: 30,),

                      FlatButton(
                        minWidth: 0,
                        padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(10),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.amber)),

                               child: widget.user==null?Text("Submit", style: style,):Text("Update", style: style,),
                        ),
                        onPressed: () async{
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Loading()));

                          await submit(context);

                          Navigator.pop(context);
                        },
                      ),



                    ],
                  ),
                ),

                Container(
                  color: Colors.black,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 1000),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text("  My posts", style: TextStyle(color: Colors.white.withAlpha(100) , fontSize: 17),),

                        StreamBuilder(
                          stream: DatabaseService().query.snapshots(),

                          builder: (context, snapshot){
                            if(snapshot.data == null)
                              return Loading();

                            var mines = (snapshot.data as QuerySnapshot).docs.where((element) => element.get("userID")== mid);

                            return Container(
                              width: double.infinity,
                              child: Column(
                                children: mines.map((e) => Post(question: e.get("Question"), attachments: List.from(e.get("imageURLS")), level: e.get("level"), course: e.get("course"), due: e.get("due"), queryID: e.id, solved: e.get("solved"), date: e.get("now"), username: e.get("username"), userID: e.get("userID"), mine: true,)).toList(),
                              ),
                            );

                          },


                        )
                      ],
                    )
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}




class UserValues{
  UserValues({this.username, this.description, this.imageURL});
  String username;
  String description;
  String imageURL;
}