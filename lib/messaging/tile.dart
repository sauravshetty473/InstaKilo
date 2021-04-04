import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class ChatTile extends StatelessWidget {
  String content;
  String date;
  String status;
  bool mine;
  String time;






  ChatTile({this.content, this.date, this.status, this.mine,this.time});


  @override
  Widget build(BuildContext context) {

    String temp = "";
    temp += this.time.split(":")[0];
    temp += ":";
    temp += this.time.split(":")[1];

    IconData last;
    if(this.status == "1"){
      last = Icons.check;
    }
    else if(this.status=="2"){
      last = Icons.check_circle_outline;
    }
    else{
      last = Icons.check_circle;
    }

    return Container(
      margin: this.mine?EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/6, 20, 10, 0):EdgeInsets.fromLTRB(10, 20, MediaQuery.of(context).size.width/6, 0),
      child: Align(
        alignment:this.mine?Alignment.centerRight:Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB( this.mine?20:10, 10, this.mine?10:20, 10),


          decoration: BoxDecoration(
              color: this.mine?Colors.blue:Color.fromARGB(255, 50, 50, 50),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: this.mine?Radius.circular(0):Radius.circular(20),
                bottomLeft: this.mine?Radius.circular(20):Radius.circular(0),
              )
          ),



          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Flexible(
                  child: Text(this.content,
                    style: TextStyle(color: Colors.white,
                        fontSize: 16

                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB( 10, 0, this.mine?5:0, 0),
                    child: Row(
                      children: [
                        Text(
                          temp,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                          ),
                        ),
                        mine?Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0 , 0 ,0),
                          child: Icon(last,
                            color: Colors.white,
                            size: 11,
                          ),
                        ):SizedBox(),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class DateTile extends StatelessWidget {
  String date;
  DateTile({this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),

            child: Text(
              date,
              style: TextStyle(color: Colors.black,
              ),
            )
        ),
      ),
    );
  }
}
