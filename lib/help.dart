import 'package:discordtype/services/database.dart';
import 'package:flutter/material.dart';






var questions = ["How to post a query?"];
var answers = ["Go to the Query page of the app\nWrite a question, choose a due date, add images as attachments if necessary,\nchoose the level of the question and the course"];





class Help extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help"),
        elevation: 0,
        centerTitle: true,
      ),


      body: Column(
        children : questions.asMap().entries.map((e) => ListTile(title: Text(e.value), trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Answer(answer: answers[e.key],)));
          },

        )).toList()
      )
    );
  }
}


class Answer extends StatelessWidget {

  final String answer;
  Answer({this.answer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          answer,
          style: TextStyle(
            fontSize: 17,
        ),
        ),
      ),
    );
  }
}
