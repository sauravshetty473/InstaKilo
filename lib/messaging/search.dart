import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discordtype/messaging/chatroom.dart';
import 'package:discordtype/services/auth.dart';
import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class SearchUser extends StatefulWidget {


  SearchUser();
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String value = "";

  void onSearch(String val){
    setState(() {
      value = val;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for User"),
        elevation: 0.0,
        backgroundColor:  Color.fromARGB(255,78,100,123),
      ),



      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(5,5,5,5),
            width: double.infinity,
            height: MediaQuery.of(context).size.height/15,
            color: Color.fromARGB(255,78,100,123),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: TextFormField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                builder: (BuildContext context, snapshot){
                  if(snapshot.data==null){
                    return SizedBox();
                  }
                  List<List<String>> result = snapshot.data;
                  return Column(
                    children: result.map((e) {
                      if(e[0]!=""){
                        return SearchResultCards(imageURL: e[2], otherID: e[1], username: e[0],);
                      }
                      else{
                        return SizedBox();
                      }
                    }).toList(),
                  );
                },
                future: getResults(value, context),
              ),
            ),
          )
        ],
      ),
    );
  }
}





Future getResults(String input, BuildContext context) async{
  input = input.trim();

  var mid = Provider.of<CustomUser>(context).uid;
  if(input!=""){
    List<List<String>> temp = new List();
    List<List<String>> retList = new List();
    await DatabaseService().user.get().then((value) => value.docs.where((element) => element.id.indexOf(mid)!=0).forEach((element) {
      try{
        temp.add([element.get("username"),element.id ,element.get("imageURL")]);
      }
      catch(e){
        print("an error occurred");
      }
    }));
    int count=0;
    for(int i = 0 ; i<temp.length ; i++){
      if(count==10){
        break;
      }
      if(temp[i].toString().toLowerCase().contains(input.toLowerCase())){
        retList.add(temp[i]);
      }
    }
    return retList;
  }
  return [[""]];
}



class SearchResultCards extends StatelessWidget {


  String username;
  String userID;
  String imageURL;
  String myID;
  String otherID;

  CollectionReference category;
  SearchResultCards({this.username, this.otherID, this.imageURL});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return GestureDetector(
      onTap: () async{
        var mid = await DatabaseService().user.doc(otherID).get().then((value) => value);
        Navigator.push(context, MaterialPageRoute(

          builder: (context) => ChatRoom(myID: user.uid, otherID: otherID, e: mid),
        ));

      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
            height: MediaQuery.of(context).size.height/10,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/5,
                  child: Image(image:  NetworkImage(imageURL),),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(otherID,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 1,)
        ],
      ),
    );
  }
}





