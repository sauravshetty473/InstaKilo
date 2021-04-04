import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService{

  final CollectionReference query = FirebaseFirestore.instance.collection("Query") ;
  final CollectionReference user = FirebaseFirestore.instance.collection("User") ;
  final CollectionReference chat = FirebaseFirestore.instance.collection("Chat") ;
  final CollectionReference comment = FirebaseFirestore.instance.collection("Comment") ;
}

