import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konnectjob/firbase_Services/modelClasses/user.dart';

import 'modelClasses/message.dart';
class APIs {
  // for authentication
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;


  ///************** Chat Screen Related APIs **************


  // useful for getting conversation id
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModelClass user) {
    return firestore
        .collection('chats/${getConversationID(user.userId!)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots();
  }


  // for sending message
  static Future<void> sendMessage(UserModelClass userModelClass, String msg) async {
    //message sending time (also used as id)
    final time = DateTime
        .now().microsecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: userModelClass.userId!,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(userModelClass.userId!)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async{
    firestore.collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({"read":DateTime.now().microsecondsSinceEpoch.toString()});
  }


}


///convert date time.
class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}













