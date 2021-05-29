import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthService{

  final FirebaseAuth _auth= FirebaseAuth.instance;             //creating an object


  CustomUser _cuserfromUser(User user)                         //create custom user object out of Firebase User
  {
    return user!=null?CustomUser(user.uid,!user.isAnonymous, user.email,user.emailVerified) : null;
  }

  //auth change user stream
  Stream<CustomUser> get user{                                  //<> Tell us about the type of data we receive  (getter)
    /*  return _auth.authStateChanges()                             //returning this stream whenever there is change is authentication
    //.map((User user)=>_cuserfromUser(user));                  //returning Custom made user by mapping the input (User) whenever there is an authStateChange
    .map(_cuserfromUser);                                       //works the same as above, i guess since it is a simple function with only one input(User) and one Output(CustomUser) */

    return _auth.authStateChanges().map((User user){
      if(user!=null)
      {
        if(user.emailVerified||user.isAnonymous)
        {
          Fluttertoast.showToast(msg: user.emailVerified?"your email has been verified":"Anonymous login");
          return _cuserfromUser(user);
        }
        else{
          return null;
        }}
      else{
        return _cuserfromUser(user);
      }
    });
  }


  Future signInAnon() async{                                         //sign in anonymous
    try{
      UserCredential result =await _auth.signInAnonymously();          //should be enabled in the firebase project    //AuthResult changed to UserCredential
      User user= result.user;                                          //FirebaseUser to User (object className changed)   //results attribute is user which is another object
      return _cuserfromUser(user);                                     //returning custom user without all the unwanted things
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  Future registerWithEmailPassword(String email , String password) async {                                     //register
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await user.sendEmailVerification().whenComplete(() {
        if(!user.emailVerified){
          Fluttertoast.showToast(msg: "Email Verification sent");
        }
        else{
          Fluttertoast.showToast(msg: "The email address is already verified");
        }
        return CustomUser(user.uid,!user.isAnonymous, user.email,user.emailVerified);
      });
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailPassword(String email , String password) async {                                     //sign In
    try{
      await _auth.signOut();
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      if(user.emailVerified)
        return CustomUser(user.uid,!user.isAnonymous, user.email,user.emailVerified);
      Fluttertoast.showToast(msg: 'email is not verified');
      return null;

    }
    catch(e){
      print(e.toString());

      return null;
    }
  }


  Future signOut() async {                                     //sign out
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}


class CustomUser{                                                               //a level of abstraction
  final String uid;
  final bool isperson;
  final bool isverified;
  final String emailid;
  CustomUser(this.uid,this.isperson,this.emailid,this.isverified);
}