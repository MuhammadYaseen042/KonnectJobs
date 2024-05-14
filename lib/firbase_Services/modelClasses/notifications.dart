class NotificationModel {
  String? jobId;
  String? jobTitle;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? senderImage;
  String? time;

  NotificationModel(
      {this.jobId,
        this.jobTitle,
        this.senderName,
        this.senderId,
        this.receiverId,
        this.senderImage,
        this.time,
      });

  factory NotificationModel.fromJSON(Map<String, dynamic> json) {
   return NotificationModel(
     jobId: json['jobId'],
     jobTitle: json['jobTitle'],
     senderName: json['senderName'],
     senderId: json['senderId'],
     senderImage: json['senderImage'],
     receiverId: json['receiverId'],
     time: json['time']

   );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobId'] = this.jobId;
    data['jobTitle']=this.jobTitle;
    data['senderName'] = this.senderName;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['senderImage'] = this.senderImage;
    data['time']=this.time;
    return data;
  }
}