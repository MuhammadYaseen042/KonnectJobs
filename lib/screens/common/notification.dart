import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import '../../firbase_Services/apis.dart';
import '../../firbase_Services/modelClasses/notifications.dart';
import '../../widgets/widgets_components.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel>? notificationsList;
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection("notifications").where("receiverId",isEqualTo: APIs.user.uid).snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final notifications = snapshot.data?.docs;

            /// Store jobIds in a list
            if(snapshot.hasData){
              notificationsList  = snapshot.data!.docs.map((e) => NotificationModel.fromJSON(e.data())).toList();
              return
                ListView.builder(
                    itemCount: notificationsList!.length,
                    itemBuilder: (context,index)=>
                    Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title:RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: notificationsList![index].senderName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: ' sent a proposal on your',
                                ),
                              ],
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: notificationsList![index].jobTitle,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: ' job',
                                ),
                              ],
                            ),
                          ),
                          trailing: Text(GetTimeAgo.parse(DateTime.parse(notificationsList![index].time.toString()))),
                        ),
                      ),
                    )
                );
        }
             else {
              return Center(child: TextWidget(text: "No Notification is found!", isBold: true));
            }
        }
      },
    );
  }
}
