import 'package:discordtype/login/register.dart';
import 'package:discordtype/login/signin.dart';
import 'package:flutter/material.dart';



class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  PageController _pagecontroller = PageController(initialPage: 0);

  bool signIn = true;

  void toggleview()
  {
    setState(() {
      signIn = !signIn;
      _pagecontroller.animateToPage(signIn?0:1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }



  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pagecontroller,
      children: [
        SignIn(this.toggleview),
        Register(this.toggleview),
      ],
    );
  }
}
