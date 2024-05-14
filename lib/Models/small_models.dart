import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerCategory {
  String titile;
  WorkerCategory({required this.titile});

  static List<WorkerCategory> workerCateList = [
    WorkerCategory(titile: "Cleaning"),
    WorkerCategory(titile: "Sweeping"),
    WorkerCategory(titile: "Digging"),
    WorkerCategory(titile: "Concrete mixing"),
    WorkerCategory(titile: "Carpenter"),
    WorkerCategory(titile: "Blacksmith"),
    WorkerCategory(titile: "Painter"),
    WorkerCategory(titile: "Plumber"),
    WorkerCategory(titile: "Electrician"),
    WorkerCategory(titile: "Marble Work"),
  ];
}

List<String> titleList = WorkerCategory.workerCateList.map((category) => category.titile).toList();
List<String>experienceLevel=["Entry level","Intermediate level","Expert"];
List<String> workDurationList=[
  "Less than 1 month",
  "Small term project",
  "Long term project",
];
///
List<String> experienceYearList = [
 "Select Experience",
  "1 to 3 years",
  "3 to 6 years",
  "9 to 9 years",
  "9 to 12 years",
  "12 to 15 years",
  "15 to 20 years",
  " More than 20 years",
];




