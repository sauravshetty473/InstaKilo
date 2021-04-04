import 'package:discordtype/services/auth.dart';
import 'package:discordtype/shared/constants.dart';
import 'package:discordtype/shared/loading.dart';
import 'package:flutter/material.dart';


class Register extends StatefulWidget {
  final Function toggleView ;
  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth  = AuthService();                //for register purpose
  final _formkey = GlobalKey<FormState>();                // to validate

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              SizedBox(height: MediaQuery.of(context).size.height/5,),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
                  child: Row(
                    children: [Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(child: Center(child: Text("Register your account" , style: TextStyle(fontSize: 20),))),

                        ],
                      ), //child: Text("Already have an Account?" , style: TextStyle(fontSize: 20),),
                    ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Image(
                          image: AssetImage("assets/images/register.png"),
                        ),
                      ),


                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1 ,
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50 ,vertical: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            TextFormField(
                              decoration: idHintText("Enter your email"),
                              validator: (val)=> val.isEmpty? "Enter an email":null,
                              onChanged: (value){
                                setState(() {
                                  _formkey.currentState.validate();
                                  email = value;
                                });

                              },
                            ),

                            SizedBox(height: 20,),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: "password"),          //copy all the content in the predefined constant and add my own hintText
                              validator: (val)=> val.length<6?"Enter at least a 6 character password":null,
                              obscureText: true,
                              onChanged: (value){
                                setState(() {
                                  _formkey.currentState.validate();
                                  password = value;
                                });
                              },
                            ),
                            SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                  ),
                                  color: Colors.grey[500],
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width*1/5,
                                      child: Center(child: Text("Register", style: TextStyle(color: Colors.white ,fontSize: 20),))),
                                  onPressed: () async{
                                    if(_formkey.currentState.validate())            //true when both helper strings return null
                                        {
                                      setState(() {
                                        loading =true;
                                      });
                                      dynamic result =await _auth.registerWithEmailPassword(email, password);
                                      print(result);
                                      if(result==null)
                                      {
                                        setState(() {

                                          loading =false;
                                        });
                                      }
                                      else
                                      {

                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),

                              ],
                            ),
                            FlatButton(
                                child: Text("Log in with existing account", style: TextStyle(fontSize: 13 , color: Colors.blue[700]),),
                                onPressed: widget.toggleView
                            )
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


