

import 'package:konnectjob/firbase_Services/modelClasses/user.dart';

class JobModelClass {
  String? creatorId;
  String? title;
  String? description;
  String? maxBudget;
  String? createdTime;
  String? experience;
  String? workDuration;
  String? jobId;

  JobModelClass(
      {this.creatorId,
        this.title,
        this.description,
        this.maxBudget,
        this.createdTime,
        this.experience,
        this.workDuration,
        });

  factory JobModelClass.fromJSON(Map<String, dynamic> parsedJSON) {
    return JobModelClass(
      creatorId: parsedJSON['creatorId'],
      title: parsedJSON['title'],
      description: parsedJSON['description'],
      maxBudget: parsedJSON['maxBudget'],
      createdTime: parsedJSON['createdTime'],
      experience: parsedJSON['experience'],
      workDuration: parsedJSON['workduration'],
    );
  }

  Map<String, dynamic> toJSON() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creatorId'] = this.creatorId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['maxBudget'] = this.maxBudget;
    data['createdTime']=this.createdTime;
    data['experience'] = this.experience;
    data['workduration'] = this.workDuration;
    return data;
  }
}


class SavedJobsModelClass {
  String? userId;
  JobModelClass? jobModelClass;
  UserModelClass? userModelClass;
  SavedJobsModelClass({
    this.userId,
    this.jobModelClass,
    this.userModelClass,
  });

  SavedJobsModelClass.fromJSON(Map<String, dynamic> json) {
    userId = json['userId'];
    jobModelClass = JobModelClass.fromJSON(json['jobModelClass']);
    userModelClass = UserModelClass.fromJSON(json['userModelClass']);
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['jobModelClass'] = this.jobModelClass!.toJSON(); // Convert JobModelClass to JSON
    data['userModelClass'] = this.userModelClass!.toJSON(); // Convert UserModelClass to JSON
    return data;
  }
}


class ApplicantsModel {
  String? creatorId;
  String? jobId;
  String? applicantId;
  String? cost;
  String? proposal;
  ApplicantsModel({
    this.creatorId,
    this.jobId,
    this.applicantId,
    this.cost,
    this.proposal
  });

  factory ApplicantsModel.fromJSON(Map<String, dynamic> json) {
    return ApplicantsModel(
      creatorId: json['creatorId'],
      jobId: json['jobId'],
      applicantId: json['applicantId'],
      cost: json['cost'],
      proposal: json['proposal'],
    );

  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creatorId']=this.creatorId;
    data['jobId']=this.jobId;
    data['applicantId']=this.applicantId;
    data['cost']=this.cost;
    data['proposal']=this.proposal;
    return data;
  }
}

class GovernmentSchemesModel {
  String? title;
  String? description;
  String? image;
  String? link;

  GovernmentSchemesModel({this.title, this.description, this.image, this.link});

  factory GovernmentSchemesModel.fromJSON(Map<String, dynamic> json) {
   return GovernmentSchemesModel(
       title: json['title'],
       description:json['description'],
       image: json['image'],
       link: json['link'],
   );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['link'] = this.link;
    return data;
  }
}