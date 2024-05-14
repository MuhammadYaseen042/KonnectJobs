import 'package:cloud_firestore/cloud_firestore.dart';

import 'modelClasses/notifications.dart';

class FirebaseNotificationService {
  final CollectionReference notificationCollection =
  FirebaseFirestore.instance.collection('notifications');

  Future<void> addNotification(NotificationModel notification) async {
    await notificationCollection.add(notification.toJSON());
  }

  Future<void> deleteNotification(String notificationId) async {
    await notificationCollection.doc(notificationId).delete();
  }

}
