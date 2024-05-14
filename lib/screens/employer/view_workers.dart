import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../firbase_Services/modelClasses/user.dart';
import '../../widgets/widgets_components.dart';

class EmployerViewScreen extends StatefulWidget {
  const EmployerViewScreen({
    super.key,
  });

  @override
  State<EmployerViewScreen> createState() => _EmployerViewScreenState();
}

class _EmployerViewScreenState extends State<EmployerViewScreen> {
  List<UserModelClass> userModelClassList = [];
  List<WorkerSkillsDataModelClass> workerSkillsModelList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Workers").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final workerData = snapshot.data?.docs;
              workerSkillsModelList = workerData
                      ?.map(
                          (e) => WorkerSkillsDataModelClass.fromJSON(e.data()))
                      .toList() ??
                  [];
              if (workerSkillsModelList.isNotEmpty) {
                return ListView.builder(
                  itemCount: workerSkillsModelList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where("userId",
                              isEqualTo: workerSkillsModelList[index].workerId)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (userSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${userSnapshot.error}'));
                        } else if (userSnapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No worker found'));
                        } else {
                          var userModel = UserModelClass.fromJSON(
                              userSnapshot.data!.docs.first.data());
                          return WorkerCard(
                            userModelClass: userModel,
                            workerSkills: workerSkillsModelList[index],
                          );
                        }
                      },
                    );
                  },
                );
              } else {
                return Center(
                    child:
                        TextWidget(text: "No worker is found!", isBold: true));
              }
          }
        },
      ),
    );
  }
}
