

import 'package:flutter/material.dart';
typedef void StringCallback(String id);


class FlipkartTextField extends StatefulWidget {
  final StringCallback onSonChanged;



  final String hintext;
  final int duration;
  final double shrinkpad;
  final double expandpad;
  final double shrinksize;
  final double expandsize;
  final number;
  final String initialvalue;
  Function validator;

  FlipkartTextField({this.hintext , this.duration =200, this.shrinkpad=10, this.expandpad=25,this.shrinksize=10,this.expandsize=15,this.number=false,this.initialvalue,this.onSonChanged,this.validator});

  @override
  _FlipkartTextFieldState createState() => _FlipkartTextFieldState();
}

class _FlipkartTextFieldState extends State<FlipkartTextField> {
  String input="";
  bool _tap = false;


  void _onChanged(String input)
  {
    widget.onSonChanged(input);
    setState(() {
      this.input = input;
      _tap=true;
    });
  }



  @override
  Widget build(BuildContext context) {
    if(widget.initialvalue!=null){
      _tap = true;
    }
    return Stack(
      children: [
        AnimatedContainer(
          padding: _tap?EdgeInsets.fromLTRB(0,widget.shrinkpad,0,0):EdgeInsets.fromLTRB(0,widget.expandpad,0,0),
          duration: Duration(milliseconds: widget.duration!=null?widget.duration:200),
          child: AnimatedDefaultTextStyle(
              child: Text(widget.hintext),
              duration: Duration(milliseconds: 200),
              style: _tap?TextStyle(
                color: Colors.blue,
                fontSize: widget.shrinksize,
              ):
              TextStyle(
                color: Colors.black,
                fontSize: widget.expandsize,
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0,10,0,0),
          child: TextFormField(
            validator: widget.validator,
            initialValue: widget.initialvalue,
            keyboardType: widget.number?TextInputType.number:TextInputType.text,
            onChanged: _onChanged,
            onTap: ()
            {
              setState(() {
                _tap = true;
              });
            },
            onEditingComplete: (){
              setState(() {
                if(input=="")
                  _tap =false;
              });
            },
          ),
        ),
      ],
    );
  }
}



// ignore: must_be_immutable
class TextOverFlow extends StatelessWidget {
  String input;
  TextOverFlow(this.input);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(input,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    );
  }
}

