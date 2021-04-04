import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/help.dart';
import 'package:discordtype/home/profile.dart';
import 'package:discordtype/messaging/chatroom.dart';
import 'package:discordtype/myqueries.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class appDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Divider(),
            FlatButton(
              padding: EdgeInsets.all(0),
              minWidth: 0,
              child: Text("   Notification"),
              onPressed: (){

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Notification()));
              },
            ),

            Divider(),
            FlatButton(
              padding: EdgeInsets.all(0),
              minWidth: 0,
              child: Text("Help"),
              onPressed: (){

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Help()));
              },
            ),
          ],
        ),
      )
    );
  }
}


class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    var myID = Provider.of<CustomUser>(context, listen: false).uid;
    
    return StreamBuilder(
      stream: DatabaseService().user.doc(myID).collection("Notification").snapshots(),
      
      builder: (context, snapshot){
        if(snapshot.data == null)
          return Loading();
        
        
        
        return Scaffold(
          appBar: AppBar(
            title: Text("Notifications"),
            centerTitle: true,
            elevation: 0,
          ),
          
          body: ListView(
            
            children: sortNotification(snapshot.data).map((e){
              return ListTile(
                title: Text(e.get("notification")),

                trailing: FlatButton(
                    minWidth: 0,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.delete_outlined),
                    onLongPress : () async{
                      await e.reference.delete();
                    }
                ),
              );
            }).toList()
          ),
        );
      },
    );
  }
}

List<DocumentSnapshot> sortNotification(QuerySnapshot e){
  List mid = e.docs;

  for(int i = 0 ; i<mid.length; i++){           //sorting by time
    for(int j=0; j<mid.length-1; j++){
      if(mid[j].get("now")>mid[j+1].get("now")){
        var temp = mid[j];
        mid[j] = mid[j+1];
        mid[j+1] = temp;
      }
    }
  }
  return mid;
}
